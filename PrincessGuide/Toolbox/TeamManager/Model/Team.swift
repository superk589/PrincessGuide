//
//  Team.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/10.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation
import CoreData

extension Team {
    
    enum Style: String, CustomStringConvertible {
        
        case ally
        case opponent
        case none
        
        var description: String {
            
            switch self {
            case .ally:
                return NSLocalizedString("ally", comment: "")
            case .opponent:
                return NSLocalizedString("opponent", comment: "")
            case .none:
                return NSLocalizedString("none", comment: "")
            }
        }
        
        static var allLabels: [Style] {
            return [Style.none, .ally, .opponent]
        }
    }
    
    enum Tag: String, CustomStringConvertible {
        case pvp
        case pve
        case clanBattle
        case princessArena
        case dungeon
        case arena
        case none
        
        var description: String {
            switch self {
            case .pvp:
                return NSLocalizedString("pvp", comment: "")
            case .pve:
                return NSLocalizedString("pve", comment: "")
            case .clanBattle:
                return NSLocalizedString("clan battle", comment: "")
            case .princessArena:
                return NSLocalizedString("princess arena", comment: "")
            case .dungeon:
                return NSLocalizedString("dungeon", comment: "")
            case .arena:
                return NSLocalizedString("arena", comment: "")
            case .none:
                return NSLocalizedString("none", comment: "")
            }
        }
        
        static var allLabels: [Tag] {
            return [Tag.pvp, .pve, .clanBattle, .dungeon, .princessArena, .arena]
        }
    }

    convenience init(anotherTeam: Team, context: NSManagedObjectContext) {
        self.init(context: context)
        tag = anotherTeam.tag
        name = anotherTeam.name
        modifiedAt = Date()
        style = anotherTeam.style
        anotherTeam.members?.forEach {
            let member = Member(anotherMember: $0 as! Member, context: context)
            addToMembers(member)
        }
    }
    
    var typedTag: Tag? {
        return tag.flatMap { Tag(rawValue: $0) }
    }
    
    var typedStyle: Style? {
        return style.flatMap { Style(rawValue: $0) }
    }

}
