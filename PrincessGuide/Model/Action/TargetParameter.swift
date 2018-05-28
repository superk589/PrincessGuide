//
//  TargetParameter.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class TargetParameter {
    
    let targetAssignment: TargetAssignment
    let targetNth: TargetNth
    let targetType: TargetType
    let targetRange: TargetRange
    let targetCount: TargetCount
    let direction: DirectionType
    let rawTargetType: Int
    
    init(targetAssignment: Int, targetNth: Int, targetType: Int, targetRange: Int,
         direction: Int, targetCount: Int) {
        self.targetAssignment = TargetAssignment(rawValue: targetAssignment) ?? .none
        self.targetNth = TargetNth(rawValue: targetNth) ?? .other
        self.rawTargetType = targetType
        self.targetType = TargetType(rawValue: targetType) ?? .unknown
        self.targetRange = TargetRange(range: targetRange)
        self.direction = DirectionType(rawValue: direction) ?? .all
        self.targetCount = TargetCount(rawValue: targetCount) ?? .all
    }
    
    var hasRelationPhrase: Bool {
        return targetType != .`self`
    }
    
    var hasCountPhrase: Bool {
        return targetType != .`self` &&
            !(targetType == .none && targetCount == .zero)
    }
    
    var hasRangePhrase: Bool {
        if case .finite = targetRange {
            return true
        } else {
            return false
        }
    }
    
    var hasNthModifier: Bool {
        return [TargetNth.second, .third, .fourth, .fifth].contains(targetNth)
    }
    
    var hasDirectionPhrase: Bool {
        return direction == .front &&
            targetAssignment == .friendly &&
            (hasRangePhrase || targetCount == .all)
    }
    
    func buildTargetClause() -> String {
        switch (hasCountPhrase, hasNthModifier, hasRangePhrase, hasRelationPhrase, hasDirectionPhrase) {
        case (false, false, false, false, _):
            return TargetType.`self`.description
        case (false, false, false, true, _):
            return NSLocalizedString("targets of last effect", comment: "")
        case (true, false, false, true, false):
            if targetCount == .all && targetType.isExclusiveWithAll {
                let format = NSLocalizedString("all %@ %@", comment: "all enemy targets")
                return String(format: format, targetAssignment.description, targetCount.pluralModifier.description)
            } else if targetCount == .one && targetType.ignoresOne {
                let format = NSLocalizedString("%@ %@ target", comment: "the nearest enemy target")
                return String(format: format, targetType.description, targetAssignment.description)
            } else {
                let format = NSLocalizedString("%@ %@ %@ %@", comment: "the fathest two enemy targets")
                return String(format: format, targetType.description, targetCount.description, targetAssignment.description, targetCount.pluralModifier.description)
            }
        case (true, false, false, true, true):
            let format = NSLocalizedString("all %@ %@ %@", comment: "all front friendly targets")
            return String(format: format, direction.description, targetAssignment.description, targetCount.pluralModifier.description)
        case (false, false, true, true, false):
            let format = NSLocalizedString("%@ targets in range %d", comment: "enemy targets in range 500")
            return String(format: format, targetAssignment.description, targetRange.rawRange)
        case (false, false, true, true, true):
            let format = NSLocalizedString("%@ %@ targets in range %d", comment: "front friendly targets in range 500")
            return String(format: format, direction.description, targetAssignment.description, targetRange.rawRange)
        case (false, true, true, true, _):
            return NSLocalizedString("targets of last effect", comment: "")
        case (true, false, true, true, false):
            if targetCount == .all && targetType.isExclusiveWithAll {
                let format = NSLocalizedString("%@ %@ in range %d", comment: "friendly targets in range 500")
                return String(format: format, targetAssignment.description, targetCount.pluralModifier.description, targetRange.rawRange)
            } else if targetCount == .one && targetType.ignoresOne {
                let format = NSLocalizedString("%@ %@ target in range %d", comment: "the nearest enemy target in range 500")
                return String(format: format, targetType.description, targetAssignment.description, targetRange.rawRange)
            } else {
                let format = NSLocalizedString("%@ %@ %@ %@ in range %d", comment: "the fathest two enemy targets in range 500")
                return String(format: format, targetType.description, targetCount.description, targetAssignment.description, targetCount.pluralModifier.description, targetRange.rawRange)
            }
        case (true, false, true, true, true):
            if targetCount == .all && targetType.isExclusiveWithAll {
                let format = NSLocalizedString("%@ %@ %@ in range %d", comment: "front friendly targets in range 500")
                return String(format: format, direction.description, targetAssignment.description, targetCount.pluralModifier.description, targetRange.rawRange)
            } else if targetCount == .one && targetType.ignoresOne {
                let format = NSLocalizedString("%@ %@ %@ target in range %d", comment: "the nearest front friendly target in range 500")
                return String(format: format, targetType.description, direction.description, targetAssignment.description, targetRange.rawRange)
            } else {
                let format = NSLocalizedString("%@ %@ %@ %@ %@ in range %d", comment: "the fathest two front friendly targets in range 500")
                return String(format: format, targetType.description, targetCount.description, direction.description,  targetAssignment.description, targetCount.pluralModifier.description, targetRange.rawRange)
            }
        case (true, true, false, true, false):
            if targetCount == .one && targetType.ignoresOne {
                let format = NSLocalizedString("%@ %@ target", comment: "the second nearest enemy target")
                return String(format: format, targetType.description(with: targetNth), targetAssignment.description)
            } else {
                let format = NSLocalizedString("%@ %@ %@ %@", comment: "the second to fourth fathest enemy targets")
                let targetMth = targetNth.add(targetCount) ?? .fifth
                let modifierFormat = NSLocalizedString("%@ to %@", comment: "")
                let modifier = String(format: modifierFormat, targetNth.description, targetMth.description)
                return String(format: format, targetType.description(with: targetNth, localizedNth: modifier), targetAssignment.description, targetCount.pluralModifier.description)
            }
        case (true, true, false, true, true):
            let format = NSLocalizedString("%@ %@ %@ %@ %@", comment: "the second to fourth fathest front friendly targets")
            let targetMth = targetNth.add(targetCount) ?? .fifth
            let modifierFormat = NSLocalizedString("%@ to %@", comment: "")
            let modifier = String(format: modifierFormat, targetNth.description, targetMth.description)
            return String(format: format, targetType.description(with: targetNth, localizedNth: modifier), direction.description, targetAssignment.description, targetCount.pluralModifier.description)
        case (true, true, true, true, false):
            if targetCount == .one && targetType.ignoresOne {
                let format = NSLocalizedString("%@ %@ target in range %d", comment: "the second nearest enemy target in range 500")
                return String(format: format, targetType.description(with: targetNth), targetAssignment.description, targetRange.rawRange)
            } else {
                let format = NSLocalizedString("%@ %@ %@ %@ in range %d", comment: "the second to fourth fathest enemy targets in range 500")
                let targetMth = targetNth.add(targetCount) ?? .fifth
                let modifierFormat = NSLocalizedString("%@ to %@", comment: "")
                let modifier = String(format: modifierFormat, targetNth.description, targetMth.description)
                return String(format: format, targetType.description(with: targetNth, localizedNth: modifier), targetAssignment.description, targetCount.pluralModifier.description, targetRange.rawRange)
            }
        case (true, true, true, true, true):
            if targetCount == .one && targetType.ignoresOne {
                let format = NSLocalizedString("%@ %@ %@ target in range %d", comment: "the second nearest front friendly target in range 500")
                return String(format: format, targetType.description(with: targetNth), direction.description, targetAssignment.description, targetRange.rawRange)
            } else {
                let format = NSLocalizedString("%@ %@ %@ %@ %@ in range %d", comment: "the second to fourth fathest front friendly targets in range 500")
                let targetMth = targetNth.add(targetCount) ?? .fifth
                let modifierFormat = NSLocalizedString("%@ to %@", comment: "")
                let modifier = String(format: modifierFormat, targetNth.description, targetMth.description)
                return String(format: format, targetType.description(with: targetNth, localizedNth: modifier), direction.description, targetAssignment.description, targetCount.pluralModifier.description, targetRange.rawRange)
            }
        default:
            return ""
        }
    }
    
}

