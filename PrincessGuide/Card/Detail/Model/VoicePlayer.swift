//
//  VoicePlayer.swift
//  PrincessGuide
//
//  Created by zzk on 2018/10/20.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation
import AVFoundation

class VoicePlayer {
    
    var currentVoice: Voice?
    
    var progress = 0.0
    
    private var player: AVAudioPlayer?
    
    private var observation: NSKeyValueObservation?
    
    var updateClosure: ((Double) -> Void)?
    
    func play(_ voice: Voice) {
        
        // fix a potential crash on iOS 10
        observation?.invalidate()
        
        player?.stop()
        player = try? AVAudioPlayer(data: voice.data)
        player?.play()
        print("playing: \(voice.url)")
        currentVoice = voice
        observation = player?.observe(\.currentTime, changeHandler: { [weak self] (player, change) in
            if let newValue = change.newValue {
                let progress = newValue / player.currentTime * 100
                self?.progress = progress
                self?.updateClosure?(progress)
            }
        })
    }
    
    deinit {
        // fix a potential crash on iOS 10
        observation?.invalidate()
    }

}
