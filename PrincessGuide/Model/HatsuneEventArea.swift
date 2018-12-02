//
//  HatsuneEventArea.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/17.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

/// HatsuneEventArea represents all the event areas like the first hatsune event, including normal and hard.
class HatsuneEventArea: Codable {
  
    struct Base: Codable {
        let areaDisp: Int
        let areaId: Int
        let areaName: String
        let endTime: String
        let eventId: Int
        let mapType: Int
        let queId: String
        let sheetId: String
        let startTime: String
        let title: String
        let waveGroupId1: Int
        let questName: String
        let difficulty: Int
    }
    
    let base: Base
    
    init(base: Base) {
        self.base = base
    }
    
    var difficultyType: DifficultyType {
        return DifficultyType(difficulty: base.difficulty)
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
    
    lazy var wave: Wave? = DispatchSemaphore.sync { (closure) in
        Master.shared.getWaves(waveIDs: [base.waveGroupId1], callback: closure)
    }?.first
    
}
