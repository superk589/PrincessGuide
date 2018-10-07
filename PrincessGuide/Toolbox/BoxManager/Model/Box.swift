//
//  Box.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/6.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation
import CoreData

extension Box {
    
    convenience init(anotherBox: Box, context: NSManagedObjectContext) {
        self.init(context: context)
        anotherBox.charas?.forEach {
            self.addToCharas($0 as! Chara)
        }
        name = anotherBox.name
        modifiedAt = Date()
    }
    
}
