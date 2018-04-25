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
        self.items = items
        self.loopEnd = loopEnd
        self.loopStart = loopStart
        self.patternId = patternID
    }
}

extension AttackPattern {
    
    var varlidItems: [Int] {
        return items.filter { $0 != 0 }
    }
}
