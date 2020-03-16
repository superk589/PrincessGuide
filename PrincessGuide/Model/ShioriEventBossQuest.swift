//
//  ShioriEventQuest.swift
//  PrincessGuide
//
//  Created by zzk on 3/16/20.
//  Copyright © 2020 zzk. All rights reserved.
//

import Foundation

class ShioriEventBossQuest: Codable {

    let waveGroupId1: Int
    let questName: String
    let difficulty: Int
    
    var difficultyType: DifficultyType {
        return DifficultyType(difficulty: difficulty)
    }
    
    enum DifficultyType: CustomStringConvertible {
        case unknown
        case normal
        case hard
        case veryHard
        
        var description: String {
            switch self {
            case .normal:
                return "N"
            case .hard:
                return "H"
            case .veryHard:
                return "VH"
            default:
                return NSLocalizedString("Unknown", comment: "")
            }
        }
        
        init(difficulty: Int) {
            switch difficulty {
            case 1:
                self = .normal
            case 2:
                self = .hard
            case 3:
                self = .veryHard
            default:
                self = .unknown
            }
        }
    }
    
    func preload() {
        _ = wave
    }
    
    lazy var wave: Wave? = DispatchSemaphore.sync { (closure) in
        Master.shared.getWaves(waveIDs: [waveGroupId1], callback: closure)
    }?.first
}
