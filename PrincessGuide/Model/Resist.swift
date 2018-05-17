//
//  Resist.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/17.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

struct Resist: Codable {

    struct Item: Codable {
        let ailment: Ailment
        let rate: Int
    }
    
    let items: [Item]
    
    init(items: [Item]) {
        self.items = items
    }
}
