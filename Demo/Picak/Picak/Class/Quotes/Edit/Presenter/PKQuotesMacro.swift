//
//  PKQuotesMacro.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/25.
//

import Foundation

let useImageNotificationName = NSNotification.Name("useImageNotificationName")
let useImageNotificationImageUserInfoKey = "useImageNotificationImageUserInfoKey"

let useAudioNotificationName = NSNotification.Name("useAudioNotificationName")
let useAudioNotificationAudioUrlKey = "useAudioNotificationAudioUrlKey"

protocol PKQuotesControllerProtocol:class {
    func hideHud()
    func exportHud(progress:Float)
    func exportSuccess()
    func hideBottom()
    func showFilterView()
    func showCropView()
    func update()
    func selectQuoteOption(type:PKQuoteSelectOption)
}

protocol PKQuotesContentViewProtocol:class {
    var isPlay:Bool { get }
    
    func updateTime()
    func updateBackground()
    func updateQuote(image:UIImage)
    func updateAudio()
    func updateLayout()
    func changePlayState(_ play:Bool)
    func playerSeek(time:CMTime)
    func updateQuoteFilter(name:String)
    func updateQuoteAlpha(alpha:CGFloat)
    func unSelectQuote()
    func writeImage(image:UIImage?)->UIImage
    func resetImage()
}

protocol PKQuotesTimelineViewProtocol:class {
    func updateTimeLine()
    func changePlayState(_ play:Bool)
    func adjustTimeLineOffset(time:CMTime)
}

enum PKQuoteSelectOption:Int {
    case library = 0
    case custom
    case local
}

struct PKQuoteFilter {
    var type:PKQuoteFilterType!
    var imageName:String!
    var title:String!
}

enum PKQuoteFilterType:String {
    case normalBlendMode
    case multiplyBlendMode
    case darkenBlendMode
    case colorBurnBlendMode
    case lightenBlendMode
    case screenBlendMode
    case colorDodgeBlendMode
    case overlayBlendMode
    case softLightBlendMode
    case hardLightBlendMode
    case differenceBlendMode
    case exclusionBlendMode
}

struct PKQuoteSize {
    var whRatio:CGFloat!
    var title:String!
    var size:CGSize!
}
