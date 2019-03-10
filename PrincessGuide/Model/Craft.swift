//
//  Craft.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/3.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

struct Craft {
    
    class Consume {
        let equipmentID: Int
        let consumeNum: Int
        
        init(equipmentID: Int, consumeNum: Int) {
            self.equipmentID = equipmentID
            self.consumeNum = consumeNum
        }
        
        lazy var equipment: Equipment? = {
            return DispatchSemaphore.sync { closure in
                Master.shared.getEquipments(equipmentID: equipmentID, callback: closure)
                }?.first
        }()
    }
    
    let consumes: [Consume]
    let craftedCost: Int
    let equipmentId: Int
}

extension Craft.Consume {
    var itemURL: URL {
        return URL.resource.appendingPathComponent("icon/equipment/\(equipmentID).webp")
    }
}
