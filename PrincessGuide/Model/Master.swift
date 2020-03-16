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

typealias FMDBCallbackClosure<T> = (T) -> Void
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
    
    static let shared = Master(path: url.path)!
    
    static func checkDatabaseFile() -> Bool {
        if FileManager.default.fileExists(atPath: url.path) {
            if let resourceValues = try? url.resourceValues(forKeys: [.fileSizeKey]) {
                let fileSize = resourceValues.fileSize!
                return fileSize > 0
            }
        }
        return false
    }
    
    func getCards(cardID: Int? = nil, callback: @escaping FMDBCallbackClosure<[Card]>) {
        var cards = [Card]()
        execute({ (db) in
            var selectSql = """
            SELECT
                a.*,
                b.union_burst,
                b.union_burst_evolution,
                b.main_skill_1,
                b.main_skill_evolution_1,
                b.main_skill_2,
                b.main_skill_evolution_2,
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
            
            if let id = cardID {
                selectSql.append(" AND a.unit_id = \(id)")
            }
            
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
                
                let uniqueEquipSQL = """
                SELECT
                    *
                FROM
                    unit_unique_equip
                WHERE
                    unit_id = \(json["unit_id"])
                """
                let uniqueEquipSet = try db.executeQuery(uniqueEquipSQL, values: nil)
                
                var uniqueEquipIDs = [Int]()
                while uniqueEquipSet.next() {
                    let id = Int(uniqueEquipSet.int(forColumn: "equip_id"))
                    uniqueEquipIDs.append(id)
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
                    let promotionStatus = try decoder.decode(Card.PromotionStatus.self, from: json.rawData())
                    promotionStatuses.append(promotionStatus)
                }
                
                let commentSql = """
                SELECT
                    *
                FROM
                    unit_comments
                WHERE
                    unit_id = \(json["unit_id"])
                OR
                    unit_id = \(json["unit_id"].intValue + 30)
                """
                let commentSet = try db.executeQuery(commentSql, values: nil)
                var comments = [Card.Comment]()
                while commentSet.next() {
                    let json = JSON(commentSet.resultDictionary ?? [:])
                    let comment = try decoder.decode(Card.Comment.self, from: json.rawData())
                    comments.append(comment)
                }
                
                let profileSql = """
                SELECT
                    *
                FROM
                    unit_profile
                WHERE
                    unit_id = \(json["unit_id"])
                """
                let profileSet = try db.executeQuery(profileSql, values: nil)
                var profile: Card.Profile?
                while profileSet.next() {
                    let json = JSON(profileSet.resultDictionary ?? [:])
                    profile = try decoder.decode(Card.Profile.self, from: json.rawData())
                }
                
                let actualUnitSql = """
                SELECT
                    *
                FROM
                    actual_unit_background
                WHERE
                    unit_id like '\(json["unit_id"].stringValue.prefix(4))%'
                """
                let actualUnitSet = try db.executeQuery(actualUnitSql, values: nil)
                var actualUnit: Card.ActualUnit?
                while actualUnitSet.next() {
                    let json = JSON(actualUnitSet.resultDictionary ?? [:])
                    actualUnit = try decoder.decode(Card.ActualUnit.self, from: json.rawData())
                }
                
                let unitBackgroundSql = """
                SELECT
                    *
                FROM
                    unit_background
                WHERE
                    unit_id = \(json["unit_id"])
                """
                let unitBackgroundSet = try db.executeQuery(unitBackgroundSql, values: nil)
                var unitBackground: Card.UnitBackground?
                while unitBackgroundSet.next() {
                    let json = JSON(unitBackgroundSet.resultDictionary ?? [:])
                    unitBackground = try decoder.decode(Card.UnitBackground.self, from: json.rawData())
                }
                
                let rarity6Sql = """
                SELECT
                    *
                FROM
                    unlock_rarity_6
                WHERE
                    unit_id = \(json["unit_id"])
                """
                let rarity6Set = try db.executeQuery(rarity6Sql, values: nil)
                var rarity6s = [Card.Rarity6]()
                while rarity6Set.next() {
                    do {
                        let json = JSON(rarity6Set.resultDictionary ?? [:])
                        let rarity6 = try decoder.decode(Card.Rarity6.self, from: json.rawData())
                        rarity6s.append(rarity6)
                    } catch {
                        print(error)
                    }
                }
                
                if let base = try? decoder.decode(Card.Base.self, from: json.rawData()),
                    let profile = profile, let unitBackground = unitBackground {
                    let card = Card(base: base, promotions: promotions, rarities: rarities, promotionStatuses: promotionStatuses, profile: profile, comments: comments, actualUnit: actualUnit, unitBackground: unitBackground, uniqueEquipIDs: uniqueEquipIDs, rarity6s: rarity6s)
                    cards.append(card)
                }
            }
        }) {
            callback(cards)
        }
    }
    
    
    func getUnitMinion(minionID: Int, callback: @escaping FMDBCallbackClosure<Minion?>) {
        var minion: Minion?
        execute({ (db) in
            let selectSql = """
            SELECT
                a.*,
                b.union_burst,
                b.union_burst_evolution,
                b.main_skill_1,
                b.main_skill_evolution_1,
                b.main_skill_2,
                b.main_skill_evolution_2,
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
                AND a.unit_id = \(minionID)
            """
            
            let set = try db.executeQuery(selectSql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
    
                let raritySql = """
                SELECT
                    *
                FROM
                    unit_rarity
                WHERE
                    unit_id = \(minionID)
                """
                let raritySet = try db.executeQuery(raritySql, values: nil)
                
                var rarities = [Card.Rarity]()
                while raritySet.next() {
                    let json = JSON(raritySet.resultDictionary ?? [:])
                    if let rarity = try? decoder.decode(Card.Rarity.self, from: json.rawData()) {
                        rarities.append(rarity)
                    }
                }
                
                if let base = try? decoder.decode(Card.Base.self, from: json.rawData()) {
                    minion = Minion(base: base, rarities: rarities)
                    break
                }
            }
        }) {
            callback(minion)
        }
    }
    
    func getEnemyMinion(minionID: Int, callback: @escaping FMDBCallbackClosure<Enemy?>) {
        var minion: Enemy?
        execute({ (db) in
            let sql = """
            SELECT
                a.*,
                b.*,
                c.child_enemy_parameter_1,
                c.child_enemy_parameter_2,
                c.child_enemy_parameter_3,
                c.child_enemy_parameter_4,
                c.child_enemy_parameter_5
            FROM
                unit_skill_data b,
                enemy_parameter a
                LEFT JOIN enemy_m_parts c
                ON a.enemy_id = c.enemy_id
            WHERE
                a.unit_id = b.unit_id
                AND a.enemy_id = \(minionID)
            """
            
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let unitID = json["unit_id"].intValue
                let unitSql = """
                SELECT
                    *
                FROM
                    unit_enemy_data
                WHERE
                    unit_id = \(unitID)
                """
                var unit: Enemy.Unit?
                let unitSet = try db.executeQuery(unitSql, values: nil)
                while unitSet.next() {
                    let json = JSON(unitSet.resultDictionary ?? [:])
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        unit = try decoder.decode(Enemy.Unit.self, from: json.rawData())
                    } catch {
                        print(error)
                    }
                }
                do {
                    let base = try decoder.decode(Enemy.Base.self, from: json.rawData())
                    if let unit = unit {
                        minion = Enemy(base: base, unit: unit)
                    }
                } catch {
                    print(error)
                }
            }
        }) {
            callback(minion)
        }
    }
    
    func getStills(storyGroupID: Int, callback: @escaping FMDBCallbackClosure<[Still]>) {
        var stills = [Still]()
        execute({ (db) in
            let selectSql = """
            SELECT
                *
            FROM
                still
            WHERE
                story_group_id = \(storyGroupID)
            """
            
            let set = try db.executeQuery(selectSql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let still = try decoder.decode(Still.self, from: json.rawData())
                stills.append(still)
            }
        }) {
            callback(stills)
        }
    }
    
    func getComics(unitID: Int, callback: @escaping FMDBCallbackClosure<[Int]>) {
        var results = [Int]()
        execute({ (db) in
            let selectSql = """
            SELECT
                value
            FROM
                tips
            WHERE
                value like '\(String(unitID).prefix(4))%'
            """
            
            let set = try db.executeQuery(selectSql, values: nil)
            while set.next() {
                let id = Int(set.int(forColumn: "value"))
                results.append(id)
            }
        }) {
            callback(results)
        }
    }
    
    func getAttackPatterns(unitID: Int, callback: @escaping FMDBCallbackClosure<[AttackPattern]>) {
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
    
    func getEquipments(equipmentID: Int? = nil, equipmentType: EquipmentType? = nil, callback: @escaping FMDBCallbackClosure<[Equipment]>) {
        var equipments = [Equipment]()
        execute({ (db) in
            var selectSql = """
            SELECT
                a.*,
                b.total_point
            FROM
                equipment_data a
                LEFT JOIN (
                    SELECT
                        promotion_level,
                        max(total_point) total_point
                    FROM
                        equipment_enhance_data
                    GROUP BY
                        promotion_level) b ON a.promotion_level = b.promotion_level
            """
            if let id = equipmentID {
                selectSql += " WHERE equipment_id = \(id)"
            } else if let equipmentType = equipmentType {
                selectSql += " WHERE craft_flg = \(equipmentType.rawValue)"
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
    
    func getUniqueEquipments(equipmentIDs: [Int]?, callback: @escaping FMDBCallbackClosure<[UniqueEquipment]>) {
        var equipments = [UniqueEquipment]()
        execute({ (db) in
            var selectSql = """
            SELECT
                a.*,
                b.total_point
            FROM
                unique_equipment_data a,
                (
                    SELECT
                        max(total_point) total_point
                    FROM
                        unique_equipment_enhance_data
                ) b
            """
            if let ids = equipmentIDs {
                if ids.count > 0 {
                    selectSql += " WHERE equipment_id in (\(ids.map(String.init).joined(separator: ",")))"
                } else {
                    callback([])
                    return
                }
            }
            let set = try db.executeQuery(selectSql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let equipment = try? decoder.decode(UniqueEquipment.self, from: json.rawData()) {
                    equipments.append(equipment)
                }
            }
        }) {
            callback(equipments)
        }
    }
    
    func getCraft(equipmentID: Int, callback: @escaping FMDBCallbackClosure<Craft?>) {
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
                let craftedCost = json["crafted_cost"].intValue
                
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
    
    func getUniqueCraft(equipmentID: Int, callback: @escaping FMDBCallbackClosure<UniqueCraft?>) {
        var result: UniqueCraft?
        execute({ (db) in
            let sql = """
            SELECT
                *
            FROM
                unique_equipment_craft
            WHERE
                equip_id = \(equipmentID)
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                
                let equipmentID = json["equip_id"].intValue
                let craftedCost = json["crafted_cost"].intValue
                
                var consumes = [UniqueCraft.Consume]()
                
                for i in 1...10 {
                    let id = json["item_id_\(i)"].intValue
                    if id == 0 {
                        continue
                    }
                    let consumeNum = json["consume_num_\(i)"].intValue
                    let rewardType = json["reward_type_\(i)"].intValue
                    let consume = UniqueCraft.Consume(itemID: id, consumeNum: consumeNum, rewardType: rewardType)
                    consumes.append(consume)
                }
                
                let craft = UniqueCraft(consumes: consumes, craftedCost: craftedCost, equipmentId: equipmentID)
                result = craft
                break
            }
        }) {
            callback(result)
        }
    }
    
    func getEnhance(equipmentID: Int, callback: @escaping FMDBCallbackClosure<Equipment.Enhance?>) {
        var result: Equipment.Enhance?
        execute({ (db) in
            let sql = """
            SELECT
                a.*,
                b.max_equipment_enhance_level
            FROM
                equipment_enhance_rate a,
                ( SELECT promotion_level, max( equipment_enhance_level ) max_equipment_enhance_level FROM equipment_enhance_data GROUP BY promotion_level ) b
            WHERE
                a.promotion_level = b.promotion_level
                AND a.equipment_id = \(equipmentID)
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                if let enhance = try? decoder.decode(Equipment.Enhance.self, from: json.rawData()) {
                    result = enhance
                    break
                }
            }
        }) {
            callback(result)
        }
    }
    
    func getUniqueEnhance(equipmentID: Int, callback: @escaping FMDBCallbackClosure<UniqueEquipment.Enhance?>) {
        var result: UniqueEquipment.Enhance?
        execute({ (db) in
            let sql = """
            SELECT
                a.*,
                b.max_equipment_enhance_level
            FROM
                unique_equipment_enhance_rate a,
                ( SELECT max( enhance_level ) max_equipment_enhance_level FROM unique_equipment_enhance_data) b
            WHERE
                a.equipment_id = \(equipmentID)
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                if let enhance = try? decoder.decode(UniqueEquipment.Enhance.self, from: json.rawData()) {
                    result = enhance
                    break
                }
            }
        }) {
            callback(result)
        }
    }
    
    func getUniqueEquipmentCost(callback: @escaping FMDBCallbackClosure<[Int: Int]>) {
        var cost = [Int: Int]()
        execute({ (db) in
            let selectSql = """
            SELECT
                *
            FROM
                unique_equipment_enhance_data
            """
            
            let set = try db.executeQuery(selectSql, values: nil)
            var totalPoint = 0
            cost[1] = 0
            while set.next() {
                
                let json = JSON(set.resultDictionary ?? [:])
                
                let enhanceLevel = json["enhance_level"].intValue
                let neededPoint = json["needed_point"].intValue
                let neededMana = json["needed_mana"].intValue
                totalPoint += neededMana * neededPoint
                cost[enhanceLevel] = totalPoint                
            }
        }) {
            callback(cost)
        }
    }
    
    func getSkills(skillIDs: [Int], callback: @escaping FMDBCallbackClosure<[Skill]>) {
        var skills = [Skill]()
        execute({ (db) in
            let sql = """
            SELECT
                *
            FROM
                skill_data
            WHERE
                skill_id IN (\(skillIDs.map(String.init).joined(separator: ",")))
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                var actionIDs = [Int]()
                var dependActionIDs = [Int: Int]()
                for i in 1...7 {
                    let field = "action_\(i)"
                    let id = json[field].intValue
                    actionIDs.append(id)
                    
                    let dependActionField = "depend_action_\(i)"
                    let dependID = json[dependActionField].intValue
                    
                    if dependID != 0 && id != 0 {
                        dependActionIDs[id] = dependID
                    }
                    
                }
                
                var actions = [Int: Skill.Action]()
                
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
                    if let base = try? decoder.decode(Skill.Action.Base.self, from: json.rawData()) {
                        let action = Skill.Action(base: base)
                        actions[action.base.actionId] = action
                    }
                }
                
                for action in actions.values {
                    if let id = dependActionIDs[action.base.actionId] {
                        action.dependAction = actions[id]
                    }
                }
                if let base = try? decoder.decode(Skill.Base.self, from: json.rawData()) {
                    let skill = Skill(actions: Array(actions.values).sorted { $0.base.actionId < $1.base.actionId }, base: base)
                    skills.append(skill)
                }
            }
        }) {
            callback(skills)
        }
    }
    
    func getAreas(type: AreaType? = nil, callback: @escaping FMDBCallbackClosure<[Area]>) {
        var areas = [Area]()
        execute({ (db) in
            var sql = """
            SELECT
                *
            FROM
                quest_area_data
            """
            if type != nil {
                switch type! {
                case .normal:
                    sql.append(" WHERE area_id < 12000 and area_id > 11000")
                case .hard:
                    sql.append(" WHERE area_id > 12000 and area_id < 13000")
                case .veryHard:
                    sql.append(" WHERE area_id > 13000 and area_id < 14000")
                case .shrine:
                    sql.append(" WHERE area_id > 18000 and area_id < 19000")
                case .temple:
                    sql.append(" WHERE area_id > 19000 and area_id < 20000")
                case .exploration:
                    sql.append(" WHERE area_id > 21000 and area_id < 22000")
                default:
                    break
                }
            }
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
    
    private func getWaves(from db: FMDatabase, waveIDs: [Int]) throws -> [Wave] {
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
            
            var enemyUnits = [Wave.EnemyUnit]()
            for i in 1...5 {
                let enemyID = json["enemy_id_\(i)"].intValue
                let dropGold = json["drop_gold_\(i)"].intValue
                let dropRewardID = json["drop_reward_id_\(i)"].intValue
                if enemyID != 0 {
                    let enemyUnit = Wave.EnemyUnit(dropGold: dropGold, dropRewardID: dropRewardID, enemyID: enemyID)
                    enemyUnits.append(enemyUnit)
                }
            }
            
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
            
            let id = json["id"].intValue
            let odds = json["odds"].intValue
            let waveGroupID = json["wave_group_id"].intValue
            let base = Wave.Base(units: enemyUnits, id: id, odds: odds, waveGroupId: waveGroupID)
            waves.append(Wave(base: base, drops: drops))
        }
        return waves
    }
    
    func getWaves(waveIDs: [Int], callback: @escaping FMDBCallbackClosure<[Wave]>) {
        var waves = [Wave]()
        execute({ [unowned self] (db) in
            waves = try self.getWaves(from: db, waveIDs: waveIDs)
        }) {
            callback(waves)
        }
    }
    
    func getClanBattles(callback: @escaping FMDBCallbackClosure<[ClanBattle]>) {
        var clanBattles = [ClanBattle]()
        execute({ (db) in
            let sql = """
            SELECT
                *
            FROM
                clan_battle_period
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let period = try? decoder.decode(ClanBattle.Period.self, from: json.rawData()) {
                    let clanBattle = ClanBattle(period: period)
                    clanBattles.append(clanBattle)
                }
            }
        }) {
            callback(clanBattles)
        }
    }
    
    func getClanBattleRounds(clanBattleID: Int, callback: @escaping FMDBCallbackClosure<[ClanBattle.Round]>) {
        var rounds = [ClanBattle.Round]()
        execute({ (db) in
            let sql = """
            SELECT
                *
            FROM
                clan_battle_2_map_data
            WHERE
                clan_battle_id = \(clanBattleID)
            """
            let set = try db.executeQuery(sql, values: nil)
            do {
                while set.next() {
                    let json = JSON(set.resultDictionary ?? [:])
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let round = try decoder.decode(ClanBattle.Round.self, from: json.rawData())
                    rounds.append(round)
                }
            } catch let error {
                print(error)
            }
        }) {
            callback(rounds)
        }
    }
    
    func getClanBattleRoundsSimple(clanBattleID: Int, callback: @escaping FMDBCallbackClosure<[ClanBattle.Round]>) {
           var rounds = [ClanBattle.Round]()
           execute({ (db) in
               let sql = """
               SELECT
                   *
               FROM
                   clan_battle_s_map_data
               WHERE
                   clan_battle_id = \(clanBattleID)
               """
               let set = try db.executeQuery(sql, values: nil)
               do {
                   while set.next() {
                       let json = JSON(set.resultDictionary ?? [:])
                       let decoder = JSONDecoder()
                       decoder.keyDecodingStrategy = .convertFromSnakeCase
                       let round = try decoder.decode(ClanBattle.Round.self, from: json.rawData())
                       rounds.append(round)
                   }
               } catch let error {
                   print(error)
               }
           }) {
               callback(rounds)
           }
       }
    
    func getTowers(callback: @escaping FMDBCallbackClosure<[Tower]>) {
        var towers = [Tower]()
        execute({ (db) in
            let sql = """
            SELECT
                *
            FROM
                tower_area_data a,
                tower_schedule b,
                tower_story_data c
            WHERE
                a.tower_area_id = b.max_tower_area_id
            AND b.opening_story_id / 1000 = c.story_group_id
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let tower = try decoder.decode(Tower.self, from: json.rawData())
                    towers.append(tower)
                } catch {
                    print(error)
                }
            }
        }) {
            callback(towers)
        }
    }
    
    func getTowerCloisterWaves(waveIDs: [Int], callback: @escaping FMDBCallbackClosure<[TowerCloister.Wave]>) {
        var waves = [TowerCloister.Wave]()
        execute({ (db) in
            let sql = """
            SELECT
                *
            FROM
                tower_wave_group_data
            WHERE
                wave_group_id in (\(waveIDs.map(String.init).joined(separator: ",")))
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let quest = try decoder.decode(TowerCloister.Wave.self, from: json.rawData())
                    waves.append(quest)
                } catch let error {
                    print(error)
                }
            }
        }) {
            callback(waves)
        }
    }
    func getTowerQuests(towerID: Int, callback: @escaping FMDBCallbackClosure<[Tower.Quest]>) {
        var quests = [Tower.Quest]()
        execute({ (db) in
            let sql = """
            SELECT
                *
            FROM
                tower_quest_data a,
                tower_wave_group_data b
            WHERE
                tower_area_id = \(towerID)
                AND a.wave_group_id = b.wave_group_id
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let quest = try decoder.decode(Tower.Quest.self, from: json.rawData())
                    quests.append(quest)
                } catch let error {
                    print(error)
                }
            }
        }) {
            callback(quests)
        }
    }
    
    func getTowerExQuests(towerID: Int, callback: @escaping FMDBCallbackClosure<[Tower.Quest]>) {
        var quests = [Tower.Quest]()
        execute({ (db) in
            let sql = """
            SELECT
                *
            FROM
                tower_ex_quest_data a,
                tower_wave_group_data b
            WHERE
                tower_area_id = \(towerID)
                AND a.wave_group_id = b.wave_group_id
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let quest = try decoder.decode(Tower.Quest.self, from: json.rawData())
                    quests.append(quest)
                } catch let error {
                    print(error)
                }
            }
        }) {
            callback(quests)
        }
    }
    
    func getHatsuneEvents(callback: @escaping FMDBCallbackClosure<[HatsuneEvent]>) {
        var events = [HatsuneEvent]()
        execute({ (db) in
            let sql = """
            SELECT
                a.*,
                b.title
            FROM
                hatsune_schedule a,
                event_story_data b
            WHERE
                a.event_id = b.value
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let base = try decoder.decode(HatsuneEvent.Base.self, from: json.rawData())
                let event = HatsuneEvent(base: base)
                events.append(event)
            }
        }) {
            callback(events)
        }
    }
    
    func getHatsuneEventQuests(eventID: Int, callback: @escaping FMDBCallbackClosure<[HatsuneEventQuest]>) {
        var quests = [HatsuneEventQuest]()
        execute({ (db) in
            let sql = """
            SELECT
                a.*
            FROM
                hatsune_boss a
            WHERE
                event_id = \(eventID)
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let quest = try decoder.decode(HatsuneEventQuest.self, from: json.rawData())
                quests.append(quest)
            }
        }) {
            callback(quests)
        }
    }
    
    func getHatsuneEventSpecialBattles(eventID: Int, callback: @escaping FMDBCallbackClosure<[HatsuneEventSpecialBattle]>) {
        var quests = [HatsuneEventSpecialBattle]()
        execute({ (db) in
            let sql = """
            SELECT
                a.*
            FROM
                hatsune_special_battle a
            WHERE
                event_id = \(eventID)
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let quest = try decoder.decode(HatsuneEventSpecialBattle.self, from: json.rawData())
                quests.append(quest)
            }
        }) {
            callback(quests)
        }
    }
    
    func getShioriEvents(callback: @escaping FMDBCallbackClosure<[ShioriEvent]>) {
        var events = [ShioriEvent]()
        execute({ (db) in
            let sql = """
               SELECT
                   a.*,
                   b.title
               FROM
                   shiori_event_list a,
                   event_story_data b
               WHERE
                   a.event_id = b.value
               """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let base = try decoder.decode(ShioriEvent.Base.self, from: json.rawData())
                let event = ShioriEvent(base: base)
                events.append(event)
            }
        }) {
            callback(events)
        }
    }
    
    func getShioriEventBossQuests(eventID: Int, callback: @escaping FMDBCallbackClosure<[ShioriEventBossQuest]>) {
        var quests = [ShioriEventBossQuest]()
        execute({ (db) in
            let sql = """
            SELECT
            a.*
            FROM
            shiori_boss a
            WHERE
            event_id = \(eventID)
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let quest = try decoder.decode(ShioriEventBossQuest.self, from: json.rawData())
                quests.append(quest)
            }
        }) {
            callback(quests)
        }
    }
    
    func getRaidEnemies(enemyID: Int? = nil, callback: @escaping FMDBCallbackClosure<[Enemy]>) {
        var enemies = [Enemy]()
        execute({ (db) in
            var sql = """
            SELECT
                a.sekai_enemy_id enemy_id,
                a.*,
                b.union_burst,
                b.main_skill_1,
                b.main_skill_2,
                b.main_skill_3,
                b.main_skill_4,
                b.main_skill_5,
                b.main_skill_6,
                b.main_skill_7,
                b.main_skill_8,
                b.main_skill_9,
                b.main_skill_10,
                b.ex_skill_1,
                b.ex_skill_2,
                b.ex_skill_3,
                b.ex_skill_4,
                b.ex_skill_5,
                c.child_enemy_parameter_1,
                c.child_enemy_parameter_2,
                c.child_enemy_parameter_3,
                c.child_enemy_parameter_4,
                c.child_enemy_parameter_5
            FROM
                unit_skill_data b,
                sekai_enemy_parameter a
                LEFT JOIN enemy_m_parts c
                ON a.enemy_id = c.enemy_id
            WHERE
                a.unit_id = b.unit_id
            """
            if let id = enemyID {
                sql.append(" AND a.enemy_id = \(id)")
            }
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let unitID = json["unit_id"].intValue
                let unitSql = """
                SELECT
                    *
                FROM
                    unit_enemy_data
                WHERE
                    unit_id = \(unitID)
                """
                var unit: Enemy.Unit?
                let unitSet = try db.executeQuery(unitSql, values: nil)
                while unitSet.next() {
                    let json = JSON(unitSet.resultDictionary ?? [:])
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    unit = try? decoder.decode(Enemy.Unit.self, from: json.rawData())
                }
                
                var newJson = json
                newJson["hp"].intValue = json["hp"].intValue
                
                if let base = try? decoder.decode(Enemy.Base.self, from: newJson.rawData()),
                    let unit = unit {
                    enemies.append(Enemy(base: base, unit: unit))
                }
            }
        }) {
            callback(enemies)
        }
    }
    
    func getDungeons(callback: @escaping FMDBCallbackClosure<[Dungeon]>) {
        var dungeons = [Dungeon]()
        execute({ (db) in
            let sql = """
            SELECT
                dungeon_area_id,
                wave_group_id,
                dungeon_name
            FROM
                dungeon_area_data
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let dungeon = try decoder.decode(Dungeon.self, from: json.rawData())
                dungeons.append(dungeon)
            }
        }) {
            callback(dungeons)
        }
    }
    
    func getEnemies(enemyID: Int? = nil, isBossPart: Bool = false, callback: @escaping FMDBCallbackClosure<[Enemy]>) {
        var enemies = [Enemy]()
        execute({ (db) in
            var sql = """
            SELECT
                a.*,
                b.union_burst,
                b.union_burst_evolution,
                b.main_skill_1,
                b.main_skill_evolution_1,
                b.main_skill_2,
                b.main_skill_evolution_2,
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
                b.sp_skill_5,
                c.child_enemy_parameter_1,
                c.child_enemy_parameter_2,
                c.child_enemy_parameter_3,
                c.child_enemy_parameter_4,
                c.child_enemy_parameter_5
            FROM
                unit_skill_data b,
                enemy_parameter a
                LEFT JOIN enemy_m_parts c
                ON a.enemy_id = c.enemy_id
            WHERE
                a.unit_id = b.unit_id
            """
            if let id = enemyID {
                sql.append(" AND a.enemy_id = \(id)")
            }
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let unitID = json["unit_id"].intValue
                let unitSql = """
                SELECT
                    *
                FROM
                    unit_enemy_data
                WHERE
                    unit_id = \(unitID)
                """
                var unit: Enemy.Unit?
                let unitSet = try db.executeQuery(unitSql, values: nil)
                while unitSet.next() {
                    let json = JSON(unitSet.resultDictionary ?? [:])
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    unit = try? decoder.decode(Enemy.Unit.self, from: json.rawData())
                }
                
                if let base = try? decoder.decode(Enemy.Base.self, from: json.rawData()),
                    let unit = unit {
                    enemies.append(Enemy(base: base, unit: unit, isBossPart: isBossPart))
                }
            }
        }) {
            callback(enemies)
        }
    }
    
    func getTowerEnemies(enemyID: Int? = nil, callback: @escaping FMDBCallbackClosure<[Enemy]>) {
        var enemies = [Enemy]()
        execute({ (db) in
            var sql = """
            SELECT
                a.*,
                b.union_burst,
                b.main_skill_1,
                b.main_skill_2,
                b.main_skill_3,
                b.main_skill_4,
                b.main_skill_5,
                b.main_skill_6,
                b.main_skill_7,
                b.main_skill_8,
                b.main_skill_9,
                b.main_skill_10,
                b.ex_skill_1,
                b.ex_skill_2,
                b.ex_skill_3,
                b.ex_skill_4,
                b.ex_skill_5,
                b.union_burst_evolution,
                b.main_skill_evolution_1,
                b.main_skill_evolution_2,
                b.ex_skill_evolution_1,
                b.ex_skill_evolution_2,
                b.ex_skill_evolution_3,
                b.ex_skill_evolution_4,
                b.ex_skill_evolution_5,
                c.child_enemy_parameter_1,
                c.child_enemy_parameter_2,
                c.child_enemy_parameter_3,
                c.child_enemy_parameter_4,
                c.child_enemy_parameter_5
            FROM
                unit_skill_data b,
                tower_enemy_parameter a
                LEFT JOIN enemy_m_parts c
                ON a.enemy_id = c.enemy_id
            WHERE
                a.unit_id = b.unit_id
            """
            if let id = enemyID {
                sql.append(" AND a.enemy_id = \(id)")
            }
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let unitID = json["unit_id"].intValue
                let unitSql = """
                SELECT
                    *
                FROM
                    unit_enemy_data
                WHERE
                    unit_id = \(unitID)
                """
                do {
                    var unit: Enemy.Unit?
                    let unitSet = try db.executeQuery(unitSql, values: nil)
                    while unitSet.next() {
                        let json = JSON(unitSet.resultDictionary ?? [:])
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        unit = try decoder.decode(Enemy.Unit.self, from: json.rawData())
                    }
                    
                    let base = try decoder.decode(Enemy.Base.self, from: json.rawData())
                    if let unit = unit {
                        enemies.append(Enemy(base: base, unit: unit))
                    }
                } catch {
                    print(error)
                }
            }
        }) {
            callback(enemies)
        }
    }
    
    func getQuests(areaID: Int? = nil, containsEquipment equipmentID: Int? = nil, callback: @escaping FMDBCallbackClosure<[Quest]>) {
        var quests = [Quest]()
        execute({ [unowned self] (db) in
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
                let waves = try self.getWaves(from: db, waveIDs: waveIDs)
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
    
    func getTowerCloisterQuests(id: Int?, callback: @escaping FMDBCallbackClosure<[TowerCloister]>) {
        var quests = [TowerCloister]()
        execute({ (db) in
            var sql = """
            SELECT
                *
            FROM
                tower_cloister_quest_data
            """
            if let id = id {
                sql.append(" WHERE tower_cloister_quest_id = \(id)")
            }
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let base = try decoder.decode(TowerCloister.Base.self, from: json.rawData())
                let quest = TowerCloister(base: base)
                quests.append(quest)
            }
        }) {
            callback(quests)
        }
    }
    
    func getRarity6UnlockQuest(callback: @escaping FMDBCallbackClosure<[Rarity6UnlockQuest]>) {
        var quests = [Rarity6UnlockQuest]()
        execute({ (db) in
            let sql = """
            SELECT
                *
            FROM
                rarity_6_quest_data
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let quest = try decoder.decode(Rarity6UnlockQuest.self, from: json.rawData())
                    quests.append(quest)
                } catch {
                    print(error)
                }
            }
        }) {
            callback(quests)
        }
    }
    
    func getTrainingQuests(areaID: Int? = nil, callback: @escaping FMDBCallbackClosure<[Quest]>) {
        var quests = [Quest]()
        execute({ [unowned self] (db) in
            var sql = """
            SELECT
                *
            FROM
                training_quest_data
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
                let waves = try self.getWaves(from: db, waveIDs: waveIDs)
                do {
                    let base = try decoder.decode(Quest.Base.self, from: json.rawData())
                    let quest = Quest(base: base, waves: waves)
                    quests.append(quest)
                } catch let error {
                    print(error)
                }
            }
        }) {
            callback(quests)
        }
    }
    
    func getMaxLevel(callback: @escaping FMDBCallbackClosure<Int?>) {
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
    
    func getMaxRank(callback: @escaping FMDBCallbackClosure<Int?>) {
        var result: Int?
        execute({ (db) in
            let sql = """
            SELECT
                max(promotion_level) max_promotion_level
            FROM
                unit_promotion
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                result = Int(set.int(forColumn: "max_promotion_level"))
            }
        }) {
            callback(result)
        }
    }
    
    func getMaxUniqueEquipmentLevel(callback: @escaping FMDBCallbackClosure<Int?>) {
        var result: Int?
        execute({ (db) in
            let sql = """
            SELECT
                max(enhance_level) max_level
            FROM
                unique_equipment_enhance_data
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                result = Int(set.int(forColumn: "max_level"))
            }
        }) {
            callback(result)
        }
    }
    
    func getMaxEnemyLevel(callback: @escaping FMDBCallbackClosure<Int?>) {
        var result: Int?
        execute({ (db) in
            let sql = """
            SELECT
                max(level) max_enemy_level
            FROM
                enemy_parameter
            """
            let set = try db.executeQuery(sql, values: nil)
            while set.next() {
                result = Int(set.int(forColumn: "max_enemy_level"))
            }
        }) {
            callback(result)
        }
    }
    
    func getCoefficient(callback: @escaping FMDBCallbackClosure<Coefficient?>) {
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

    func getCharaStory(charaID: Int, callback: @escaping FMDBCallbackClosure<[CharaStory]>) {
        var results = [CharaStory]()
        execute({ (db) in
            let selectSql = """
            SELECT
                a.*,
                b.love_level
            FROM
                chara_story_status a,
                story_detail b
            WHERE
            (
                chara_id_1 = \(charaID)
                OR chara_id_2 = \(charaID)
                OR chara_id_3 = \(charaID)
                OR chara_id_4 = \(charaID)
                OR chara_id_5 = \(charaID)
                OR chara_id_6 = \(charaID)
                OR chara_id_7 = \(charaID)
                OR chara_id_8 = \(charaID)
                OR chara_id_9 = \(charaID)
                OR chara_id_10 = \(charaID)
            )
            AND
                a.story_id = b.story_id
            """
            
            let set = try db.executeQuery(selectSql, values: nil)
            while set.next() {
                
                let json = JSON(set.resultDictionary ?? [:])
                
                let storyID = json["story_id"].intValue
                let loveLevel = json["love_level"].intValue
                
                var statuses = [CharaStory.Status]()
                for i in 1...5 {
                    let rate = json["status_rate_\(i)"].intValue
                    let type = json["status_type_\(i)"].intValue
                    if type != 0 {
                        statuses.append(CharaStory.Status(type: type, rate: rate))
                    }
                }
                
                results.append(CharaStory(storyID: storyID, charaID: charaID, loveLevel: loveLevel, status: statuses))
            }
        }) {
            callback(results)
        }
    }
    
    func getResistData(resistID: Int, callback: @escaping FMDBCallbackClosure<Resist?>) {
        var result: Resist?
        let ailments = DispatchSemaphore.sync { (closure) in
            getAilments(callback: closure)
        } ?? []
        execute({ (db) in
            let selectSql = """
            SELECT
                *
            FROM
                resist_data
            WHERE
                resist_status_id = \(resistID)
            """
            
            let set = try db.executeQuery(selectSql, values: nil)
            while set.next() {
                
                let json = JSON(set.resultDictionary ?? [:])
                
                var items = [Resist.Item]()
                for i in 0..<ailments.count {
                    let rate = json["ailment_\(i + 1)"].intValue
                    let ailment = ailments[i]
                    let item = Resist.Item(ailment: ailment, rate: rate)
                    items.append(item)
                }
                
                result = Resist(items: items)
            }
        }) {
            callback(result)
        }
    }
    
    func getAilments(ailmentID: Int? = nil, callback: @escaping FMDBCallbackClosure<[Ailment]>) {
        var ailments = [Ailment]()
        execute({ (db) in
            var selectSql = """
            SELECT
                *
            FROM
                ailment_data
            """
            if let id = ailmentID {
                selectSql.append(" WHERE ailment_id = \(id)")
            }
            
            let set = try db.executeQuery(selectSql, values: nil)
            while set.next() {
                
                let json = JSON(set.resultDictionary ?? [:])
                let type = json["ailment_action"].intValue
                let detail = json["ailment_detail_1"].intValue
                
                let ailment = Ailment(type: type, detail: detail)
                ailments.append(ailment)
            }
        }) {
            callback(ailments)
        }
    }
    
    func getSkillCost(callback: @escaping FMDBCallbackClosure<[Int: Int]>) {
        var skillCost = [Int: Int]()
        execute({ (db) in
            let selectSql = """
            SELECT
                *
            FROM
                skill_cost
            """
            
            let set = try db.executeQuery(selectSql, values: nil)
            while set.next() {
                
                let json = JSON(set.resultDictionary ?? [:])
                
                let targetLevel = json["target_level"].intValue
                let cost = json["cost"].intValue
                
                skillCost[targetLevel] = cost
                
            }
        }) {
            callback(skillCost)
        }
    }
    
    func getUnitExperience(callback: @escaping FMDBCallbackClosure<[Int: Int]>) {
        var unitExperience = [Int: Int]()
        execute({ (db) in
            let selectSql = """
            SELECT
                *
            FROM
                experience_unit
            """
            
            let set = try db.executeQuery(selectSql, values: nil)
            while set.next() {
                
                let json = JSON(set.resultDictionary ?? [:])
                
                let unitLevel = json["unit_level"].intValue
                let totalExp = json["total_exp"].intValue
                
                unitExperience[unitLevel] = totalExp
                
            }
        }) {
            callback(unitExperience)
        }
    }
    
    func getGameEvents(callback: @escaping FMDBCallbackClosure<[GameEvent]>) {
        var events = [GameEvent]()
        execute({ (db) in
            let campaignSql = """
            SELECT
                *
            FROM
                campaign_schedule a
            """
            
            var set = try db.executeQuery(campaignSql, values: nil)
            while set.next() {
                
                let json = JSON(set.resultDictionary ?? [:])
                let startDate = json["start_time"].stringValue.toDate(format: "yyyy/MM/dd HH:mm:ss")
                let endDate = json["end_time"].stringValue.toDate(format: "yyyy/MM/dd HH:mm:ss")
                let category = json["campaign_category"].intValue
                let value = json["value"].doubleValue
                let campaign = CampaignEvent(startDate: startDate, endDate: endDate, category: category, value: value)
                events.append(campaign)
            }
            
            let storyEventSql = """
            SELECT
                a.*,
                b.title
            FROM
                hatsune_schedule a,
                event_story_data b
            WHERE
                a.event_id = b.value
            """
            
            set = try db.executeQuery(storyEventSql, values: nil)
            while set.next() {
                
                let json = JSON(set.resultDictionary ?? [:])
                let startDate = json["start_time"].stringValue.toDate(format: "yyyy/MM/dd HH:mm:ss")
                let endDate = json["end_time"].stringValue.toDate(format: "yyyy/MM/dd HH:mm:ss")
                let name = json["title"].stringValue
                let story = StoryEvent(startDate: startDate, endDate: endDate, name: name, type: .story)
                events.append(story)
            }
            
            let clanBattleEventSql = """
            SELECT
                *
            FROM
                clan_battle_period a
            """
            
            set = try db.executeQuery(clanBattleEventSql, values: nil)
            while set.next() {
                
                let json = JSON(set.resultDictionary ?? [:])
                let startDate = json["start_time"].stringValue.toDate(format: "yyyy/MM/dd HH:mm:ss")
                let endDate = json["end_time"].stringValue.toDate(format: "yyyy/MM/dd HH:mm:ss")
                let clanBattle = ClanBattleEvent(startDate: startDate, endDate: endDate, name: "", type: .clanBattle)
                events.append(clanBattle)
            }
            
            let gachaSql = """
            SELECT
                *
            FROM
                gacha_data a
            """
            
            set = try db.executeQuery(gachaSql, values: nil)
            while set.next() {
                
                let json = JSON(set.resultDictionary ?? [:])
                let id = json["gacha_id"].stringValue
                let startDate = json["start_time"].stringValue.toDate(format: "yyyy/MM/dd HH:mm:ss")
                let endDate = json["end_time"].stringValue.toDate(format: "yyyy/MM/dd HH:mm:ss")
                let name = json["description"].stringValue.replacingOccurrences(of: "\\n", with: " ")
                let gacha = GachaEvent(startDate: startDate, endDate: endDate, name: name, type: .gacha)
                
                // ignore the gacha has a very long duration
                if gacha.endDate.timeIntervalSinceNow > 60 * 60 * 24 * 30 {
                    continue
                }
                
                // ignore normal gacha
                if id.starts(with: "1") || id.starts(with: "2") {
                    continue
                }
                
                events.append(gacha)
            }
            
            let towerSql = """
            SELECT
                b.*,
                c.title
            FROM
                tower_schedule b,
                tower_story_data c
            WHERE
                b.opening_story_id / 1000 = c.story_group_id
            """
            
            set = try db.executeQuery(towerSql, values: nil)
            while set.next() {
                
                let json = JSON(set.resultDictionary ?? [:])
                let startDate = json["start_time"].stringValue.toDate(format: "yyyy/MM/dd HH:mm:ss")
                let endDate = json["end_time"].stringValue.toDate(format: "yyyy/MM/dd HH:mm:ss")
                let name = json["title"].stringValue
                let tower = TowerEvent(startDate: startDate, endDate: endDate, name: name, type: .tower)
                events.append(tower)
            }
            
        }) {
            callback(events)
        }
    }
    
}
