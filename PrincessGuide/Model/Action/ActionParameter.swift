//
//  ActionParameter.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/24.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class ActionParameter {
    
    class func type(of rawType: Int) -> ActionParameter.Type {
        switch rawType {
        case 1:
            return DamageAction.self
        case 2:
            return MoveAction.self
        case 3:
            return KnockAction.self
        case 4:
            return HealAction.self
        case 5:
            return CureAction.self
        case 6:
            return BarrierAction.self
        case 7:
            return ReflexiveAction.self
        case 8, 9, 11, 12, 13:
            return AilmentAction.self
        case 10:
            return AuraAction.self
        case 14:
            return ModeChangeAction.self
        case 15:
            return SummonAction.self
        case 16:
            return ChangeEnergyAction.self
        case 17:
            return TriggerAction.self
        case 18:
            return DamageChargeAction.self
        case 19:
            return ChargeAction.self
        case 20:
            return TauntAction.self
        case 21:
            return NoDamageAction.self
        case 22:
            return ChangePatterAction.self
        case 23:
            return IfForChildrenAction.self
        case 24:
            return RevivalAction.self
        case 25:
            return ContinuousAttackAction.self
        case 26:
            return AdditiveAction.self
        case 27:
            return MultipleAction.self
        case 28:
            return IfForAllAction.self
        case 29:
            return SearchAreaChangeAction.self
        case 30:
            return DestroyAction.self
        case 31:
            return ContinuousAttackNearbyAction.self
        case 32:
            return EnchantLifeStealAction.self
        case 33:
            return EnchantStrikeBackAction.self
        case 34:
            return AccumulativeDamageAction.self
        case 35:
            return SealAction.self
        case 36:
            return AttackFieldAction.self
        case 37:
            return HealFieldAction.self
        case 38:
            return ChangeParameterFieldAction.self
        case 39:
            return DotFieldAction.self
        case 40:
            return ChangeSpeedFieldAction.self
        case 41:
            return UBChangeTimeAction.self
        case 42:
            return LoopTriggerAction.self
        case 43:
            return IfHasTargetAction.self
        case 44:
            return WaveStartIdleAction.self
        case 45:
            return SkillExecCountAction.self
        case 46:
            return RatioDamageAction.self
        case 47:
            return UpperLimitAttackAction.self
        case 48:
            return RegenerationAction.self
        case 90:
            return PassiveAction.self
        case 91:
            return PassiveInermittentAction.self
        default:
            return ActionParameter.self
        }
    }
    
    var isHealingAction: Bool {
        switch rawActionType {
        case 4, 37, 48:
            return true
        default:
            return false
        }
    }
   
    let targetParameter: TargetParameter
    let actionType: ActionType
   
    let rawActionType: Int
    let id: Int
    
    let actionValue1: Double
    let actionValue2: Double
    let actionValue3: Double
    let actionValue4: Double
    let actionValue5: Double
    let actionValue6: Double
    let actionValue7: Double
    
    lazy var rawActionValues = [
        self.actionValue1,
        self.actionValue2,
        self.actionValue3,
        self.actionValue4,
        self.actionValue5,
        self.actionValue6,
        self.actionValue7
    ]
    
    let actionDetail1: Int
    let actionDetail2: Int
    let actionDetail3: Int
    
    lazy var actionDetails = [
        self.actionDetail1,
        self.actionDetail2,
        self.actionDetail3
    ]
    
    required init(id: Int, targetAssignment: Int, targetNth: Int, actionType: Int, targetType: Int, targetRange: Int,
                  direction: Int, targetCount: Int, actionValue1: Double, actionValue2: Double, actionValue3: Double, actionValue4: Double, actionValue5: Double, actionValue6: Double, actionValue7: Double, actionDetail1: Int, actionDetail2: Int, actionDetail3: Int) {
        self.targetParameter = TargetParameter(targetAssignment: targetAssignment, targetNth: targetNth, targetType: targetType, targetRange: targetRange, direction: direction, targetCount: targetCount)
        self.id = id
        self.rawActionType = actionType
        self.actionType = ActionType(rawValue: actionType) ?? .unknown
        self.actionValue1 = actionValue1
        self.actionValue2 = actionValue2
        self.actionValue3 = actionValue3
        self.actionValue4 = actionValue4
        self.actionValue5 = actionValue5
        self.actionValue6 = actionValue6
        self.actionValue7 = actionValue7
        self.actionDetail1 = actionDetail1
        self.actionDetail2 = actionDetail2
        self.actionDetail3 = actionDetail3
    }
    
    func localizedDetail(of level: Int,
                         property: Property = .zero,
                         style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Unknown effect %d to %@ with details [%@], values [%@].", comment: "")
        return String(
            format: format,
            rawActionType,
            targetParameter.buildTargetClause(),
            actionDetails
                .filter { $0 != 0 }
                .map(String.init)
                .joined(separator: ","),
            rawActionValues
                .filter { $0 != 0 }
                .map(String.init)
                .joined(separator: ", ")
        )
    }
    
    var actionValues: [ActionValue] {
        return []
    }
    
    func buildExpression(of level: Int,
                         actionValues: [ActionValue]? = nil,
                         roundingRule: FloatingPointRoundingRule? = .down,
                         style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle,
                         property: Property = .zero) -> String {

        switch style {
        case .short:
            
            var expression = ""
            var fixedValue = 0.0
            var hasLevelCoefficient = false
            
            for value in actionValues ?? self.actionValues {
                if let value = Double(value.value), value == 0 { continue }
                switch value.key {
                case .atk:
                    expression += "\(value.value) * \(PropertyKey.atk)"
                case .magicStr:
                    expression += "\(value.value) * \(PropertyKey.magicStr)"
                case .def:
                    expression += "\(value.value) * \(PropertyKey.def)"
                case .skillLevel:
                    fixedValue += Double(level) * (Double(value.value) ?? 0)
                    if Double(value.value) != 0 {
                        hasLevelCoefficient = true
                    }
                case .initialValue:
                    fixedValue += Double(value.value) ?? 0
                }
            }
            
            let valueString: String
            if let roundingRule = roundingRule {
                valueString = String(Int(fixedValue.rounded(roundingRule)))
            } else {
                valueString = String(fixedValue)
            }
            
            if expression != "" {
                if fixedValue != 0 {
                    expression += " + \(valueString)"
                }
            } else {
                expression = "\(valueString)"
            }
            
            if hasLevelCoefficient {
                expression += "@\(level)"
            }
            
            return expression
        case .full:
            
            let actionValues = actionValues ?? self.actionValues
            let part1 = actionValues.compactMap { (value: ActionValue) -> String? in
                if let value = Double(value.value), value == 0 { return nil }
                switch value.key {
                case .atk:
                    return "\(value.value) * \(PropertyKey.atk)"
                case .magicStr:
                    return "\(value.value) * \(PropertyKey.magicStr)"
                case .def:
                    return "\(value.value) * \(PropertyKey.def)"
                default:
                    return nil
                }
            }
            
            let part2 = actionValues.compactMap { (value: ActionValue) -> String? in
                if let value = Double(value.value), value == 0 { return nil }
                switch value.key {
                case .initialValue:
                    return "\(value.value)"
                case .skillLevel:
                    return "\(value.value) * \(NSLocalizedString("SLv.", comment: ""))"
                default:
                    return nil
                }
            }
            
            return (part1 + part2).joined(separator: " + ")
        case .valueOnly:
            
            var fixedValue = 0.0
            
            for value in actionValues ?? self.actionValues {
                let key = value.key
                guard let value = Double(value.value), value != 0 else { continue }
                switch key {
                case .atk:
                    fixedValue += value * property.atk
                case .magicStr:
                    fixedValue += value * property.magicStr
                case .def:
                    fixedValue += value * property.def
                case .skillLevel:
                    fixedValue += Double(level) * value
                case .initialValue:
                    fixedValue += value
                }
            }
            
            let valueString: String
            if let roundingRule = roundingRule {
                valueString = String(Int(fixedValue.rounded(roundingRule)))
            } else {
                valueString = String(fixedValue)
            }
            
            return valueString
        case .valueInCombat:
            
            var fixedValue = 0.0
            
            for value in actionValues ?? self.actionValues {
                let key = value.key
                guard let value = Double(value.value), value != 0 else { continue }
                switch key {
                case .atk:
                    fixedValue += value * property.atk
                case .magicStr:
                    fixedValue += value * property.magicStr
                case .def:
                    fixedValue += value * property.def
                case .skillLevel:
                    fixedValue += Double(level) * value
                case .initialValue:
                    fixedValue += value
                }
            }
            
            if isHealingAction {
                fixedValue *= (property.hpRecoveryRate / 100 + 1)
            }
            
            let valueString: String
            if let roundingRule = roundingRule {
                valueString = String(Int(fixedValue.rounded(roundingRule)))
            } else {
                valueString = String(fixedValue)
            }
            
            return valueString
        }
        
    }
    
}

