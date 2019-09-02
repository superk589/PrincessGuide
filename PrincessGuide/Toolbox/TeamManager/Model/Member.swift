//
//  Member.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/10.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation
import CoreData

extension Member {

    convenience init(anotherMember: Member, context: NSManagedObjectContext) {
        self.init(context: context)
        id = anotherMember.id
        rarity = anotherMember.rarity
        level = anotherMember.level
        enablesUniqueEquipment = anotherMember.enablesUniqueEquipment
    }
    
    convenience init(card: Card, context: NSManagedObjectContext) {
        self.init(context: context)
        id = Int32(card.base.unitId)
        rarity = Int16(card.base.rarity)
        level = Int16(Preload.default.maxPlayerLevel)
        enablesUniqueEquipment = card.uniqueEquipments.count > 0
    }
    
    var card: Card? {
        return Card.findByID(Int(id))
    }
    
    var iconURL: URL? {
        if rarity >= 6 {
            return card?.iconURL(style: .highestRarity)
        } else if rarity >= 3 {
            return card?.iconURL(style: .r3)
        } else {
            return card?.iconURL(style: .r1)
        }
    }

}
