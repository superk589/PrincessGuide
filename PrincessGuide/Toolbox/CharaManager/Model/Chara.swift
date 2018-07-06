//
//  Chara.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/6.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation
import CoreData

extension Chara {
    
    var card: Card? {
        return Card.findByID(Int(id))
    }
    
    var iconID: Int? {
        if rarity >= 3 {
            return card?.iconID(style: .r3)
        } else {
            return card?.iconID(style: .r1)
        }
    }
    
    convenience init(anotherChara: Chara, context: NSManagedObjectContext) {
        self.init(context: context)
        bondRank = anotherChara.bondRank
        level = anotherChara.level
        rank = anotherChara.rank
        skillLevel = anotherChara.skillLevel
        slot1 = anotherChara.slot1
        slot2 = anotherChara.slot2
        slot3 = anotherChara.slot3
        slot4 = anotherChara.slot4
        slot5 = anotherChara.slot5
        slot6 = anotherChara.slot6
        modifiedAt = Date()
        id = anotherChara.id
        rarity = anotherChara.rarity
    }

}
