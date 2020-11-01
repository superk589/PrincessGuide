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
    weak var dependAction: Skill.Action?
    
    init(targetAssignment: Int, targetNth: Int, targetType: Int, targetRange: Int,
         direction: Int, targetCount: Int, parent: Skill.Action?) {
        self.targetAssignment = TargetAssignment(rawValue: targetAssignment) ?? .none
        self.targetNth = TargetNth(rawValue: targetNth) ?? .other
        self.rawTargetType = targetType
        self.targetType = TargetType(rawValue: targetType) ?? .unknown
        self.targetRange = TargetRange(range: targetRange)
        self.direction = DirectionType(rawValue: direction) ?? .all
        self.targetCount = TargetCount(rawValue: targetCount) ?? .all
        self.dependAction = parent
    }
    
    var hasRelationPhrase: Bool {
        return targetType != .`self` &&
            targetType != .absolute
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
            (hasRangePhrase || targetCount == .all)
    }
    
    var hasDependAction: Bool {
        if let dependAction = dependAction {
            return dependAction.base.actionId != 0 && targetType != .absolute
                && [ActionType.ifForChildren, .ifForAll, .damage, .knock, .gravity].contains(dependAction.parameter.actionType)
        } else {
            return false
        }
    }
    
    var hasTargetType: Bool {
        switch targetType.exclusiveWithAll {
        case .exclusive where targetCount == .all:
            return false
        default:
            return true
        }
    }
    
    func tags(anyOfModifier: Bool = false) -> [ActionTag] {
        var tags = [ActionTag]()
        
        if hasDependAction {
            if let actionType = dependAction?.parameter.actionType, [ActionType.damage, .gravity].contains(actionType) {
                let format = NSLocalizedString("damaged by effect %d", comment: "")
                tags.append(.custom(String(format: format, dependAction!.base.actionId % 100)))
            } else {
                let format = NSLocalizedString("targets of effect %d", comment: "")
                tags.append(.custom(String(format: format, dependAction!.base.actionId % 100)))
            }
            return tags
        }
        
        if targetCount.pluralModifier == .many && anyOfModifier {
            tags.append(.custom(NSLocalizedString("any of", comment: "")))
        }
        
        if hasCountPhrase {
            switch targetCount {
            case .all, .four, .three, .two:
                tags.append(.count(targetCount))
            case .one:
                if !targetType.ignoresOne {
                    tags.append(.count(targetCount))
                }
            case .zero:
                break
            }
        }
        
        if hasDirectionPhrase {
            switch direction {
            case .front:
                if targetAssignment == .friendly {
                    tags.append(.direction(direction))
                } else {
                    tags.append(.custom(NSLocalizedString("front", comment: "")))
                }
            default:
                break
            }
        }
        
        switch targetRange {
        case .finite(let x):
            tags.append(.range(x))
        default:
            break
        }
        
        if hasTargetType {
            tags.append(.targetType(targetType))
        }
        
        switch targetNth {
        case .fifth, .fourth, .second, .third:
            tags.append(.nth(targetNth))
        default:
            break
        }
        
        if hasRelationPhrase {
            tags.append(.relation(targetAssignment))
        } else {
            tags.removeAll()
            tags.append(.targetType(targetType))
        }
        
        return tags
    }
    
    func buildTargetClause(anyOfModifier: Bool = false) -> String {
        switch CDSettingsViewController.Setting.default.enableTagBasedDescription {
        case true:
            return tags(anyOfModifier: anyOfModifier).map { $0.attachmentString }.joined()
        case false:
            var result: String
            switch (hasCountPhrase, hasNthModifier, hasRangePhrase, hasRelationPhrase, hasDirectionPhrase, hasDependAction) {
            case (_, _, _, _, _, true):
                if let actionType = dependAction?.parameter.actionType, [ActionType.damage, .gravity].contains(actionType) {
                    let format = NSLocalizedString("targets those damaged by effect %d", comment: "")
                    result = String(format: format, dependAction!.base.actionId % 100)
                } else {
                    let format = NSLocalizedString("targets of effect %d", comment: "")
                    result = String(format: format, dependAction!.base.actionId % 100)
                }
            case (_, _, _, false, _, _):
                result = targetType.description.description
            case (false, false, false, true, _, _):
                result = NSLocalizedString("targets of last effect", comment: "")
            case (true, false, false, true, false, _):
                if targetCount == .all {
                    switch targetType.exclusiveWithAll {
                    case .exclusive:
                        let format = NSLocalizedString("all %@ targets", comment: "all [enemy] targets")
                        result = String(format: format, targetAssignment.description)
                    case .not:
                        let format = NSLocalizedString("all %@ %@ targets", comment: "all [enemy] [physics] targets")
                        result = String(format: format, targetAssignment.description, targetType.description)
                    case .halfExclusive(let string):
                        let format = NSLocalizedString("all %@ targets", comment: "all [enemy] targets")
                        result = String(format: format, targetAssignment.description + string)
                    }
                } else if targetCount == .one && targetType.ignoresOne {
                    let format = NSLocalizedString("%@ %@ target", comment: "[the nearest] [enemy] target")
                    result = String(format: format, targetType.description, targetAssignment.description)
                } else {
                    let format = NSLocalizedString("%@ %@ %@", comment: "[the farthest two] [enemy] [targets]")
                    result = String(format: format, targetType.description(with: targetCount), targetAssignment.description, targetCount.pluralModifier.description)
                }
            case (true, false, false, true, true, _):
                switch targetType.exclusiveWithAll {
                case .exclusive:
                    switch targetAssignment {
                    case .enemy:
                        let format = NSLocalizedString("all front enemy targets", comment: "")
                        result = String(format: format)
                    case .friendly:
                        let format = NSLocalizedString("all front(including self) friendly targets", comment: "")
                        result = String(format: format)
                    default:
                        let format = NSLocalizedString("all front targets", comment: "")
                        result = String(format: format)
                    }
                case .not:
                    switch targetAssignment {
                    case .enemy:
                        let format = NSLocalizedString("all front %@ enemy targets", comment: "")
                        result = String(format: format, targetType.description)
                    case .friendly:
                        let format = NSLocalizedString("all front(including self) %@ friendly targets", comment: "")
                        result = String(format: format, targetType.description)
                    default:
                        let format = NSLocalizedString("all front %@ targets", comment: "")
                        result = String(format: format, targetType.description)
                    }
                case .halfExclusive(let string):
                    switch targetAssignment {
                    case .enemy:
                        let format = NSLocalizedString("all front enemy targets", comment: "")
                        result = String(format: format + string)
                    case .friendly:
                        let format = NSLocalizedString("all front(including self) friendly targets", comment: "")
                        result = String(format: format)
                    default:
                        let format = NSLocalizedString("all front targets", comment: "")
                        result = String(format: format + string)
                    }
                }
            case (false, false, true, true, false, _):
                let format = NSLocalizedString("%@ targets in range %d", comment: "[enemy] targets in range [500]")
                result = String(format: format, targetAssignment.description, targetRange.rawRange)
            case (false, false, true, true, true, _):
                let format = NSLocalizedString("front %@ targets in range %d", comment: "front [enemy] targets in range [500]")
                result = String(format: format, targetAssignment.description, targetRange.rawRange)
            case (false, true, true, true, _, _):
                result = NSLocalizedString("targets of last effect", comment: "")
            case (true, false, true, true, false, _):
                if targetCount == .all {
                    switch targetType.exclusiveWithAll {
                    case .exclusive:
                        let format = NSLocalizedString("%@ targets in range %d", comment: "[enemy] targets in range [500]")
                        result = String(format: format, targetAssignment.description, targetRange.rawRange)
                    case .not:
                        let format = NSLocalizedString("%@ %@ targets in range %d", comment: "[friendly] [physics] targets in range [500]")
                        result = String(format: format, targetAssignment.description, targetType.description, targetRange.rawRange)
                    case .halfExclusive(let string):
                        let format = NSLocalizedString("%@ targets in range %d", comment: "[enemy] targets in range [500]")
                        result = String(format: format, targetAssignment.description + string, targetRange.rawRange)
                    }
                } else if targetCount == .one && targetType.ignoresOne {
                    let format = NSLocalizedString("%@ %@ target in range %d", comment: "[the nearest] [enemy] target in range [500]")
                    result = String(format: format, targetType.description, targetAssignment.description, targetRange.rawRange)
                } else {
                    let format = NSLocalizedString("%@ %@ %@ in range %d", comment: "[the farthest two] [enemy] [targets] in range [500]")
                    result = String(format: format, targetType.description(with: targetCount), targetAssignment.description, targetCount.pluralModifier.description, targetRange.rawRange)
                }
            case (true, false, true, true, true, _):
                if targetCount == .all {
                    switch targetType.exclusiveWithAll {
                    case .exclusive:
                        let format = NSLocalizedString("front %@ targets in range %d", comment: "front [enemy] targets in range [500]")
                        result = String(format: format, targetAssignment.description, targetRange.rawRange)
                    case .not:
                        let format = NSLocalizedString("front %@ %@ targets in range %d", comment: "front [friendly] [physics] targets in range [500]")
                        result = String(format: format, targetAssignment.description, targetType.description, targetRange.rawRange)
                    case .halfExclusive(let string):
                        let format = NSLocalizedString("front %@ targets in range %d", comment: "front [enemy] targets in range [500]")
                        result = String(format: format, targetAssignment.description + string, targetRange.rawRange)
                    }
                } else if targetCount == .one && targetType.ignoresOne {
                    let format = NSLocalizedString("%@ front %@ target in range %d", comment: "[the nearest] front [enemy] target in range [500]")
                    result = String(format: format, targetType.description, targetAssignment.description, targetRange.rawRange)
                } else {
                    let format = NSLocalizedString("%@ front %@ %@ in range %d", comment: "[the farthest two] front [enemy] [targets] in range [500]")
                    result = String(format: format, targetType.description(with: targetCount), targetAssignment.description, targetCount.pluralModifier.description, targetRange.rawRange)
                }
            case (true, true, false, true, false, _):
                if targetCount == .one && targetType.ignoresOne {
                    let format = NSLocalizedString("%@ %@ target", comment: "[the second nearest] [enemy] target")
                    result = String(format: format, targetType.description(with: targetNth), targetAssignment.description)
                } else {
                    let format = NSLocalizedString("%@ %@ %@", comment: "[the second to fourth farthest] [enemy] [targets]")
                    let targetMth = targetNth.add(targetCount) ?? .fifth
                    let modifierFormat = NSLocalizedString("%@ to %@", comment: "")
                    let modifier = String(format: modifierFormat, targetNth.description, targetMth.description)
                    result = String(format: format, targetType.description(with: targetNth, localizedNth: modifier), targetAssignment.description, targetCount.pluralModifier.description)
                }
            case (true, true, false, true, true, _):
                let format = NSLocalizedString("%@ front %@ %@", comment: "[the second to fourth farthest] front [enemy] [targets]")
                let targetMth = targetNth.add(targetCount) ?? .fifth
                let modifierFormat = NSLocalizedString("%@ to %@", comment: "")
                let modifier = String(format: modifierFormat, targetNth.description, targetMth.description)
                result = String(format: format, targetType.description(with: targetNth, localizedNth: modifier), targetAssignment.description,  targetCount.pluralModifier.description)
            case (true, true, true, true, false, _):
                if targetCount == .one && targetType.ignoresOne {
                    let format = NSLocalizedString("%@ %@ target in range %d", comment: "[the second nearest] [enemy] target in range [500]")
                    result = String(format: format, targetType.description(with: targetNth), targetAssignment.description, targetRange.rawRange)
                } else {
                    let format = NSLocalizedString("%@ %@ %@ in range %d", comment: "[the second to fourth farthest] [enemy] [targets] in range [500]")
                    let targetMth = targetNth.add(targetCount) ?? .fifth
                    let modifierFormat = NSLocalizedString("%@ to %@", comment: "")
                    let modifier = String(format: modifierFormat, targetNth.description, targetMth.description)
                    result = String(format: format, targetType.description(with: targetNth, localizedNth: modifier), targetAssignment.description, targetCount.pluralModifier.description, targetRange.rawRange)
                }
            case (true, true, true, true, true, _):
                if targetCount == .one && targetType.ignoresOne {
                    let format = NSLocalizedString("%@ front %@ target in range %d", comment: "[the second nearest] front [enemy] target in range [500]")
                    result = String(format: format, targetType.description(with: targetNth), targetAssignment.description, targetRange.rawRange)
                } else {
                    let format = NSLocalizedString("%@ front %@ %@ in range %d", comment: "[the second to fourth farthest] front [enemy] [targets] in range [500]")
                    let targetMth = targetNth.add(targetCount) ?? .fifth
                    let modifierFormat = NSLocalizedString("%@ to %@", comment: "")
                    let modifier = String(format: modifierFormat, targetNth.description, targetMth.description)
                    result = String(format: format, targetType.description(with: targetNth, localizedNth: modifier), targetAssignment.description,  targetCount.pluralModifier.description, targetRange.rawRange)
                }
            default:
                result = ""
                print("some cases are not covered in building target description")
            }
            if targetCount.pluralModifier == .many && anyOfModifier {
                let format = NSLocalizedString("any of %@", comment: "")
                result = String(format: format, result)
            }
            return result
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
            return NSLocalizedString("both sides", comment: "target modifier")
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
    case boss
    case hpAscendingOrNear
    case hpDescendingOrNear
    case tpDescendingOrNear
    case tpAscendingOrNear
    case atkDescendingOrNear
    case atkAscendingOrNear = 30
    case magicSTRDescendingOrNear
    case magicSTRAscendingOrNear
    case shadow
    case nearExceptSelf
    case hpDescendingOrNearForward
    case hpAscendingOrNearForward
    case tpDescendingOrMaxForward
    
    enum ExclusiveAllType {
        case not
        case exclusive
        case halfExclusive(String)
    }
    
    var exclusiveWithAll: ExclusiveAllType {
        switch self {
        case .unknown, .magic, .physics, .summon, .boss:
            return .not
        case .nearExceptSelf:
            return .halfExclusive(NSLocalizedString("(except self)", comment: ""))
        default:
            return .exclusive
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
            return NSLocalizedString("the nearest", comment: "")
        case .random, .randomOnce:
            return NSLocalizedString("random", comment: "target type")
        case .zero, .near:
            return NSLocalizedString("the nearest", comment: "target type")
        case .far:
            return NSLocalizedString("the farthest", comment: "target type")
        case .hpAscending, .hpAscendingOrNear:
            return NSLocalizedString("the lowest HP ratio", comment: "target type")
        case .hpDescending, .hpDescendingOrNear:
            return NSLocalizedString("the highest HP ratio", comment: "target type")
        case .hpAscendingOrNearForward:
            return NSLocalizedString("the lowest HP", comment: "target type")
        case .hpDescendingOrNearForward:
            return NSLocalizedString("the highest HP", comment: "target type")
        case .`self`:
            return NSLocalizedString("self", comment: "target type")
//        case .randomOnce:
//            return NSLocalizedString("random(once)", comment: "target type")
        case .forward:
            return NSLocalizedString("the most forward", comment: "target type")
        case .backward:
            return NSLocalizedString("the most backward", comment: "target type")
        case .absolute:
            return NSLocalizedString("targets within the scope", comment: "")
        case .tpDescending, .tpDescendingOrNear, .tpDescendingOrMaxForward:
            return NSLocalizedString("the highest TP", comment: "target type")
        case .tpAscending, .tpReducing, .tpAscendingOrNear:
            return NSLocalizedString("the lowest TP", comment: "target type")
        case .atkDescending, .atkDescendingOrNear:
            return NSLocalizedString("the highest ATK", comment: "")
        case .atkAscending, .atkAscendingOrNear:
            return NSLocalizedString("the lowest ATK", comment: "")
        case .magicSTRDescending, .magicSTRDescendingOrNear:
            return NSLocalizedString("the highest Magic STR", comment: "")
        case .magicSTRAscending, .magicSTRAscendingOrNear:
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
        case .boss:
            return NSLocalizedString("boss", comment: "")
        case .shadow:
            return NSLocalizedString("shadow", comment: "")
        case .nearExceptSelf:
            return NSLocalizedString("the nearest except self", comment: "")
        }
    }
    
    func description(with targetCount: TargetCount, localizedCount: String? = nil) -> String {
        let localizedModifier = localizedCount ?? targetCount.description
        switch self {
        case .unknown:
            let format = NSLocalizedString("%@ unknown type", comment: "target type")
            return String(format: format, localizedModifier)
        case .none:
            let format = NSLocalizedString("%@ nearest", comment: "target type")
            return String(format: format, localizedModifier)
        case .zero, .near:
            let format = NSLocalizedString("%@ nearest", comment: "target type")
            return String(format: format, localizedModifier)
        case .far:
            let format = NSLocalizedString("%@ farthest", comment: "target type")
            return String(format: format, localizedModifier)
        case .hpAscending, .hpAscendingOrNear:
            let format = NSLocalizedString("%@ lowest HP ratio", comment: "target type")
            return String(format: format, localizedModifier)
        case .hpDescending, .hpDescendingOrNear:
            let format = NSLocalizedString("%@ highest HP ratio", comment: "target type")
            return String(format: format, localizedModifier)
        case .hpAscendingOrNearForward:
            let format = NSLocalizedString("%@ lowest HP", comment: "target type")
            return String(format: format, localizedModifier)
        case .hpDescendingOrNearForward:
            let format = NSLocalizedString("%@ highest HP", comment: "target type")
            return String(format: format, localizedModifier)
        case .forward:
            let format = NSLocalizedString("%@ most forward", comment: "target type")
            return String(format: format, localizedModifier)
        case .backward:
            let format = NSLocalizedString("%@ most backward", comment: "target type")
            return String(format: format, localizedModifier)
        case .tpDescending, .tpDescendingOrNear:
            let format = NSLocalizedString("%@ highest TP", comment: "target type")
            return String(format: format, localizedModifier)
        case .tpAscending, .tpReducing, .tpAscendingOrNear:
            let format = NSLocalizedString("%@ lowest TP", comment: "target type")
            return String(format: format, localizedModifier)
        case .atkDescending, .atkDescendingOrNear:
            let format = NSLocalizedString("%@ highest ATK", comment: "")
            return String(format: format, localizedModifier)
        case .atkAscending, .atkAscendingOrNear:
            let format = NSLocalizedString("%@ lowest ATK", comment: "")
            return String(format: format, localizedModifier)
        case .magicSTRDescending, .magicSTRDescendingOrNear:
            let format = NSLocalizedString("%@ highest Magic STR", comment: "")
            return String(format: format, localizedModifier)
        case .magicSTRAscending, .magicSTRAscendingOrNear:
            let format = NSLocalizedString("%@ lowest Magic STR", comment: "")
            return String(format: format, localizedModifier)
        case .random, .randomOnce:
            let format = NSLocalizedString("%@ random", comment: "")
            return String(format: format, localizedModifier)
//        case .randomOnce:
//            let format = NSLocalizedString("%@ random(once)", comment: "")
//            return String(format: format, localizedModifier)
        case .summon:
            let format = NSLocalizedString("%@ minion", comment: "")
            return String(format: format, localizedModifier)
        case .physics:
            let format = NSLocalizedString("%@ physics", comment: "")
            return String(format: format, localizedModifier)
        case .magic:
            let format = NSLocalizedString("%@ magic", comment: "")
            return String(format: format, localizedModifier)
        case .boss:
            let format = NSLocalizedString("%@ boss", comment: "")
            return String(format: format, localizedModifier)
        case .shadow:
            let format = NSLocalizedString("%@ shadow", comment: "")
            return String(format: format, localizedModifier)
        case .nearExceptSelf:
            let format = NSLocalizedString("%@ nearest except self", comment: "")
            return String(format: format, localizedModifier)
        default:
            return description
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
                let format = NSLocalizedString("the %@ nearest", comment: "target type")
                return String(format: format, localizedModifier)
            case .zero, .near:
                let format = NSLocalizedString("the %@ nearest", comment: "target type")
                return String(format: format, localizedModifier)
            case .far:
                let format = NSLocalizedString("the %@ farthest", comment: "target type")
                return String(format: format, localizedModifier)
            case .hpAscending, .hpAscendingOrNear:
                let format = NSLocalizedString("the %@ lowest HP ratio", comment: "target type")
                return String(format: format, localizedModifier)
            case .hpDescending, .hpDescendingOrNear:
                let format = NSLocalizedString("the %@ highest HP ratio", comment: "target type")
                return String(format: format, localizedModifier)
            case .hpAscendingOrNearForward:
                let format = NSLocalizedString("the %@ lowest HP", comment: "target type")
                return String(format: format, localizedModifier)
            case .hpDescendingOrNearForward:
                let format = NSLocalizedString("the %@ highest HP", comment: "target type")
                return String(format: format, localizedModifier)
            case .forward:
                let format = NSLocalizedString("the %@ most forward", comment: "target type")
                return String(format: format, localizedModifier)
            case .backward:
                let format = NSLocalizedString("the %@ most backward", comment: "target type")
                return String(format: format, localizedModifier)
            case .tpDescending, .tpDescendingOrNear:
                let format = NSLocalizedString("the %@ highest TP", comment: "target type")
                return String(format: format, localizedModifier)
            case .tpAscending, .tpReducing, .tpAscendingOrNear:
                let format = NSLocalizedString("the %@ lowest TP", comment: "target type")
                return String(format: format, localizedModifier)
            case .atkDescending, .atkDescendingOrNear:
                let format = NSLocalizedString("the %@ highest ATK", comment: "")
                return String(format: format, localizedModifier)
            case .atkAscending, .atkAscendingOrNear:
                let format = NSLocalizedString("the %@ lowest ATK", comment: "")
                return String(format: format, localizedModifier)
            case .magicSTRDescending, .magicSTRDescendingOrNear:
                let format = NSLocalizedString("the %@ highest Magic STR", comment: "")
                return String(format: format, localizedModifier)
            case .magicSTRAscending, .magicSTRAscendingOrNear:
                let format = NSLocalizedString("the %@ lowest Magic STR", comment: "")
                return String(format: format, localizedModifier)
            case .nearExceptSelf:
                let format = NSLocalizedString("the %@ nearest except self", comment: "")
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
