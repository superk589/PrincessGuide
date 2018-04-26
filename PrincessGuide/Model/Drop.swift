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
    }
    
    let dropCount: Int
    let dropRewardId: Int
    
    let rewards: [Reward]
    
}
