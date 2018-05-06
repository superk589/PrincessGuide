//
//  Master.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/9.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import FMDB
import SwiftyJSON

typealias FMDBCallBackClosure<T> = (T) -> Void
typealias FMDBWrapperClosure = (FMDatabase) throws -> Void

extension FMDatabaseQueue {
    func execute(_ task: @escaping FMDBWrapperClosure, completion:
        (() -> Void)? = nil) {
        inDatabase { (db) in
            defer {
                db.close()
            }
            do {
                if db.open(withFlags: SQLITE_OPEN_READONLY) {
                    try task(db)
                }
            } catch {
                print(db.lastErrorMessage())
            }
            completion?()
        }
    }
}

class Master: FMDatabaseQueue {
    
    static let url = URL(fileURLWithPath: Path.cache).appendingPathComponent("master.db")
    
    static let shared = Master(path: url.path)
    
    static func checkDatabaseFile() -> Bool {
        if FileManager.default.fileExists(atPath: url.path) {
            if let resourceValues = try? url.resourceValues(forKeys: [.fileSizeKey]) {
                let fileSize = resourceValues.fileSize!
                return fileSize > 0
            }
        }
        return false
    }
    
    func getCards(callback: @escaping FMDBCallBackClosure<[Card]>) {
        var cards = [Card]()
        execute({ (db) in
            let selectSql = """
            SELECT
                a.*,
                b.union_burst,
                b.main_skill_1,
                b.main_skill_2,
                b.ex_skill_1,
                b.ex_skill_evolution_1,
                b.main_skill_3,
                b.main_skill_4,
                b.main_skill_5,
                b.main_skill_6,
                b.main_skill_7,
                b.main_skill_8,
                b.main_skill_9,
                b.main_skill_10,
                b.ex_skill_2,
                b.ex_skill_evolution_2,
                b.ex_skill_3,
                b.ex_skill_evolution_3,
                b.ex_skill_4,
                b.ex_skill_evolution_4,
                b.ex_skill_5,
                b.sp_skill_1,
                b.ex_skill_evolution_5,
                b.sp_skill_2,
                b.sp_skill_3,
                b.sp_skill_4,
                b.sp_skill_5
            FROM
                unit_skill_data b,
                unit_data a
            WHERE
                a.unit_id = b.unit_id
            """
            let set = try db.executeQuery(selectSql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let id = json["unit_id"].intValue
                if id > 400000 { continue }
                
                let promotionSql = """
                SELECT
                    *
                FROM
                    unit_promotion
                WHERE
                    unit_id = \(json["unit_id"])
                """
                let promotionSet = try db.executeQuery(promotionSql, values: nil)
                
                var promotions = [Card.Promotion]()
                while promotionSet.next() {
                    let json = JSON(promotionSet.resultDictionary ?? [:])
                    
                    var slots = [Int]()
                    for i in 1...6 {
                        slots.append(json["equip_slot_\(i)"].intValue)
                    }
                    let level = json["promotion_level"].intValue
                    let promotion = Card.Promotion(equipSlots: slots, promotionLevel: level)
                    promotions.append(promotion)
                }
                
                let raritySql = """
                SELECT
                    *
                FROM
                    unit_rarity
                WHERE
                    unit_id = \(json["unit_id"])
                """
                let raritySet = try db.executeQuery(raritySql, values: nil)
                
                var rarities = [Card.Rarity]()
                while raritySet.next() {
                    let json = JSON(raritySet.resultDictionary ?? [:])
                    if let rarity = try? decoder.decode(Card.Rarity.self, from: json.rawData()) {
                        rarities.append(rarity)
                    }
                }
                
                let promotionStatusSql = """
                SELECT
                    *
                FROM
                    unit_promotion_status
                WHERE
                    unit_id = \(json["unit_id"])
                """
                let promotionStatusSet = try db.executeQuery(promotionStatusSql, values: nil)
                
                var promotionStatuses = [Card.PromotionStatus]()
                while promotionStatusSet.next() {
                    let json = JSON(promotionStatusSet.resultDictionary ?? [:])
                    if let promotionStatus = try? decoder.decode(Card.PromotionStatus.self, from: json.rawData()) {
                        promotionStatuses.append(promotionStatus)
                    }
                }
                
                if let base = try? decoder.decode(Card.Base.self, from: json.rawData()) {
                    let card = Card(base: base, promotions: promotions, rarities: rarities, promotionStatuses: promotionStatuses)
                    cards.append(card)
                }
            }
        }) {
            callback(cards)
        }
    }
    
