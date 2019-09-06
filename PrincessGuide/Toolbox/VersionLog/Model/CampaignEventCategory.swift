//
//  CampaignEventCategory.swift
//  PrincessGuide
//
//  Created by zzk on 9/6/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation

enum CampaignEventCategory: Int {
    case none = 0
    case halfStaminaNormal = 11
    case halfStaminaHard
    case halfStaminaBoth
    case halfStaminaShrine
    case halfStaminaTemple
    case halfStaminaVeryHard
    
    case dropRareNormal = 21
    case dropRareHard
    case dropRareBoth
    case dropRareVeryHard
        
    case dropAmountNormal = 31
    case dropAmountHard
    case dropAmountBoth
    case dropAmountExploration
    case dropAmountDungeon
    case dropAmountCoop
    case dropAmountShrine
    case dropAmountTemple
    case dropAmountVeryHard
        
    case manaNormal = 41
    case manaHard
    case manaBoth
    case manaExploration
    case manaDungeon
    case manaCoop
    case manaTemple = 48
    case manaVeryHard
        
    case coinDungeon = 51
    
    case cooltimeArena = 61
    case cooltimeGrandArena
        
    case masterCoin = 90
    case masterCoinNormal
    case masterCoinHard
    case masterCoinVeryHard
    case masterCoinShrine
    case masterCoinTemple
    case masterCoinEventNormal
    case masterCoinEventHard
    case masterCoinRevivalEventNormal
    case masterCoinRevivalEventHard
    
    case halfStaminaEventNormal = 111
    case halfStaminaEventHard
    case halfStaminaEventBoth

    case dropRareEventNormal = 121
    case dropRareEventHard
    case dropRareEventBoth
        
    case dropAmountEventNormal = 131
    case dropAmountEventHard
    case dropAmountEventBoth
        
    case manaEventNormal = 141
    case manaEventHard
    case manaEventBoth
    
    case expEventNormal = 151
    case expEventHard
    case expEventBoth
        
    case halfStaminaRevivalEventNormal = 211
    case halfStaminaRevivalEventHard
    
    case dropRareRevivalEventNormal = 221
    case dropRareRevivalEventHard
    
    case dropAmountRevivalEventNormal = 231
    case dropAmountRevivalEventHard
    
    case manaRevivalEventNormal = 241
    case manaRevivalEventHard
    
    case expRevivalEventNormal = 251
    case expRevivalEventHard
}

extension CampaignEventCategory {
    enum BonusType: Int, CustomStringConvertible {
        case unknown = 0
        case drop = 3
        case mana = 4
        case exp = 5
        case masterCoin = 9
        var description: String {
            switch self {
            case .unknown:
                return NSLocalizedString("Unknown", comment: "")
            case .drop:
                return NSLocalizedString("Drop", comment: "")
            case .mana:
                return NSLocalizedString("Mana", comment: "")
            case .exp:
                return NSLocalizedString("Exp.", comment: "")
            case .masterCoin:
                return NSLocalizedString("Master Coin", comment: "")
            }
        }
    }
    
    var bonusType: BonusType {
        return BonusType(rawValue: rawValue / 10 % 10) ?? .unknown
    }
}

extension CampaignEventCategory {
    
    enum CategoryType: CustomStringConvertible {
        case unknown
        case normal
        case hard
        case both
        case veryHard
        case exploration
        case dungeon
        case temple
        case shrine

        case eventNormal
        case eventHard
        case revivalEventNormal
        case revivalEventHard
        
        var description: String {
            switch self {
            case .unknown:
                return NSLocalizedString("Unknown", comment: "")
            case .normal:
                return NSLocalizedString("Normal", comment: "")
            case .hard:
                return NSLocalizedString("Hard", comment: "")
            case .veryHard:
                return NSLocalizedString("Very Hard", comment: "")
            case .both:
                return NSLocalizedString("Normal and Hard", comment: "")
            case .exploration:
                return NSLocalizedString("Exploration", comment: "")
            case .dungeon:
                return NSLocalizedString("Dungeon", comment: "")
            case .shrine:
                return NSLocalizedString("Shrine", comment: "")
            case .temple:
                return NSLocalizedString("Temple", comment: "")
            case .eventNormal:
                return NSLocalizedString("Event Normal", comment: "")
            case .eventHard:
                return NSLocalizedString("Event Hard", comment: "")
            case .revivalEventHard:
                return NSLocalizedString("Revival Event Hard", comment: "")
            case .revivalEventNormal:
                return NSLocalizedString("Revival Event Normal", comment: "")
            }
        }
    }
    
    var categoryType: CategoryType {
        
        switch self {
        case .coinDungeon,
             .manaDungeon,
             .dropAmountDungeon
             :
            return .dungeon
        case .manaNormal,
             .dropRareNormal,
             .masterCoinNormal,
             .halfStaminaNormal,
             .dropAmountNormal
            :
            return .normal
        case .expEventNormal,
             .manaEventNormal,
             .dropRareEventNormal,
             .dropAmountEventNormal,
             .masterCoinEventNormal
            :
            return .eventNormal
        case .expRevivalEventNormal,
             .manaRevivalEventNormal,
             .dropRareRevivalEventNormal,
             .dropAmountRevivalEventNormal,
             .masterCoinRevivalEventNormal
            :
            return .revivalEventNormal
        case .manaHard,
             .dropRareHard,
             .masterCoinHard,
             .halfStaminaHard,
             .dropAmountHard
            :
            return .hard
        case .expEventHard,
             .manaEventHard,
             .dropRareEventHard,
             .dropAmountEventHard,
             .masterCoinEventHard
            :
            return .eventHard
        case .expRevivalEventHard,
             .manaRevivalEventHard,
             .dropRareRevivalEventHard,
             .dropAmountRevivalEventHard,
             .masterCoinRevivalEventHard
            :
            return .revivalEventHard
        case .dropAmountShrine,
             .masterCoinShrine,
             .halfStaminaShrine
            :
            return .shrine
        case .manaTemple,
             .dropAmountTemple,
             .masterCoinTemple,
             .halfStaminaTemple
            :
            return .temple
        case .manaExploration,
             .dropAmountExploration
            :
            return .exploration
        case .manaVeryHard,
             .dropRareVeryHard,
             .dropAmountVeryHard,
             .masterCoinVeryHard,
             .halfStaminaVeryHard
            :
            return .veryHard
        default:
            return .unknown
        }
    }
}