enum ActionKey: String {
    case atk
    case magicStr
    case def
    case skillLevel
    case initialValue
}

struct ActionValue {
    let key: ActionKey
    let value: String
}

enum PercentModifier: CustomStringConvertible {
    case percent
    case number
    
    var description: String {
        switch self {
        case .percent:
            return "%"
        case .number:
            return ""
        }
    }
    
    init(_ value: Int) {
        switch value {
        case 2:
            self = .percent
        default:
            self = .number
        }
    }
}

enum ClassModifier: Int, CustomStringConvertible {
    case unknown = 0
    case physical
    case magical
    
    var description: String {
        switch self {
        case .magical:
            return NSLocalizedString("magical", comment: "")
        case .physical:
            return NSLocalizedString("physical", comment: "")
        case .unknown:
            return NSLocalizedString("unknown", comment: "")
        }
    }
    
}

enum ActionType: Int {
    case unknown = 0
    case damage
    case move
    case knock
    case heal
    case cure
    case `guard`
    case chooseArea
    case ailment
    case dot
    case aura = 10
    case charm
    case blind
    case silence
    case changeMode
    case summon
    case changeEnergy
    case trigger
    case charge
    case damageCharge
    case taunt = 20
    case invulnerable
    case changePattern
    case ifForChildren
    case revival
    case continuousAttack
    case additive
    case multiple
    case ifForAll
    case changeSearchArea
    case instantDeath = 30
    case continuousAttackNearby
    case enhanceLifeSteal
    case enhanceStrikeBack
    case accumulativeDamage
    case seal
    case attackField
    case healField
    case changeParameterField
    case dotField
    case ailmentField = 40
    case changeUBTime
    case loopTrigger
    case ifHasTarget
    case waveStartIdle
    case skillCount
    case gravity
    case upperLimitAttack
    case hot
    case ex = 90
    case exPlus
}
