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
    
    class Round: Codable {
        
        class Group: Codable {
            
            init(bossId: Int, waveGroupId: Int, scoreCoefficient: Double) {
                self.bossId = bossId
                self.waveGroupId = waveGroupId
                self.scoreCoefficient = scoreCoefficient
            }
            
            let bossId: Int
            let waveGroupId: Int
            let scoreCoefficient: Double
            
            lazy var wave: Wave? = DispatchSemaphore.sync { closure in
                return Master.shared.getWaves(waveIDs: [waveGroupId], callback: closure)
            }?.first
            
            func preload() {
                _ = wave
            }
        }
        
        let id: Int
        let clanBattleId: Int
        let mapBg: Int
        let difficulty: Int
        let lapNumFrom: Int
        var lapNumTo: Int
        let bossId1: Int
        let bossId2: Int
        let bossId3: Int
        let bossId4: Int
        let bossId5: Int
        let auraEffect: Int
        let rslUnlockLap: Int
        let phase: Int
        let waveGroupId1: Int
        let waveGroupId2: Int
        let waveGroupId3: Int
        let waveGroupId4: Int
        let waveGroupId5: Int
        let fixRewardId1: Int
        let fixRewardId2: Int
        let fixRewardId3: Int
        let fixRewardId4: Int
        let fixRewardId5: Int
        let damageRankId1: Int
        let damageRankId2: Int
        let damageRankId3: Int
        let damageRankId4: Int
        let damageRankId5: Int
        let limitedMana: Int
        let lastAttackRewardId: Int
        let scoreCoefficient1: Double
        let scoreCoefficient2: Double
        let scoreCoefficient3: Double
        let scoreCoefficient4: Double
        let scoreCoefficient5: Double
        let paramAdjustId: Int
        let paramAdjustInterval: Int
        
        func preload() {
            groups.forEach {
                $0.preload()
            }
        }
        
        lazy var groups: [Group] = {
            var groups = [Group]()
            groups.append(Group(bossId: self.bossId1, waveGroupId: self.waveGroupId1, scoreCoefficient: self.scoreCoefficient1))
            groups.append(Group(bossId: self.bossId2, waveGroupId: self.waveGroupId2, scoreCoefficient: self.scoreCoefficient2))
            groups.append(Group(bossId: self.bossId3, waveGroupId: self.waveGroupId3, scoreCoefficient: self.scoreCoefficient3))
            groups.append(Group(bossId: self.bossId4, waveGroupId: self.waveGroupId4, scoreCoefficient: self.scoreCoefficient4))
            groups.append(Group(bossId: self.bossId5, waveGroupId: self.waveGroupId5, scoreCoefficient: self.scoreCoefficient5))
            return groups
        }()
                
        var name: String {
            if lapNumFrom == lapNumTo {
                return String(format: NSLocalizedString("Round %d", comment: ""), lapNumFrom)
            } else if lapNumTo == -1 {
                return String(format: NSLocalizedString("Round %d+", comment: ""), lapNumFrom)
            } else {
                return String(format: NSLocalizedString("Round %d ~ %d", comment: ""), lapNumFrom, lapNumTo)
            }
        }
    }
    
    var name: String {
        let date = period.startTime.toDate()
        return String(format: NSLocalizedString("Clan Battle %d-%d", comment: ""), date.year, date.month)
    }
    
    lazy var rounds: [Round] = DispatchSemaphore.sync { (closure) in
        return Master.shared.getClanBattleRounds(clanBattleID: period.clanBattleId, callback: closure)
    } ?? []
    
    lazy var simpleRounds: [Round] = DispatchSemaphore.sync { (closure) in
        return Master.shared.getClanBattleRoundsSimple(clanBattleID: period.clanBattleId, callback: closure)
    } ?? []
    
    func preload() {
        _ = rounds
        rounds.forEach {
            $0.preload()
        }
        simpleRounds.forEach {
            $0.preload()
        }
    }
    
    lazy var mergedRounds: [Round] = {
        let newRounds: [Round] = rounds.reduce(into: []) { results, element in
            if let round = results.first(where: { $0.groups.map { $0.waveGroupId } == element.groups.map { $0.waveGroupId } }) {
                round.lapNumTo = element.lapNumTo
            } else {
                results.append(element)
            }
        }
        return newRounds
    }()
    
    lazy var mergedSimpleRounds: [Round] = {
        let newRounds: [Round] = simpleRounds.reduce(into: []) { results, element in
            if let round = results.first(where: { $0.groups.map { $0.waveGroupId } == element.groups.map { $0.waveGroupId } }) {
                round.lapNumTo = element.lapNumTo
            } else {
                results.append(element)
            }
        }
        return newRounds
    }()
    
    init(period: Period) {
        self.period = period
    }

}
