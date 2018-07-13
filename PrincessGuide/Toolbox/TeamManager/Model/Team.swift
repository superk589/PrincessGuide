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
    
    enum Mark: String, CustomStringConvertible {
        
        case attack
        case defense
        
        var description: String {
            
            switch self {
            case .attack:
                return NSLocalizedString("attack", comment: "")
            case .defense:
                return NSLocalizedString("defense", comment: "")
            }
        }
        
        static var allLabels: [Mark] {
            return [Mark.attack, .defense]
        }
    }
    
    enum Tag: String, CustomStringConvertible {
        case pvp
        case pve
        case clanBattle
        case princessArena
        case dungeon
        case arena
        case other
        
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
            case .other:
                return NSLocalizedString("other", comment: "")
            }
        }
        
        static var allLabels: [Tag] {
            return [Tag.pvp, .pve, .princessArena, .arena, .clanBattle, .dungeon, .other]
        }
    }

    convenience init(anotherTeam: Team, context: NSManagedObjectContext) {
        self.init(context: context)
        tag = anotherTeam.tag
        name = anotherTeam.name
        modifiedAt = Date()
        mark = anotherTeam.mark
        anotherTeam.members?.forEach {
            let member = Member(anotherMember: $0 as! Member, context: context)
            addToMembers(member)
        }
    }
    
    var typedTag: Tag? {
        return tag.flatMap { Tag(rawValue: $0) }
    }
    
    var typedMark: Mark? {
        return mark.flatMap { Mark(rawValue: $0) }
    }
    
    var sortedMembers: [Member] {
        return (members?.allObjects as? [Member])?.sorted { ($0.card?.base.searchAreaWidth ?? .min) > ($1.card?.base.searchAreaWidth ?? .min) } ?? []
    }

}
