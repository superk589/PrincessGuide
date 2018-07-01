//
//  CharaStory.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

struct CharaStory: Codable {
    
    let storyID: Int
    let charaID: Int
    let loveLevel: Int
    
    let status: [Status]
    
    struct Status: Codable {
        let type: Int
        let rate: Int
        
        func property() -> Property.Item {
            return Property.Item(key: PropertyKey(charaStoryStatusType: type), value: Double(rate))
        }
    }
}

extension PropertyKey {
    
    init(charaStoryStatusType: Int) {
        switch charaStoryStatusType {
        case 11:
            self = .waveEnergyRecovery
        case 10:
            self = .waveHpRecovery
        case 15:
            // FIXME: 12 - 14 no charas have, 15 validation needed
            self = .hpRecoveryRate
        case 8:
            self = .dodge
        case 9:
            self = .lifeSteal
        case 6:
            self = .physicalCritical
        case 7:
            self = .magicCritical
        case 5:
            self = .magicDef
        case 4:
            self = .magicStr
        case 3:
            self = .def
        case 2:
            self = .atk
        case 1:
            self = .hp
        default:
            self = .unknown
        }
    }
}
