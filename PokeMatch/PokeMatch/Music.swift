//
//  Music.swift
//  PokéMatch
//
//  Created by Allen Boynton on 8/7/17.
//  Copyright © 2017 Allen Boynton. All rights reserved.
//

import AVFoundation
import UIKit

// Global references
var bgMusic:  AVAudioPlayer?

class Music {
    
    // MARK: Sound files
    func startGameMusic() {
        // BG music
        let url = URL.init(fileURLWithPath: Bundle.main.path(forResource: "music", ofType: "mp3")!)
        
        do {
            bgMusic = try AVAudioPlayer(contentsOf: url)
            bgMusic?.prepareToPlay()
            bgMusic?.play()
            bgMusic?.numberOfLoops = -1
        } catch let error as NSError {
            print("audioPlayer error \(error.localizedDescription)")
        }
    }
}

extension Music {
    // Pause sound during ads
    func handleMuteMusic() {
        // Pause sound if on
        if (bgMusic?.isPlaying)! {
            // pauses music
            bgMusic?.pause()
            print("Audio muted")
        } else {
            bgMusic?.play()
            print("Audio playing")
        }
    }
}
