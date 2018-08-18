//
//  VersionLog.swift
//  PrincessGuide
//
//  Created by zzk on 2018/8/18.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

struct VersionLog: Codable {
    
    struct DataElement: Codable {
        
        struct Diff: Codable {
            let created: Int
            let changed: Int
            let deleted: Int
        }
        
        let diff: Diff
        let ver: String
        let time: Int
        let timeStr: String
        let hash: String
        let maxRank: String?
        let maxLv: VLMaxLv?
        
        let dungeonArea: [VLDungeonArea]?
        
        let campaign: [VLCampaign]?
        
        let story: [VLStory]?
        
        let clanBattle: [VLClanBattle]?
        
        let questArea: [VLQuestArea]?
        
        let unit: [VLUnit]?
        
        let event: [VLEvent]?
        
        let gacha: [VLGacha]?
    }
    
    let page: Int
    let pages: Int
    let data: [DataElement]
}

struct VLCampaign: Codable {
    let category: String
    let end: String
    let id: String
    let start: String
}

struct VLClanBattle: Codable {
    let end: String
    let id: String
    let start: String
}

struct VLQuestArea: Codable {
    let id: String
    let name: String
}

struct VLEvent: Codable {
    let end: String
    let id: String
    let name: String
    let start: String
}

struct VLDungeonArea: Codable {
    let id: String
    let name: String
}

struct VLUnit: Codable {
    let id: String
    let name: String
    let rarity: String
    let realName: String
}

struct VLStory: Codable {
    let id: String
    let name: String
}

struct VLGacha: Codable {
    let detail: String
    let end: String
    let id: String
    let start: String
}

struct VLMaxLv: Codable {
    let exp: String
    let lv: String
    let maxStamina: String
}
