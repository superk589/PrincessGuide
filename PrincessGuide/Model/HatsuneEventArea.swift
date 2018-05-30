//
//  HatsuneEventArea.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/17.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

/// HatsuneEventArea represents all the event areas like the first hatsune event, including normal and hard.
class HatsuneEventArea: Codable {
  
    struct Base: Codable {
        let areaDisp: Int
        let areaId: Int
        let areaName: String
        let endTime: String
        let eventId: Int
        let mapType: Int
        let queId: String
        let sheetId: String
        let startTime: String
        let title: String
        let waveGroupId1: Int
    }
    
    let base: Base
    
    init(base: Base) {
        self.base = base
    }
    
    var areaType: AreaType {
        switch base.areaId % 1000 {
        case 100..<200:
            return .normal
        case 200..<300:
            return .hard
        default:
            return .unknown
        }
    }
    
    lazy var wave: Wave? = DispatchSemaphore.sync { (closure) in
        Master.shared.getWaves(waveIDs: [base.waveGroupId1], callback: closure)
    }?.first
    
}
