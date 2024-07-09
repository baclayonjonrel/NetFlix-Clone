//
//  VideoPlayerViewController.swift
//  NetFlix Clone
//
//  Created by Jonrel Baclayon on 7/9/24.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayerViewController {

    static let shared = VideoPlayerViewController()
    
    private init() {}
    
    private var playerController: AVPlayerViewController?
    private var player: AVPlayer?
    
    func playSampleVideo(from viewController: UIViewController) {
        guard let path = Bundle.main.path(forResource: "SampleVideo", ofType:"mp4") else {
            debugPrint("SampleVideo.mp4 not found")
            return
        }
        
        player = AVPlayer(url: URL(fileURLWithPath: path))
        playerController = AVPlayerViewController()
        playerController?.player = player
        
        playerController?.modalPresentationStyle = .fullScreen
        
        viewController.present(playerController!, animated: true) {
            self.player?.play()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    @objc private func playerDidFinishPlaying() {
        player?.pause()
        playerController?.dismiss(animated: true, completion: {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
            
            self.player = nil
            self.playerController = nil
        })
    }
}
