//
//  Skill.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/20.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

enum SkillCategory: String, Hashable, CustomStringConvertible {
    case unionBurst
    case main
    case ex
    case exEvolution
    case sp
    
    case mainEvolution
    case unionBurstEvolution
    
    var description: String {
        switch self {
        case .unionBurst:
            return NSLocalizedString("UB", comment: "")
        case .main:
            return NSLocalizedString("Main", comment: "")
        case .ex:
            return NSLocalizedString("EX", comment: "")
        case .exEvolution:
            return NSLocalizedString("EX+", comment: "")
        case .sp:
            return NSLocalizedString("SP", comment: "")
        case .mainEvolution:
            return NSLocalizedString("Main+", comment: "")
        case .unionBurstEvolution:
            return NSLocalizedString("UB+", comment: "")
        }
    }
}

class Skill: Codable {
    
    var actions: [Action]
    let base: Base
    
    init(actions: [Action], base: Base) {
        self.actions = actions
        self.base = base
    }
        
    struct Base: Codable {
        let dependAction1: Int
        let dependAction2: Int
        let dependAction3: Int
        let dependAction4: Int
        let dependAction5: Int
        let dependAction6: Int
        let dependAction7: Int
        let description: String
        let iconType: Int
        let name: String
        let skillAreaWidth: Int
        let skillCastTime: Double
        let skillId: Int
        let skillType: Int
    }
    
    class Action: Codable {
        
        struct Base: Codable {
            let actionDetail1: Int
            let actionDetail2: Int
            let actionDetail3: Int
            let actionId: Int
            let actionType: Int
            let actionValue1: Double
            let actionValue2: Double
            let actionValue3: Double
            let actionValue4: Double
            let actionValue5: Double
            let actionValue6: Double
            let actionValue7: Double
            let classId: Int
            let description: String
            let levelUpDisp: String
            let targetArea: Int
            var targetAssignment: Int
            var targetCount: Int
            let targetNumber: Int
            let targetRange: Int
            let targetType: Int
            
        }
        
        let base: Base
        
        init(base: Base) {
            self.base = base
        }
        
        weak var parent: Action?
        
        var children: [Action] = []
        
        lazy var parameter: ActionParameter = {
            return buildParameter()
        }()
        
        func buildParameter() -> ActionParameter {
            return ActionParameter.type(of: base.actionType).init(id: base.actionId, targetAssignment: base.targetAssignment, targetNth: base.targetNumber, actionType: base.actionType, targetType: base.targetType, targetRange: base.targetRange, direction: base.targetArea, targetCount: base.targetCount, actionValue1: base.actionValue1, actionValue2: base.actionValue2, actionValue3: base.actionValue3, actionValue4: base.actionValue4, actionValue5: base.actionValue5, actionValue6: base.actionValue6, actionValue7: base.actionValue7, actionDetail1: base.actionDetail1, actionDetail2: base.actionDetail2, actionDetail3: base.actionDetail3, parent: parent, children: children)
        }
    }
    
}

extension Skill {
    
    var iconURL: URL {
        return URL.resource.appendingPathComponent("icon/skill/\(base.iconType).webp")
    }
}
