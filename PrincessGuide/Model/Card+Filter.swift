//
//  Card+Filter.swift
//  PrincessGuide
//
//  Created by zzk on 9/4/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation

extension Card {
    
    enum PositionFilter: String, Codable, CustomStringConvertible, CaseIterable, FilterType {
        
        var description: String {
            switch self {
            case .all: return NSLocalizedString("All", comment: "")
            case .back: return NSLocalizedString("Back", comment: "")
            case .vanguard: return NSLocalizedString("Vanguard", comment: "")
            case .center: return NSLocalizedString("Center", comment: "")
            }
        }
        case all
        case vanguard
        case center
        case back
        
        func filter<S>(_ s: S) -> [Card] where S: Sequence, S.Element == Card {
            switch self {
            case .all: return Array(s)
            case .back: return s.filter { 600... ~= $0.base.searchAreaWidth }
            case .center: return s.filter { 300..<600 ~= $0.base.searchAreaWidth }
            case .vanguard: return s.filter { ...300 ~= $0.base.searchAreaWidth }
            }
        }
    }
    
    enum AttackTypeFilter: String, Codable, CustomStringConvertible, CaseIterable, FilterType {
        case all
        case physics
        case magic
        var description: String {
            switch self {
            case .all: return NSLocalizedString("All", comment: "")
            case .physics: return NSLocalizedString("Physics", comment: "")
            case .magic: return NSLocalizedString("Magic", comment: "")
            }
        }
        func filter<S>(_ s: S) -> [Card] where S: Sequence, S.Element == Card {
            switch self {
            case .all: return Array(s)
            case .physics: return s.filter { $0.base.atkType == 1 }
            case .magic: return s.filter { $0.base.atkType == 2 }
            }
        }
    }
    
    enum HasRarity6Filter: String, Codable, CustomStringConvertible, CaseIterable, FilterType {
        case all
        case yes
        case no
        var description: String {
            switch self {
            case .all: return NSLocalizedString("All", comment: "")
            case .yes: return NSLocalizedString("Yes", comment: "")
            case .no: return NSLocalizedString("No", comment: "")
            }
        }
        func filter<S>(_ s: S) -> [Card] where S: Sequence, S.Element == Card {
            switch self {
            case .all: return Array(s)
            case .yes: return s.filter { $0.hasRarity6 }
            case .no: return s.filter { !$0.hasRarity6 }
            }
        }
    }
    
    enum HasUniqueEquipmentFilter: String, Codable, CustomStringConvertible, CaseIterable, FilterType {
        case all
        case yes
        case no
        
        var description: String {
            switch self {
            case .all: return NSLocalizedString("All", comment: "")
            case .yes: return NSLocalizedString("Yes", comment: "")
            case .no: return NSLocalizedString("No", comment: "")
            }
        }
        func filter<S>(_ s: S) -> [Card] where S: Sequence, S.Element == Card {
            switch self {
            case .all: return Array(s)
            case .yes: return s.filter { $0.uniqueEquipIDs.count > 0 }
            case .no: return s.filter { $0.uniqueEquipIDs.count == 0 }
            }
        }
    }
    
    enum SourceFilter: String, Codable, CustomStringConvertible, CaseIterable, FilterType {
        case all
        case normal
        case limited
        
        var description: String {
            switch self {
            case .all: return NSLocalizedString("All", comment: "")
            case .normal: return NSLocalizedString("Normal Gacha", comment: "")
            case .limited: return NSLocalizedString("Limited Gacha", comment: "")
            }
        }
        func filter<S>(_ s: S) -> [Card] where S: Sequence, S.Element == Card {
            switch self {
            case .all: return Array(s)
            case .normal: return s.filter { $0.base.isLimited == 0 }
            case .limited: return s.filter { $0.base.isLimited == 1 }
            }
        }
    }
    
    enum TalentFilter: Int, Codable, CustomStringConvertible, CaseIterable, FilterType {
        case all = 0
        case fire = 1
        case water
        case wind
        case light
        case dark
        
        var description: String {
            switch self {
            case .all:
                return NSLocalizedString("All", comment: "")
            case .fire:
                return NSLocalizedString("Fire", comment: "")
            case .water:
                return NSLocalizedString("Water", comment: "")
            case .wind:
                return NSLocalizedString("Wind", comment: "")
            case .light:
                return NSLocalizedString("Light", comment: "")
            case .dark:
                return NSLocalizedString("Dark", comment: "")
            }
        }
        
        func filter<S>(_ s: S) -> [Card] where S: Sequence, S.Element == Card {
            switch self {
            case .all:
                return Array(s)
            default:
                return s.filter { $0.base.talentId == self.rawValue }
            }
        }
    }
}
