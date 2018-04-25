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
    
    static let shared = Master(path: Bundle.main.path(forResource: "master", ofType: "db"))
    
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
                    if let promotion = try? decoder.decode(Card.Promotion.self, from: json.rawData()) {
                        promotions.append(promotion)
                    }
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
    
    func getEquipments(callback: @escaping FMDBCallBackClosure<[Int: Equipment]>) {
        var dict = [Int: Equipment]()
        execute({ (db) in
            let selectSql = """
            SELECT
                *
            FROM
                equipment_data
            """
            let set = try db.executeQuery(selectSql, values: nil)
            while set.next() {
                let json = JSON(set.resultDictionary ?? [:])
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let equipment = try? decoder.decode(Equipment.self, from: json.rawData()) {
                    dict[equipment.equipmentId] = equipment
                    
                }
            }
        }) {
            callback(dict)
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
                }
            }
        }) {
            callback(result)
        }
    }
    
}
