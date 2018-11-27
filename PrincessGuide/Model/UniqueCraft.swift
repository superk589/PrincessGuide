//
//  UniqueCraft.swift
//  PrincessGuide
//
//  Created by zzk on 2018/11/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

struct UniqueCraft: Codable {
    
    class Consume: Codable {
        let itemID: Int
        let consumeNum: Int
        let rewardType: Int
        
        init(itemID: Int, consumeNum: Int, rewardType: Int) {
            self.itemID = itemID
            self.consumeNum = consumeNum
            self.rewardType = rewardType
        }
    }
    
    let consumes: [Consume]
    let craftedCost: Int
    let equipmentId: Int
}

extension UniqueCraft.Consume {
    var itemURL: URL {
        switch rewardType {
        case 2:
            return URL.resource.appendingPathComponent("icon/item/\(itemID).webp")
        default:
            return URL.resource.appendingPathComponent("icon/equipment/\(itemID).webp")
        }
    }
}
