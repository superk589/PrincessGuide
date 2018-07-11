//
//  EditTeamViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/10.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import CoreData
import Eureka
import Gestalt
import SwiftyJSON

class EditTeamViewController: FormViewController {
    
    let team: Team?
    
    let context: NSManagedObjectContext
    let parentContext: NSManagedObjectContext
    
    enum Mode {
        case edit
        case create
    }
    
    let mode: Mode
    
    init() {
        mode = .create
        context = CoreDataStack.default.newChildContext(parent: CoreDataStack.default.viewContext)
        team = Team(context: context)
        parentContext = CoreDataStack.default.viewContext
        super.init(nibName: nil, bundle: nil)
    }
    
    init(team: Team) {
        mode = .edit
        parentContext = team.managedObjectContext ?? CoreDataStack.default.viewContext
        context = CoreDataStack.default.newChildContext(parent: parentContext)
        self.team = context.object(with: team.objectID) as? Team
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
