//
//  PKQuotesPresenter.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/21.
//

import UIKit

class PKQuotesPresenter: NSObject {

    private (set) var asset:PKAsset!
    weak var controller:PKQuotesControllerProtocol!
    weak var contentView:PKQuotesContentViewProtocol!
    weak var timelineView:PKQuotesTimelineViewProtocol!
    var audioAsset:AVAsset?
    
    var writeService:FEVideoWriteService?
    
    
    var hwRatio:CGFloat = 1 {
        didSet {
            self.contentView.updateLayout()
        }
    }

    deinit {
        print("PKQuotesPresenter deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.action_useImage(notifcation:)), name: useImageNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.action_useAudio(notifcation:)), name: useAudioNotificationName, object: nil)

    }
    
    func attach(controller c:PKQuotesControllerProtocol) {
        self.controller = c
    }
    func attach(contentView view:PKQuotesContentViewProtocol) {
        self.contentView = view
    }
    func attach(timelineView view:PKQuotesTimelineViewProtocol) {
        self.timelineView = view
    }
    
    func config(imageUrl:URL?, assetUrl:URL?) {
        
        let queue = DispatchQueue(label: "com.configQuotes.pk")
        queue.async {
            if let imgUrl = imageUrl {
                self.asset = PKAsset(imageUrl: imgUrl)
            } else {
                self.asset = PKAsset(assetUrl: assetUrl!)
            }
            DispatchQueue.main.async {
                self.hwRatio = self.asset.hwRatio
                self.controller.update()
                self.contentView.updateBackground()
                self.contentView.updateLayout()
                self.timelineView.updateTimeLine()
            }
        }
        
    }
    
    
    @objc private func action_useImage(notifcation:Notification) {
        let image:UIImage! = notifcation.userInfo?[useImageNotificationImageUserInfoKey] as? UIImage
        self.contentView.updateQuote(image: image)
    }
    
    @objc private func action_useAudio(notifcation:Notification) {
        let url:URL! = notifcation.userInfo?[useAudioNotificationAudioUrlKey] as? URL
        self.audioAsset = AVAsset(url: url)
        self.contentView.updateAudio()
    }
}

// MARK: - controller
extension PKQuotesPresenter {
    
    func updateQuote(imageUrl:URL) {
        let queue = DispatchQueue(label: "com.updateQuote.pk")
        queue.async {
            let image = UIImage(contentsOfFile: imageUrl.path)
            DispatchQueue.main.async {
                self.contentView.updateQuote(image: image!)
            }
        }
    }
    
    func save() {
        
        DispatchQueue(label: "com.pk.exportQuote").async {
            let outputPath = PK_TEMP_PATH + "/quoteVideo.mp4"
            self.writeService = FEVideoWriteService(videoAsset: self.asset.asset, outputPath: outputPath)
            self.writeService?.isSaveAlbum = true

            if let assetImage = self.asset.image {
                
                let image = self.contentView.writeImage(image: assetImage)
                
                self.writeService?.fe_write(withDuration: self.asset.endTime - self.asset.beginTime, image: image, audioAsset: self.audioAsset, progressBlock: { [weak self](progress) in
                    DispatchQueue.main.async {
                        self?.controller.exportHud(progress: progress)
                    }
                }, completion: { [weak self](error) in
                    self?.controller.exportSuccess()
                    self?.contentView.resetImage()
                })
            }else {
                self.writeService?.fe_write(withBegin: self.asset.beginTime, end: self.asset.endTime, audioAsset: self.audioAsset, writeBufferBlock: { [weak self](image, progress) -> Unmanaged<CVPixelBuffer> in
                    let writeImage:UIImage! = self?.contentView.writeImage(image: image)
                    DispatchQueue.main.async {
                        self?.controller.exportHud(progress: progress)
                    }
                    return writeImage.or_pixelBuffer()
                }, completion: { [weak self](error) in
                    self?.controller.exportSuccess()
                    self?.contentView.resetImage()
                })
            }
        }
    }
}

// MARK: - contentView
extension PKQuotesPresenter {
    func contentViewChangePlayState(_ play:Bool) {
        timelineView.changePlayState(play)
    }
    func playingTimeChange(time:CMTime) {
        timelineView.adjustTimeLineOffset(time: time)
    }
}

// MARK: - timeline
extension PKQuotesPresenter {
    func timelineViewChangePlayState(_ play:Bool) {
        contentView.changePlayState(play)
    }
    func timelineScollTimeChange(time:CMTime) {
        contentView.playerSeek(time: time + asset.beginTime)
    }
    func timelineStartTimeChange(time:CMTime) {
        asset.beginTime = time
        contentView.updateTime()
        contentView.playerSeek(time: time)
    }
    func timelineEndTimeChange(time:CMTime) {
        asset.endTime = time
        contentView.updateTime()
        contentView.playerSeek(time: time)
    }
}