    func getAttackPatterns(unitID: Int, callback: @escaping FMDBCallBackClosure<[AttackPattern]>) {
        var results = [AttackPattern]()
        execute({ (db) in
            let selectSql = """
            SELECT
                *
            FROM
                unit_attack_pattern
            WHERE
                unit_id = \(unitID)
            """
            
            let set = try db.executeQuery(selectSql, values: nil)
            while set.next() {
                
                let json = JSON(set.resultDictionary ?? [:])

                let loopEnd = json["loop_end"].intValue
                let loopStart = json["loop_start"].intValue
                let patternID = json["pattern_id"].intValue
                
                var items = [Int]()
                for i in 1...20 {
                    let pattern = json["atk_pattern_\(i)"].intValue
                    items.append(pattern)
                }
                
                results.append(AttackPattern(items: items, loopEnd: loopEnd, loopStart: loopStart, patternID: patternID))
            }
        }) {
            callback(results)
        }
    }
    
    func getEquipments(equipmentID: Int? = nil, callback: @escaping FMDBCallBackClosure<[Equipment]>) {
        var equipments = [Equipment]()
        execute({ (db) in
            var selectSql = """
            SELECT
                *
            FROM
                equipment_data
            """
            if let id = equipmentID {
                selectSql += " WHERE equipment_id = \(id)"
            }
            let set = try db.executeQuery(selectSql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let equipment = try? decoder.decode(Equipment.self, from: json.rawData()) {
                    equipments.append(equipment)
                }
            }
        }) {
            callback(equipments)
        }
    }
    
