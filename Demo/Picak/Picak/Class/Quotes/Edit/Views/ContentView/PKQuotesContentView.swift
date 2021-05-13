//
//  PKQuotesContentView.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/21.
//

import UIKit
import AVFoundation

class PKQuotesContentView: UIView {

    weak var presenter:PKQuotesPresenter!

    private var _player:PKPlayer = PKPlayer()
    private var _quoteView:PKQuoteView?
    private let _backgroundView:PKQuoteBackgroundView = PKQuoteBackgroundView()
    private var _shouldScale = false
    
    var image:UIImage? {
        return _quoteView?.imageView.image
    }
    
    
    deinit {
        print("PKQuotesContentView deinit")
    }
    
    init(presenter:PKQuotesPresenter) {
        super.init(frame: CGRect.zero)
        
//        quoteView = PKQuoteView(withImage: UIImage(named: "0001") ?? UIImage(), maxSize: CGSize(width: 300, height: 300))
//        quoteView?.backgroundColor = UIColor.red
//        self.addSubview(quoteView!)
        
        self.addSubview(_backgroundView)
        
        self.presenter = presenter
        presenter.attach(contentView: self)
        _backgroundView.playerLayer.player = _player.player;
        
        _player.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if presenter.hwRatio == 0 || self.bounds.width == 0 || self.bounds.height == 0 {
            return
        }
        
        let ratio = self.bounds.height / self.bounds.width
        if presenter.hwRatio > ratio {
            if _shouldScale && _backgroundView.bounds.height > 0  {
                let scale = self.bounds.height / _backgroundView.bounds.height
                _backgroundView.transform = CGAffineTransform(scaleX: scale, y: scale)
                _backgroundView.center = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
            }else {
                let width = self.bounds.height / presenter.hwRatio
                let x = (self.bounds.width - width) / 2.0
                _backgroundView.frame = CGRect(x: x, y: 0, width: width, height: self.bounds.height)
            }
        }else {
            if _shouldScale && _backgroundView.bounds.width > 0  {
                let scale = self.bounds.width / _backgroundView.bounds.width
                _backgroundView.transform = CGAffineTransform(scaleX: scale, y: scale)
                _backgroundView.center = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
            }else {
                let height = self.bounds.width * presenter.hwRatio
                let y = (self.bounds.height - height) / 2.0
                _backgroundView.frame = CGRect(x: 0, y: y, width: self.bounds.width, height: height)
            }
        }
        
    }
    
}

extension PKQuotesContentView:PKPlayerDelegate {
    func playing(currentTime: CMTime) {
        self.presenter.playingTimeChange(time: currentTime)
    }
    
    func playDidEnd() {
        self.presenter.contentViewChangePlayState(false)
    }
    
    func otherPlayPause() {
        self.presenter.contentViewChangePlayState(false)
    }
}

extension PKQuotesContentView:PKQuotesContentViewProtocol {
    
    func writeImage(image: UIImage?) -> UIImage {
    
        let semaphare = DispatchSemaphore(value: 0)
        var newImage:UIImage!
        DispatchQueue.main.async {
            self._quoteView?.selected = false
            self._backgroundView.imageView.image = image
            newImage = self._backgroundView.snapshotImage!
            semaphare.signal()
        }
        semaphare.wait()
        return newImage
    }
    
    func resetImage() {
        _backgroundView.imageView.image = presenter.asset.image
    }
    
    var isPlay: Bool {
        return _player.isPlay
    }
    
    func updateTime() {
        _player.startTime = presenter.asset.beginTime
        _player.endTime = presenter.asset.endTime
    }
    
    func updateAudio() {
        _player.audioAsset = presenter.audioAsset
        _player.seek(toTime: _player.startTime)
    }
    
    func updateBackground() {
        _backgroundView.hwRatio = presenter.asset.hwRatio
        _backgroundView.imageView.image = presenter.asset.image
        if let asset = presenter.asset.asset {
            _player.asset = asset
        }
        _player.endTime = presenter.asset.endTime
    }
    
    func updateLayout() {
        _shouldScale = false
        self.setNeedsLayout()
        self.layoutIfNeeded()
        _shouldScale = true
    }
    
    func updateQuote(image: UIImage) {
        
        if _quoteView == nil {
            let maxSize = __CGSizeApplyAffineTransform(_backgroundView.frame.size, CGAffineTransform(scaleX: 0.9, y: 0.9))
            _quoteView = PKQuoteView(withImage: image, maxSize: maxSize)
            _quoteView?.center = CGPoint(x: _backgroundView.frame.width / 2.0, y: _backgroundView.frame.height / 2.0)
            _backgroundView.addSubview(_quoteView!)
            _quoteView?.delegate = self
        }else {
            _quoteView?.updateQuote(image: image)
            _quoteView?.center = CGPoint(x: _backgroundView.frame.width / 2.0, y: _backgroundView.frame.height / 2.0)
        }
        presenter.controller.showFilterView()
    }
    
    func changePlayState(_ play: Bool) {
        play ? _player.play() : _player.pause()
    }
    
    func playerSeek(time: CMTime) {
        _player.seek(toTime: time)
    }
    
    func updateQuoteFilter(name: String) {
        _quoteView?.layer.compositingFilter = name
        _backgroundView.setNeedsDisplay()
    }
    
    func updateQuoteAlpha(alpha: CGFloat) {
        _quoteView?.imageView.alpha = alpha
    }
    
    func unSelectQuote() {
        _quoteView?.selected = false
    }
}

extension PKQuotesContentView:PKQuoteViewDelegate {
    func quoteWillEdit(quote: PKQuoteView) {
        presenter.controller.showFilterView()
    }
    func quoteDidTap(quote: PKQuoteView) {
        presenter.controller.showCropView()
    }
}
