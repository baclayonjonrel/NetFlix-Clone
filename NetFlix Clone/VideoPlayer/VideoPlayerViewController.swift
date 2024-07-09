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

    static let shared = VideoPlayerViewController() // Singleton instance
    
    private init() {} // Private initializer to enforce singleton
    
    func playSampleVideo(from viewController: UIViewController) {
        guard let path = Bundle.main.path(forResource: "SampleVideo", ofType:"mp4") else {
            debugPrint("SampleVideo.mp4 not found")
            return
        }
        
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        
        viewController.present(playerController, animated: true) {
            player.play()
        }
    }
}