enum TargetAssignment: Int, CustomStringConvertible {
    case none = 0
    case enemy = 1
    case friendly
    case all
    
    var description: String {
        switch self {
        case .enemy:
            return NSLocalizedString("enemy", comment: "target modifier")
        case .friendly:
            return NSLocalizedString("friendly", comment: "target modifier")
        case .all:
            return NSLocalizedString("all", comment: "target modifier")
        default:
            return ""
        }
    }
    
}

enum TargetType: Int, CustomStringConvertible {
    case unknown = -1
    case zero = 0
    case none = 1
    case random
    case near
    case far
    case hpAscending
    case hpDescending
    case `self`
    case randomOnce
    case forward
    case backward = 10
    case absolute
    case tpDescending
    case tpAscending
    case atkDescending
    case atkAscending
    case magicSTRDescending
    case magicSTRAscending
    case summon
    case tpReducing
    case physics = 20
    case magic
    case allSummonRandom
    case selfSummonRandom
    
    var isExclusiveWithAll: Bool {
        switch self {
        case .unknown, .magic, .physics, .summon:
            return false
        default:
            return true
        }
    }
    
    var ignoresOne: Bool {
        switch self {
        case .unknown, .random, .randomOnce, .absolute, .summon, .selfSummonRandom, .allSummonRandom, .magic, .physics:
            return false
        default:
            return true
        }
    }
    
