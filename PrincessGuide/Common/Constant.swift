//
//  Constant.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/10.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

struct Constant {
    static let appID = 1377498032
    static let iAPProductIDs: Set<String> = ["princess_guide_pro_edition"]
    static let calendarPrefix = "Hatsune's Notes "
    static let appBundle = "com.zzk.PrincessGuide"
    static let appName = "Hatsune's Notes"
    static let appNameHashtag = "HatsunesNotes"
    static let presetMaxRank = 10
    static let presetMaxPlayerLevel = 102
    static let presetMaxEnemyLevel = 120
    static let presetMaxUniqueEquipmentLevel = 130
    static let presetMaxBondRank = 8
    static let presetMaxRarity = 5
    static let presetManaCostPerPoint = [
        2: 120,
        3: 150,
        4: 200,
        5: 200
    ]
    static let presetNeededToLevelUpSkillCount = 4
}

extension URL {
    static let resource = URL(string: "https://redive.estertion.win")!
}

struct Path {
    static let cache = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    static let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    static let library = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
    static let home = NSHomeDirectory()
    
    // include the last "/"
    static let temporary = NSTemporaryDirectory()
}
