//
//  Playlist.swift
//  PrincessGuide
//
//  Created by zzk on 2018/10/20.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation
import AVFoundation

class Playlist {
    
    var currentVoice: Voice?
    
    var progress = 0.0
    
    private var player: AVAudioPlayer?
    
    private var observation: NSKeyValueObservation?
    
    var updateClosure: ((Double) -> Void)?
    
    func play(_ voice: Voice) {
        player?.stop()
        player = try? AVAudioPlayer(data: voice.data)
        player?.play()
        currentVoice = voice
        observation = player?.observe(\.currentTime, changeHandler: { [weak self] (player, change) in
            if let newValue = change.newValue {
                let progress = newValue / player.currentTime * 100
                self?.progress = progress
                self?.updateClosure?(progress)
            }
        })
    }

}
