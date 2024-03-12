//
//  TalentArea.swift
//  PrincessGuide
//
//  Created by zzk on 2024/3/12.
//  Copyright © 2024 zzk. All rights reserved.
//

import Foundation

class TalentArea: Codable {
    
    let areaId: Int
    let talentId: Int
    let areaName: String
    
    init(areaId: Int, talentId: Int, areaName: String) {
        self.areaId = areaId
        self.talentId = talentId
        self.areaName = areaName
    }
    
    lazy var quests: [TalentQuest] = DispatchSemaphore.sync { [weak self] (closure) in
        Master.shared.getTalentQuests(areaID: self?.areaId, callback: closure)
    } ?? []
}