    var description: String {
        switch self {
        case .unknown:
            return NSLocalizedString("unknown", comment: "target type")
        case .none:
            return NSLocalizedString("last effect affected or the nearest", comment: "")
        case .random:
            return NSLocalizedString("random", comment: "target type")
        case .zero, .near:
            return NSLocalizedString("the nearest", comment: "target type")
        case .far:
            return NSLocalizedString("the farthest", comment: "target type")
        case .hpAscending:
            return NSLocalizedString("the lowest HP ratio", comment: "target type")
        case .hpDescending:
            return NSLocalizedString("the highest HP ratio", comment: "target type")
        case .`self`:
            return NSLocalizedString("self", comment: "target type")
        case .randomOnce:
            return NSLocalizedString("random(once)", comment: "target type")
        case .forward:
            return NSLocalizedString("the most backward", comment: "target type")
        case .backward:
            return NSLocalizedString("the most forward", comment: "target type")
        case .absolute:
            return NSLocalizedString("absolute", comment: "")
        case .tpDescending:
            return NSLocalizedString("the highest TP", comment: "target type")
        case .tpAscending, .tpReducing:
            return NSLocalizedString("the lowest TP", comment: "target type")
        case .atkDescending:
            return NSLocalizedString("the highest ATK", comment: "")
        case .atkAscending:
            return NSLocalizedString("the lowest ATK", comment: "")
        case .magicSTRDescending:
            return NSLocalizedString("the highest Magic STR", comment: "")
        case .magicSTRAscending:
            return NSLocalizedString("the lowest Magic STR", comment: "")
        case .summon:
            return NSLocalizedString("minion", comment: "")
        case .physics:
            return NSLocalizedString("physics", comment: "")
        case .magic:
            return NSLocalizedString("magic", comment: "")
        case .allSummonRandom:
            return NSLocalizedString("random minion", comment: "")
        case .selfSummonRandom:
            return NSLocalizedString("random self minion", comment: "")
        }
    }
    
