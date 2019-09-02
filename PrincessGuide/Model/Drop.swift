//
//  Drop.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

struct Drop: Codable {
    
    struct Reward: Codable {
        let odds: Int
        let rewardID: Int
        let rewardNum: Int
        let rewardType: Int
        
        var iconURL: URL? {
            switch rewardType {
            case 2:
                return URL.resource.appendingPathComponent("icon/item/\(rewardID).webp")
            case 4:
                return URL.resource.appendingPathComponent("icon/equipment/\(rewardID).webp")
            default:
                return nil
            }
        }
    }
    
    let dropCount: Int
    let dropRewardId: Int
    
    let rewards: [Reward]
    
}
