//
//  PKPlayer.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/21.
//

import UIKit
import AVFoundation

protocol PKPlayerDelegate:class {
    func playing(currentTime:CMTime)
    func playDidEnd()
    func otherPlayPause()
}

class PKPlayer: NSObject {

    weak var delegate:PKPlayerDelegate?

    var startTime:CMTime = CMTime.zero {
        didSet {
            player.seek(to: startTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
    }
    var endTime:CMTime = CMTime.zero

    let player = AVPlayer()
    let audioPlayer = AVPlayer() //从0开始
    
    var playerItem:AVPlayerItem?
    var asset:AVAsset? {
        didSet {
            if asset != nil {
                NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
                playerItem = AVPlayerItem(asset: asset!)
                player.replaceCurrentItem(with: playerItem)
                startTime = CMTime.zero
                endTime = asset?.duration ?? CMTime.zero
                NotificationCenter.default.addObserver(self, selector: #selector(self._playEnd), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
            }
        }
    }
    var audioAsset:AVAsset? {
        didSet {
            if let audio = audioAsset {
                player.volume = 0
                audioPlayer.replaceCurrentItem(with: AVPlayerItem(asset: audio))
            }else {
                player.volume = 1
                audioPlayer.replaceCurrentItem(with: nil)
            }
        }
    }
    
    var currentTime:CMTime {
        get {
            return _currentTime - startTime
        }
    }
    var isPlay: Bool {
        return  !_displayLink.isPaused
    }
    
    private var _displayLink:CADisplayLink!
    private var _currentTime:CMTime = CMTime.zero
    private var _isPlayEnd = false
    
    deinit {
        print("PKPlayer deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    override init() {
        super.init()
        _displayLink = CADisplayLink(target: self, selector: #selector(self._playing))
        _displayLink.isPaused = true
        _displayLink.preferredFramesPerSecond = 20
        _displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self._resignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    
    func pause() {
        
        if _displayLink.isPaused {
            return
        }
        _displayLink.isPaused = true
        player.pause()
        audioPlayer.pause()
    }
    
    func play() {
        _displayLink.isPaused = false
        
        if _isPlayEnd {
            player.seek(to: startTime) { [weak self] (finishd) in
                if finishd {
                    if let strongSelf = self  {
                        strongSelf._isPlayEnd = false
                        strongSelf.player.play()
                    }
                }
            }
            audioPlayer.seek(to: CMTime.zero) { [weak self] (finishd) in
                if finishd {
                    if let strongSelf = self  {
                        strongSelf.audioPlayer.play()
                    }
                }
            }
        }else {
            player.play()
            audioPlayer.play()
        }
        

    }
    
    func seek(toTime time:CMTime) {
        pause()
        if time > endTime {
            _isPlayEnd = true
            return
        }
        var seekTime = time
        if time < startTime {
            seekTime = startTime
        }
        _isPlayEnd = false
        _currentTime = seekTime
        if (playerItem != nil)  {
            player.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
        if audioAsset != nil {
            let audioTime = seekTime - startTime
            audioPlayer.seek(to: audioTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
    }
    
    @objc private func _playing() {
        if (playerItem != nil)  {
            _currentTime = player.currentTime()
        } else {
            _currentTime = _currentTime + CMTime(seconds: 0.05, preferredTimescale: 600)
        }
        
        if _currentTime > endTime {
            _playEnd()
            return
        }
        
        if let d = delegate {
            d.playing(currentTime: _currentTime - startTime)
        }
    }
    
    @objc private func _playEnd() {
        _isPlayEnd = true
        pause()
        if let d = delegate {
            d.playDidEnd()
        }
    }
    
    @objc private func _resignActive() {
        if _displayLink.isPaused {
            return
        }
        pause()
        if let d = delegate {
            d.otherPlayPause()
        }
    }
    
}
