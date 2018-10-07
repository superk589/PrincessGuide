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
        
        let diff: Diff?
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
        
        var list: [VLElement] {
            let elements: [[VLElement]?] = [
                dungeonArea,
                campaign,
                story,
                clanBattle,
                questArea,
                unit,
                event,
                gacha,
                maxLv.flatMap { [$0] },
                maxRank.flatMap { [VLMaxRank(rank: $0)] }
            ]
            return elements.compactMap { $0 }.flatMap { $0 }
        }
    }
    
    let page: Int
    let pages: Int
    let data: [DataElement]
}

struct Schedule: CustomStringConvertible {
    let start: String
    let end: String
    var startDate: Date {
        return start.toDate()
    }
    var endDate: Date {
        return end.toDate()
    }
    var description: String {
        let startDateString = startDate.toString(format: "(zzz)yyyy-MM-dd HH:mm:ss", timeZone: .current)
        let endDateString = endDate.toString(format: "yyyy-MM-dd HH:mm:ss", timeZone: .current)
        return "\(startDateString) ~ \(endDateString)"
    }
}

protocol VLElement {
    var content: String { get }
    var schedule: Schedule? { get }
}

struct VLCampaign: Codable, VLElement {
    
    var content: String {
        let format = NSLocalizedString("New Campaign: %@ %@ x%d", comment: "")
        return String(format: format, categoryType.description, bonusType.description, value / 1000)
    }
    
    var schedule: Schedule? {
        return Schedule(start: start, end: end)
    }
    
    enum BonusType: Int, CustomStringConvertible {
        case unknown = 0
        case drop = 3
        case mana = 4
        
        var description: String {
            switch self {
            case .unknown:
                return NSLocalizedString("Unknown", comment: "")
            case .drop:
                return NSLocalizedString("Drop", comment: "")
            case .mana:
                return NSLocalizedString("Mana", comment: "")
            }
        }
    }
    
    enum CategoryType: Int, CustomStringConvertible {
        case unknown = 0
        case normal = 1
        case hard = 2
        case mission = 4
        case dungeon = 5
        var description: String {
            switch self {
            case .unknown:
                return NSLocalizedString("Unknown", comment: "")
            case .normal:
                return NSLocalizedString("Normal", comment: "")
            case .hard:
                return NSLocalizedString("Hard", comment: "")
            case .mission:
                return NSLocalizedString("Mission", comment: "")
            case .dungeon:
                return NSLocalizedString("Dungeon", comment: "")
            }
            
        }
    }
    
    var categoryType: CategoryType {
        let rawValue = (Int(category) ?? 0) % 10
        return CategoryType(rawValue: rawValue) ?? .unknown
    }
    
    var bonusType: BonusType {
        let rawValue = (Int(category) ?? 0) / 10
        return BonusType(rawValue: rawValue) ?? .unknown
    }
    
    let category: String
    let end: String
    let id: String
    let start: String
    let value: Int
}

struct VLClanBattle: Codable, VLElement {
    var content: String {
        let format = NSLocalizedString("New Clan Battle: %@", comment: "")
        return String(format: format, id)
    }
    
    var schedule: Schedule? {
        return Schedule(start: start, end: end)
    }
    
    let end: String
    let id: String
    let start: String
}

struct VLQuestArea: Codable, VLElement {
    var content: String {
        let format = NSLocalizedString("New Quest Area: %@", comment: "")
        return String(format: format, name)
    }
    
    var schedule: Schedule? {
        return nil
    }
    
    let id: String
    let name: String
}

struct VLEvent: Codable, VLElement {
    var content: String {
        let format = NSLocalizedString("New %@ Event: %@", comment: "")
        return String(format: format, type.description, name)
    }
    
    var schedule: Schedule? {
        return Schedule(start: start, end: end)
    }
    
    let end: String
    let id: String
    let name: String
    let start: String
    let type: EventType
    
    enum EventType: String, Codable, CustomStringConvertible {
        case story
        case tower
        
        var description: String {
            switch self {
            case .story:
                return NSLocalizedString("Story", comment: "")
            case .tower:
                return NSLocalizedString("Tower", comment: "")
            }
        }
    }
}

struct VLDungeonArea: Codable, VLElement {
    var content: String {
        let format = NSLocalizedString("New Dungeon: %@", comment: "")
        return String(format: format, name)
    }
    
    var schedule: Schedule? {
        return nil
    }
    
    let id: String
    let name: String
}

struct VLUnit: Codable, VLElement {
    var content: String {
        let format = NSLocalizedString("New Unit: %@", comment: "")
        return String(format: format, name)
    }
    
    var schedule: Schedule? {
        return nil
    }
    
    let id: String
    let name: String
    let rarity: String
    let realName: String
}

struct VLStory: Codable, VLElement {
    var content: String {
        let format = NSLocalizedString("New Story of %@", comment: "")
        return String(format: format, name)
    }
    
    var schedule: Schedule? {
        return nil
    }
    
    let id: String
    let name: String
}

struct VLGacha: Codable, VLElement {
    var content: String {
        let format = NSLocalizedString("New Gacha: %@", comment: "")
        return String(format: format, detail.replacingOccurrences(of: "\\n", with: " "))
    }
    var schedule: Schedule? {
        return Schedule(start: start, end: end)
    }
    
    let detail: String
    let end: String
    let id: String
    let start: String
}

struct VLMaxLv: Codable, VLElement {
    var content: String {
        let format = NSLocalizedString("Max Level to %@", comment: "")
        return String(format: format, lv)
    }
    
    var schedule: Schedule? {
        return nil
    }
    
    let exp: String
    let lv: String
    let maxStamina: String
}

struct VLMaxRank: Codable, VLElement {
    var content: String {
        let format = NSLocalizedString("Max Rank to %@", comment: "")
        return String(format: format, rank.description)
    }
    
    var schedule: Schedule? {
        return nil
    }
    
    let rank: String
}
