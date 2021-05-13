//
//  PKMusicListController.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/5/8.
//

import UIKit
import JXCategoryView
import MJRefresh
import SVProgressHUD

class PKMusicListController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentDuration: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    private var presenter:PKMusicListPresenter!
    lazy var player:PKPlayer = PKPlayer()
    var currentPlayIndexPah:IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.bringSubviewToFront(playBtn.superview!)
        self.presenter = PKMusicListPresenter()
        self.presenter.attach(controller: self)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            self?.presenter.refresh()
        })
        
        tableView.mj_footer = ORLoadMoreFooter(refreshingBlock: {[weak self] in
            self?.presenter.loadMore()
        })
        tableView.mj_header.beginRefreshing()
        
        
        player.delegate = self
    }
    
    func pause() {
        player.pause()
        playBtn.isSelected = false
    }
    
    @IBAction func avtion_play(_ sender: Any) {
        
        guard currentPlayIndexPah != nil else {
            return
        }
        
        playBtn.isSelected = !playBtn.isSelected;
        playBtn.isSelected ? player.play() : player.pause()
    }
    

}

extension PKMusicListController:PKMusicListControllerProtocol {
    
    func update() {
        tableView.mj_header.endRefreshing()
        tableView.mj_footer.endRefreshing()
        tableView.reloadData()
    }
    
    func loadFailure() {
        tableView.mj_header.endRefreshing()
        tableView.mj_footer.endRefreshing()
    }
    
    func endRefreshWithNoMoreData() {
        
    }
}

extension PKMusicListController:PKPlayerDelegate {
    func playing(currentTime: CMTime) {
        
        let str = ORPublicTool.or_getTimeString(time: CMTimeGetSeconds(currentTime))
        currentDuration.text = str
    }
    
    func playDidEnd() {
        playBtn.isSelected = false;
    }
    
    func otherPlayPause() {
        playBtn.isSelected = false;
    }
}

extension PKMusicListController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PKMusicCell", for: indexPath) as! PKMusicCell
        cell.json = presenter.data[indexPath.row]
        if let playIndexPath = currentPlayIndexPah {
            cell.flag.isHidden = playIndexPath.row != indexPath.row
        }
        
        if cell.btnActionClosure == nil {
            cell.btnActionClosure = {[weak self](audio) in
                SVProgressHUD.show()
                SVProgressHUD.setDefaultMaskType(.black)
                self?.player.pause()
                let toFile = URL(fileURLWithPath: PK_DOWNLOAD_PATH + "/audio." + audio.pathExtension)
                PKNetTool.down(url: audio, to:toFile) { (progress) in
                    SVProgressHUD.showProgress(progress, status: String(Int(progress * 100)) + "%")
                } completionHandler: { (msg) in
                    SVProgressHUD.dismiss()
                    SVProgressHUD.setDefaultMaskType(.none)
                    NotificationCenter.default.post(name: useAudioNotificationName, object: nil, userInfo: [useAudioNotificationAudioUrlKey : toFile])
                    self?.navigationController?.popViewController(animated: false)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! PKMusicCell
        
        if let playIndexPath = currentPlayIndexPah {
            
            if playIndexPath.row != indexPath.row {
                let lastCell = tableView.cellForRow(at: playIndexPath) as! PKMusicCell
                lastCell.flag.isHidden = true
                let json = presenter.data[indexPath.row]
                player.asset = AVAsset(url: json["mp4_file"].url!)
            }
            
        }else {
            let json = presenter.data[indexPath.row]
            player.asset = AVAsset(url: json["mp4_file"].url!)
        }
        currentPlayIndexPah = indexPath
        cell.flag.isHidden = false
        player.play()
        playBtn.isSelected = true
    }
}

extension PKMusicListController: JXCategoryListContentViewDelegate {
    func listView() -> UIView! {
        return self.view
    }
    func listWillAppear() {
    }
    func listWillDisappear() {
        player.pause()
        print("listWillDisappear")
    }
    
}
