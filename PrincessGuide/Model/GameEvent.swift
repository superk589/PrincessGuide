//
//  GameEvent.swift
//  PrincessGuide
//
//  Created by zzk on 2019/5/12.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation

protocol GameEvent {
    
    var startDate: Date { get }
    var endDate: Date { get }
    var name: String { get }
    var type: GameEventType { get }
    
}

extension GameEvent {
    var title: String {
        return type.description + " " + name
    }
}

enum GameEventType: String, Codable, CustomStringConvertible {
    case campaign
    case story
    case gacha
    case tower
    case clanBattle
    
    var description: String {
        switch self {
        case .campaign:
            return NSLocalizedString("Campaign", comment: "")
        case .story:
            return NSLocalizedString("Story Event", comment: "")
        case .gacha:
            return NSLocalizedString("Gacha", comment: "")
        case .tower:
            return NSLocalizedString("Luna's Tower", comment: "")
        case .clanBattle:
            return NSLocalizedString("Clan Battle", comment: "")
        }
    }
}

struct CampaignEvent: GameEvent {
    var startDate: Date
    
    var endDate: Date
    
    var name: String
    
    var type: GameEventType = .campaign
    
    var bonusType: CampaignEventCategory.BonusType
    
    var categoryType: CampaignEventCategory.CategoryType
    
    init(startDate: Date, endDate: Date, category: Int, value: Double) {
        let campaignEventCategory = CampaignEventCategory(rawValue: category) ?? .none
        self.categoryType = campaignEventCategory.categoryType
        self.bonusType = campaignEventCategory.bonusType
        let name: String
        let format = NSLocalizedString("%@ %@ x%@", comment: "")
        name = String(format: format, categoryType.description, bonusType.description, String(format: "%.1f", Double(value) / 1000))
        self.startDate = startDate
        self.endDate = endDate
        self.name = name
    }
}

struct StoryEvent: GameEvent {
    var startDate: Date
    
    var endDate: Date
    
    var name: String
    
    var type: GameEventType = .story
}

struct GachaEvent: GameEvent {
    var startDate: Date
    
    var endDate: Date
    
    var name: String
    
    var type: GameEventType = .gacha
}

struct TowerEvent: GameEvent {
    var startDate: Date
    
    var endDate: Date
    
    var name: String
    
    var type: GameEventType = .tower
}

struct ClanBattleEvent: GameEvent {
    var startDate: Date
    
    var endDate: Date
    
    var name: String
    
    var type: GameEventType = .clanBattle
}
