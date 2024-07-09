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
        
        // Set modal presentation style to fullscreen
        playerController?.modalPresentationStyle = .fullScreen
        
        // Present the player controller
        viewController.present(playerController!, animated: true) {
            self.player?.play()
        }
        
        // Add observer for player controller dismissal
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    @objc private func playerDidFinishPlaying() {
        // Stop the player when playback finishes
        player?.pause()
    }
}