    func getCraft(equipmentID: Int, callback: @escaping FMDBCallBackClosure<Craft?>) {
        var result: Craft?
        execute({ (db) in
            let sql = """
            SELECT
                *
            FROM
                equipment_craft
            WHERE
                equipment_id = \(equipmentID)
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])

                let equipmentID = json["equipment_id"].intValue
                let craftedCost = json["craft_cost"].intValue
                
                var consumes = [Craft.Consume]()
                
                for i in 1...10 {
                    let id = json["condition_equipment_id_\(i)"].intValue
                    if id == 0 {
                        continue
                    }
                    let consumeNum = json["consume_num_\(i)"].intValue
                    let consume = Craft.Consume(equipmentID: id, consumeNum: consumeNum)
                    consumes.append(consume)
                }
                
                let craft = Craft(consumes: consumes, craftedCost: craftedCost, equipmentId: equipmentID)
                result = craft
                break
            }
        }) {
            callback(result)
        }
    }
    
    func getSkill(skillID: Int, callback: @escaping FMDBCallBackClosure<Skill?>) {
        var result: Skill?
        execute({ (db) in
            let sql = """
            SELECT
                *
            FROM
                skill_data
            WHERE
                skill_id = \(skillID)
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                var actionIDs = [Int]()
                for i in 1...7 {
                    let field = "action_\(i)"
                    let id = json[field].intValue
                    if id != 0 {
                        actionIDs.append(id)
                    }
                }
                
                var actions = [Skill.Action]()
                
                let actionSql = """
                SELECT
                    *
                FROM
                    skill_action
                WHERE
                    action_id IN (\(actionIDs.map(String.init).joined(separator: ",")))
                """
                
                let subSet = try db.executeQuery(actionSql, values: nil)
                while subSet.next() {
                    let json = JSON(subSet.resultDictionary ?? [:])
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let action = try? decoder.decode(Skill.Action.self, from: json.rawData()) {
                        actions.append(action)
                    }
                }
                if let base = try? decoder.decode(Skill.Base.self, from: json.rawData()) {
                    let skill = Skill(actions: actions, base: base)
                    result = skill
                    break
                }
            }
        }) {
            callback(result)
        }
    }
    
    func getAreas(callback: @escaping FMDBCallBackClosure<[Area]>) {
        var areas = [Area]()
        execute({ (db) in
            let sql = """
            SELECT
                *
            FROM
                quest_area_data
            WHERE
                area_id < 20000
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let area = try? decoder.decode(Area.self, from: json.rawData()) {
                    areas.append(area)
                }
            }
        }) {
            callback(areas)
        }
    }
    
    func getQuests(areaID: Int? = nil, containsEquipment equipmentID: Int? = nil, callback: @escaping FMDBCallBackClosure<[Quest]>) {
        var quests = [Quest]()
        execute({ (db) in
            var sql = """
            SELECT
                *
            FROM
                quest_data
            """
            if let areaID = areaID {
                sql.append(" WHERE area_id = \(areaID)")
            }
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                var waveIDs = [Int]()
                for i in 1...3 {
                    let field = "wave_group_id_\(i)"
                    let id = json[field].intValue
                    if id != 0 {
                        waveIDs.append(id)
                    }
                }
                let waveSql = """
                SELECT
                    *
                FROM
                    wave_group_data
                WHERE
                    wave_group_id IN (\(waveIDs.map(String.init).joined(separator: ",")))
                """
                var waves = [Wave]()
                let waveSet = try db.executeQuery(waveSql, values: nil)
                while waveSet.next() {
                    let json = JSON(waveSet.resultDictionary ?? [:])
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    var dropRewardIDs = [Int]()
                    for i in 1...5 {
                        let field = "drop_reward_id_\(i)"
                        let id = json[field].intValue
                        if id != 0 {
                            dropRewardIDs.append(id)
                        }
                    }
                    let dropRewardSql = """
                    SELECT
                        *
                    FROM
                        enemy_reward_data
                    WHERE
                        drop_reward_id IN (\(dropRewardIDs.map(String.init).joined(separator: ",")))
                    """
                    let dropRewardSet = try db.executeQuery(dropRewardSql, values: nil)
                    var drops = [Drop]()
                    while dropRewardSet.next() {
                        let json = JSON(dropRewardSet.resultDictionary ?? [:])
                       
                        var rewards = [Drop.Reward]()
                        for i in 1...5 {
                            let odds = json["odds_\(i)"].intValue
                            let rewardID = json["reward_id_\(i)"].intValue
                            let rewardType = json["reward_type_\(i)"].intValue
                            let rewardNum = json["reward_num_\(i)"].intValue
                            if rewardID != 0 {
                                rewards.append(Drop.Reward(odds: odds, rewardID: rewardID, rewardNum: rewardNum, rewardType: rewardType))
                            }
                        }
                        let dropCount = json["drop_count"].intValue
                        let dropRewardID = json["drop_reward_id"].intValue
                        let drop = Drop(dropCount: dropCount, dropRewardId: dropRewardID, rewards: rewards)
                        drops.append(drop)
                    }
                    
                    if let base = try? decoder.decode(Wave.Base.self, from: json.rawData()) {
                        let wave = Wave(base: base, drops: drops)
                        waves.append(wave)
                    }
                }
                if let base = try? decoder.decode(Quest.Base.self, from: json.rawData()) {
                    let quest = Quest(base: base, waves: waves)
                    if equipmentID == nil {
                        quests.append(quest)
                    } else if quest.allRewards.contains(where: { $0.rewardID == equipmentID! }) {
                        quests.append(quest)
                    }
                }
            }
        }) {
            callback(quests)
        }
    }
    
    func getMaxLevel(callback: @escaping FMDBCallBackClosure<Int?>) {
        var result: Int?
        execute({ (db) in
            let sql = """
            SELECT
                max(unit_level) max_unit_level
            FROM
                experience_unit
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                result = Int(set.int(forColumn: "max_unit_level")) - 1
            }
        }) {
            callback(result)
        }
    }
    
    func getCoefficient(callback: @escaping FMDBCallBackClosure<Coefficient?>) {
        var result: Coefficient?
        execute({ (db) in
            let sql = """
            SELECT
                *
            FROM
                unit_status_coefficient
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                result = try? decoder.decode(Coefficient.self, from: json.rawData())
            }
        }) {
            callback(result)
        }
    }

}
