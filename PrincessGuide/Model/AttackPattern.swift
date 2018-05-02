//
//  AttackPattern.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

struct AttackPattern: Codable {
    
    let items: [Int]
    let loopEnd: Int
    let loopStart: Int
    let patternId: Int

    init(items: [Int], loopEnd: Int, loopStart: Int, patternID: Int) {
        let validItems = Array(items.prefix { $0 != 0 })
        self.items = validItems
        self.loopEnd = min(validItems.count, loopEnd)
        self.loopStart = loopStart
        self.patternId = patternID
    }
}
