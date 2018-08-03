//
//  ClanBattle.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation
import Timepiece

class ClanBattle: Codable {
    
    let period: Period
    
    let groups: [Group]
    
    struct Period: Codable {
        let clanBattleId: Int
        let period: Int
        let periodDetail: String
        let startTime: String
        let endTime: String
        let intervalStart: String
        let intervalEnd: String
        let calcStart: String
        let resultStart: String
        let resultEnd: String
    }
    
    struct Group: Codable {
        let wave: Wave
        let groupId: Int
        let orderNum: Int
        let scoreCoefficient: Double
    }
    
    struct Round {
        let groups: [Group]
        let groupId: Int
        
        var name: String {
            return String(format: NSLocalizedString("Round %d", comment: ""), groupId % 10)
        }
    }
    
    var name: String {
        let date = period.startTime.toDate()
        return String(format: NSLocalizedString("Clan Battle %d-%d", comment: ""), date.year, date.month)
    }
    
    lazy var rounds: [Round] = {
        var rounds = [Round]()
        var ids = Set(groups.map { $0.groupId })
        for id in ids {
            let round = Round(groups: groups.filter { $0.groupId == id }, groupId: id)
            rounds.append(round)
        }
        return rounds.sorted { $0.groupId < $1.groupId }
    }()
    
    init(period: Period, groups: [Group]) {
        self.period = period
        self.groups = groups
    }

}
