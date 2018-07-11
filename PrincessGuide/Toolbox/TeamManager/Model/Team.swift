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

}
