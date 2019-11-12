//
//  ActionTag.swift
//  PrincessGuide
//
//  Created by zzk on 8/14/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation

enum ActionTag: CustomStringConvertible {
    
    case count(TargetCount)
    case direction(DirectionType)
    case targetType(TargetType)
    case relation(TargetAssignment)
    case range(Int)
    case nth(TargetNth)
    case custom(String)
    var description: String {
        switch self {
        case .count(let count):
            return count.description
        case .direction(let direction):
            return direction.description
        case .targetType(let type):
            return type.description
        case .relation(let relation):
            return relation.description
        case .range(let x):
            let format = NSLocalizedString("radius %d", comment: "")
            return String(format: format, x)
        case .nth(let nth):
            return nth.description
        case .custom(let string):
            return string
        }
    }
    
    var attachmentString: String {
        return "attachment:\(description):"
    }
}
