//
//  Ailment.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/24.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

enum AilmentDetail: CustomStringConvertible {
    case dot(DotDetail)
    case action(ActionDetail)
    
    var description: String {
        switch self {
        case .dot(let detail):
            return detail.description
        case .action(let detail):
            return detail.description
        }
    }
}

enum DotDetail: Int, CustomStringConvertible {
    case detain = 0
    case poison
    case burn
    case curse
    case unknown
    
    var description: String {
        switch self {
        case .detain:
            return NSLocalizedString("Detain", comment: "")
        case .poison:
            return NSLocalizedString("Poison", comment: "")
        case .burn:
            return NSLocalizedString("Burn", comment: "")
        case .curse:
            return NSLocalizedString("Curse", comment: "")
        default:
            return NSLocalizedString("Unknown", comment: "")
        }
    }
}

enum ActionDetail: Int, CustomStringConvertible {
    case slow = 1
    case haste
    case paralyse
    case freeze
    case bind
    case sleep
    case stun
    case petrify
    case detain
    case unknown
    
    var description: String {
        switch self {
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
        case .unknown:
            return NSLocalizedString("Unknown", comment: "")
        }
    }
    
}

enum AilmentType: Int, CustomStringConvertible {
    
    case action = 8
    case dot
    case charm = 11
    case darken
    case silence
    case instantDeath = 30
    case unknown
    
    var description: String {
        switch self {
            
        case .action:
            return NSLocalizedString("Action", comment: "")
        case .dot:
            return NSLocalizedString("Dot", comment: "")
        case .charm:
            return NSLocalizedString("Charm", comment: "")
        case .darken:
            return NSLocalizedString("Darken", comment: "")
        case .silence:
            return NSLocalizedString("Silence", comment: "")
        case .instantDeath:
            return NSLocalizedString("Instant Death", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown Effect", comment: "")
        }
    }
}

struct Ailment: CustomStringConvertible {
    let type: Int
    let detail: Int
    
    var ailmentType: AilmentType {
        return AilmentType(rawValue: type) ?? .unknown
    }
    
    var ailmentDetail: AilmentDetail? {
        switch ailmentType {
        case .action:
            return .action(ActionDetail(rawValue: detail) ?? .unknown)
        case .dot:
            return .dot(DotDetail(rawValue: detail) ?? .unknown)
        default:
            return nil
        }
    }
    
    var description: String {
        return ailmentDetail?.description ?? ailmentType.description
    }
}
