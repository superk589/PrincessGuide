//
//  Battle.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/13.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation
import CoreData

extension Battle {
    
    convenience init(anotherBattle: Battle, context: NSManagedObjectContext) {
        self.init(context: context)
        modifiedAt = Date()
        attackerWins = anotherBattle.attackerWins
        attacker = anotherBattle.attacker
        defender = anotherBattle.defender
    }
    
}
