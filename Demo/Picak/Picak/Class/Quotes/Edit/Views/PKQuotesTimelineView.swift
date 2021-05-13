//
//  PKQuotesBottomView.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/23.
//

import UIKit
import SnapKit

class PKQuotesTimelineView: UIView {

    private let _playBtn = UIButton(type: .custom)
    private let _timeLineView:VITimelineView = VITimelineView()
    
    weak var presenter:PKQuotesPresenter!
    
    init(presenter:PKQuotesPresenter) {
        super.init(frame: CGRect.zero)
        
        self.presenter = presenter
        presenter.attach(timelineView: self)
        _initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _initUI() {
        
        _playBtn.setImage(UIImage(named: "pk_play"), for: .normal)
        _playBtn.setImage(UIImage(named: "pk_pause"), for: .selected)
        _playBtn.addTarget(self, action: #selector(self.playAction(sender:)), for: .touchUpInside)
        
        _timeLineView.contentWidthPerSecond = 25
        _timeLineView.rangeViewLeftInset = 1
        _timeLineView.rangeViewRightInset = 1
        _timeLineView.delegate = self
        _timeLineView.rangeViewDelegate = self
        _timeLineView.scrollView.delegate = self
        let ciImage = CIImage(color: CIColor(red: 1, green: 1, blue: 1))
        let cgImage = CIContext().createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: 2, height: 50))
        _timeLineView.centerLineView.image = UIImage(cgImage: cgImage!)
        
        self.addSubview(_playBtn)
        self.addSubview(_timeLineView)
        
        _playBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(0)
            make.width.equalTo(40)
        }
        
        _timeLineView.snp.makeConstraints { (make) in
            make.left.equalTo(_playBtn.snp.right)
            make.top.bottom.right.equalTo(0)
        }
        
    }
    
    @objc func playAction(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        presenter.timelineViewChangePlayState(sender.isSelected)
    }
    
}

extension PKQuotesTimelineView:PKQuotesTimelineViewProtocol {
    
    func updateTimeLine() {
        let asset = presenter.asset.asset != nil ? presenter.asset.asset : presenter.asset.image
        let rangeView = VIRangeView.imageRangeView(withAsset: asset!, imageSize: CGSize(width: 40 / presenter.asset.hwRatio, height: 40))
        rangeView.leftEarView.backgroundColor = UIColor.white
        rangeView.rightEarView.backgroundColor = UIColor.white
        rangeView.backgroundView.backgroundColor = UIColor.white
        rangeView.layer.cornerRadius = 2
        rangeView.clipsToBounds = true
        _timeLineView.insertRangeView(rangeView, at: 0)
    }
    
    func changePlayState(_ play: Bool) {
        _playBtn.isSelected = play
    }
    
    func adjustTimeLineOffset(time: CMTime) {
        _timeLineView.adjustScrollOffset(at: time)
    }
    
}

extension PKQuotesTimelineView:VITimelineViewDelegate {
    func timelineView(_ view: VITimelineView, didChangeActive isActive: Bool) {
        
    }
}

extension PKQuotesTimelineView:VIRangeViewDelegate {
    func rangeView(_ rangeView: VIRangeView!, didChangeActive isActive: Bool) {
        
    }
    
    func rangeViewBeginUpdateLeft(_ rangeView: VIRangeView!) {
        
    }
    
    func rangeView(_ rangeView: VIRangeView!, updateLeftOffset offset: CGFloat, isAuto: Bool) {
        presenter.timelineStartTimeChange(time: rangeView.startTime)
        _playBtn.isSelected = false
    }
    
    func rangeViewEndUpdateLeftOffset(_ rangeView: VIRangeView!) {
        
    }
    
    func rangeViewBeginUpdateRight(_ rangeView: VIRangeView!) {
        
    }
    
    func rangeView(_ rangeView: VIRangeView!, updateRightOffset offset: CGFloat, isAuto: Bool) {
        presenter.timelineEndTimeChange(time: rangeView.endTime)
        _playBtn.isSelected = false
    }
    
    func rangeViewEndUpdateRightOffset(_ rangeView: VIRangeView!) {
        
    }
}

extension PKQuotesTimelineView:UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.width == 0 {
            return
        }
        
        if scrollView.isDragging {
            self.presenter.timelineScollTimeChange(time: _timeLineView.calculateTime(atOffsetX: scrollView.contentOffset.x))
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.presenter.timelineViewChangePlayState(false)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if _playBtn.isSelected {
            self.presenter.timelineViewChangePlayState(true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false && _playBtn.isSelected {
            self.presenter.timelineViewChangePlayState(true)
        }
    }
}
