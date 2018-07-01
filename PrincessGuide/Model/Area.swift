//
//  Area.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class Area: Codable {
    
    let areaId: Int
    let areaName: String
    let endTime: String
    let mapType: Int
    let queId: String
    let sheetId: String
    let startTime: String
    
    init(areaId: Int, areaName: String, endTime: String, mapType: Int, queId: String, sheetId: String, startTime: String) {
        self.areaId = areaId
        self.areaName = areaName
        self.endTime = endTime
        self.mapType = mapType
        self.queId = queId
        self.sheetId = sheetId
        self.startTime = startTime
    }

    lazy var quests: [Quest] = DispatchSemaphore.sync { (closure) in
        Master.shared.getQuests(areaID: areaId, callback: closure)
    } ?? []
}

enum AreaType: CustomStringConvertible {
    case normal
    case hard
    
    case exploration
    
    case unknown
    
    var description: String {
        switch self {
            
        case .normal:
            return NSLocalizedString("Normal", comment: "")
        case .hard:
            return NSLocalizedString("Hard", comment: "")
        case .exploration:
            return NSLocalizedString("Exploration", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown", comment: "")
        }
    }
}

extension Area {
    
    var areaType: AreaType {
        switch areaId {
        case 11000..<12000:
            return .normal
        case 12000..<13000:
            return .hard
        case 21000..<22000:
            return .exploration
        default:
            return .unknown
        }
    }
    
}
