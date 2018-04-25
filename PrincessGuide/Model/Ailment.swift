//
//  Ailment.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/24.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

enum Ailment: Int, CustomStringConvertible {
    case slow = 1
    case haste
    case paralyse
    case freeze
    case bind
    case sleep
    case stun
    case petrify
    case detain
    case detained
    case poisoned
    case burned
    case cursed
    case charm
    case dark
    case silent
    case instantDeath
    case unknown
    
    var description: String {
        switch self {
        case .dark:
            return NSLocalizedString("Dark", comment: "")
        case .slow:
            return NSLocalizedString("Slow", comment: "")
        case .haste:
            return NSLocalizedString("Haste", comment: "")
        case .paralyse:
            return NSLocalizedString("Paralyse", comment: "")
        case .freeze:
            return NSLocalizedString("Freeze", comment: "")
        case .bind:
            return NSLocalizedString("Bind", comment: "")
        case .sleep:
            return NSLocalizedString("Sleep", comment: "")
        case .stun:
            return NSLocalizedString("Stun", comment: "")
        case .petrify:
            return NSLocalizedString("Petrify", comment: "")
        case .detain:
            return NSLocalizedString("Detain", comment: "")
        case .detained:
            return NSLocalizedString("Detain", comment: "")
        case .poisoned:
            return NSLocalizedString("Poison", comment: "")
        case .burned:
            return NSLocalizedString("Burn", comment: "")
        case .cursed:
            return NSLocalizedString("Curse", comment: "")
        case .charm:
            return NSLocalizedString("Charm", comment: "")
        case .silent:
            return NSLocalizedString("Slient", comment: "")
        case .instantDeath:
            return NSLocalizedString("Instant Death", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown", comment: "")
        }
    }
    
}

enum AilmentType: Int, CustomStringConvertible {
    
    case action = 8
    case dot
    case charm = 11
    case dark
    case silent
    case instantDeath = 30
    case unknown
    
    var description: String {
        switch self {
            
        case .action:
            return NSLocalizedString("Action Affected", comment: "")
        case .dot:
            return NSLocalizedString("Dot", comment: "")
        case .charm:
            return NSLocalizedString("Charm", comment: "")
        case .dark:
            return NSLocalizedString("Dark", comment: "")
        case .silent:
            return NSLocalizedString("Silent", comment: "")
        case .instantDeath:
            return NSLocalizedString("Instant Death", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown", comment: "")
        }
    }
}

extension Ailment {
    init?(_ type: AilmentType, _ value: Int) {
        switch (type, value) {
        case (.action, _):
            self.init(rawValue: value)
        case (.dot, _):
            self.init(rawValue: value + 10)
        case (.charm, _):
            self = .charm
        case (.dark, _):
            self = .dark
        case (.silent, _):
            self = .silent
        case (.instantDeath, _):
            self = .instantDeath
        default:
            self = .unknown
        }
    }
}