    func description(with targetNth: TargetNth, localizedNth: String? = nil) -> String {
        if [TargetNth.second, .third, .fourth, .fifth].contains(targetNth) {
            let localizedModifier = localizedNth ?? targetNth.description
            switch self {
            case .unknown:
                let format = NSLocalizedString("the %@ unknown type", comment: "target type")
                return String(format: format, localizedModifier)
            case .none:
                let format = NSLocalizedString("targets of last effect or the %@ nearest", comment: "target type")
                return String(format: format, localizedModifier)
            case .zero, .near:
                let format = NSLocalizedString("the %@ nearest", comment: "target type")
                return String(format: format, localizedModifier)
            case .far:
                let format = NSLocalizedString("the %@ farthest", comment: "target type")
                return String(format: format, localizedModifier)
            case .hpAscending:
                let format = NSLocalizedString("the %@ lowest HP ratio", comment: "target type")
                return String(format: format, localizedModifier)
            case .hpDescending:
                let format = NSLocalizedString("the %@ highest HP ratio", comment: "target type")
                return String(format: format, localizedModifier)
            case .forward:
                let format = NSLocalizedString("the %@ most backward", comment: "target type")
                return String(format: format, localizedModifier)
            case .backward:
                let format = NSLocalizedString("the %@ most forward", comment: "target type")
                return String(format: format, localizedModifier)
            case .tpDescending:
                let format = NSLocalizedString("the %@ highest TP", comment: "target type")
                return String(format: format, localizedModifier)
            case .tpAscending, .tpReducing:
                let format = NSLocalizedString("the %@ lowest TP", comment: "target type")
                return String(format: format, localizedModifier)
            case .atkDescending:
                let format = NSLocalizedString("the %@ highest ATK", comment: "")
                return String(format: format, localizedModifier)
            case .atkAscending:
                let format = NSLocalizedString("the %@ lowest ATK", comment: "")
                return String(format: format, localizedModifier)
            case .magicSTRDescending:
                let format = NSLocalizedString("the %@ highest Magic STR", comment: "")
                return String(format: format, localizedModifier)
            case .magicSTRAscending:
                let format = NSLocalizedString("the %@ lowest Magic STR", comment: "")
                return String(format: format, localizedModifier)
            default:
                return description
            }
        } else {
            return description
        }
    }
}

enum TargetCount: Int, CustomStringConvertible {
    
    var description: String {
        switch self {
        case .zero:
            return ""
        case .one:
            return NSLocalizedString("one", comment: "")
        case .two:
            return NSLocalizedString("two", comment: "")
        case .three:
            return NSLocalizedString("three", comment: "")
        case .four:
            return NSLocalizedString("four", comment: "")
        default:
            return NSLocalizedString("all", comment: "")
        }
    }
    
    enum PluralModifier: CustomStringConvertible {
        case one
        case many
        
        var description: String {
            switch self {
            case .one:
                return NSLocalizedString("target", comment: "")
            default:
                return NSLocalizedString("targets", comment: "")
            }
        }
    }
    
    var pluralModifier: PluralModifier {
        switch self {
        case .one:
            return .one
        default:
            return .many
        }
    }
    
    case zero = 0
    case one = 1
    case two
    case three
    case four
    case all = 99
}

enum TargetNth: Int, CustomStringConvertible {
    case first = 0
    case second
    case third
    case fourth
    case fifth
    case other
    
    var description: String {
        switch self {
        case .second:
            return NSLocalizedString("second", comment: "")
        case .third:
            return NSLocalizedString("third", comment: "")
        case .fourth:
            return NSLocalizedString("fourth", comment: "")
        case .fifth:
            return NSLocalizedString("fifth", comment: "")
        default:
            return ""
        }
    }
    
    func add(_ targetCount: TargetCount) -> TargetNth? {
        return TargetNth(rawValue: rawValue + targetCount.rawValue - 1)
    }
}

enum TargetRange {
    
    case zero
    case all
    case finite(Int)
    case infinite
    
    case unknown(Int)
    
    init(range: Int) {
        switch range {
        case -1:
            self = .infinite
        case 0:
            self = .zero
        case 1..<2160:
            self = .finite(range)
        case 2160...:
            self = .all
        default:
            self = .unknown(range)
        }
    }
    
    var rawRange: Int {
        switch self {
        case .infinite:
            return -1
        case .finite(let range):
            return range
        case .all:
           return 2160
        case .unknown(let range):
            return range
        case .zero:
            return 0
        }
    }
    
}


enum DirectionType: Int, CustomStringConvertible {
    case front = 1
    case frontAndBack
    case all
    
    var description: String {
        switch self {
        case .front:
            return NSLocalizedString("front(including self)", comment: "")
        case .frontAndBack:
            return NSLocalizedString("front and back", comment: "")
        default:
            return ""
        }
    }
    
    var rawDescription: String {
        switch self {
        case .front:
            return NSLocalizedString("front", comment: "")
        case .frontAndBack:
            return NSLocalizedString("front and back", comment: "")
        default:
            return ""
        }
    }
}
