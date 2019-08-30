//
//  Preload.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/10.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let preloadEnd = Notification.Name("preload_end")
}

class Preload {
    
    static let `default` = Preload()
    
    var skillCost = [Int: Int]()
    
    var unitExperience = [Int: Int]()
    
    var cards = [Int: Card]()
    
    var maxPlayerLevel = Constant.presetMaxPlayerLevel
    
    var maxEquipmentRank = Constant.presetMaxRank
    
    var coefficient = Coefficient.default
    
    var maxEnemyLevel = Constant.presetMaxEnemyLevel
    
    var maxUniqueEquipmentLevel = Constant.presetMaxUniqueEquipmentLevel
    
    var uniqueEquipmentEnhanceCost = [Int: Int]()
    
    var events = [GameEvent]()
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateEnd(_:)), name: .updateEnd, object: nil)
    }
    
    @objc private func handleUpdateEnd(_ notification: Notification) {
        reload()
    }
    
    func asyncLoad() {
        reload()
    }
    
    func syncLoad() {
        
        skillCost = DispatchSemaphore.sync { (closure) in
            Master.shared.getSkillCost(callback: closure)
        } ?? [:]
        
        uniqueEquipmentEnhanceCost = DispatchSemaphore.sync { (closure) in
            Master.shared.getUniqueEquipmentCost(callback: closure)
        } ?? [:]
        
        unitExperience = DispatchSemaphore.sync { (closure) in
            Master.shared.getUnitExperience(callback: closure)
        } ?? [:]
        
        cards = (DispatchSemaphore.sync { (closure) in
            Master.shared.getCards(callback: closure)
        } ?? []).reduce(into: [Int: Card]()) { $0[$1.base.unitId] = $1 }
        
        maxPlayerLevel = DispatchSemaphore.sync { (closure) in
            Master.shared.getMaxLevel(callback: closure)
        } ?? Constant.presetMaxPlayerLevel
        
        maxEnemyLevel = DispatchSemaphore.sync { (closure) in
            Master.shared.getMaxEnemyLevel(callback: closure)
        } ?? Constant.presetMaxEnemyLevel
        
        coefficient = DispatchSemaphore.sync { (closure) in
            Master.shared.getCoefficient(callback: closure)
        } ?? Coefficient.default
        
        maxEquipmentRank = DispatchSemaphore.sync { (closure) in
            Master.shared.getMaxRank(callback: closure)
        } ?? Constant.presetMaxRank
        
        maxUniqueEquipmentLevel = DispatchSemaphore.sync { (closure) in
            Master.shared.getMaxUniqueEquipmentLevel(callback: closure)
        } ?? Constant.presetMaxUniqueEquipmentLevel
        
        events = DispatchSemaphore.sync { (closure) in
            Master.shared.getGameEvents(callback: closure)
        } ?? []
    }
    
    private func reload() {
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Master.shared.getSkillCost(callback: { (skillCost) in
                self?.skillCost = skillCost
                group.leave()
            })
        }
        
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Master.shared.getUniqueEquipmentCost(callback: { (cost) in
                self?.uniqueEquipmentEnhanceCost = cost
                group.leave()
            })
        }
        
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Master.shared.getUnitExperience(callback: { (unitExperience) in
                self?.unitExperience = unitExperience
                group.leave()
            })
        }
        
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Master.shared.getCards(callback: { (cards) in
                self?.cards = cards.reduce(into: [Int: Card]()) { $0[$1.base.unitId] = $1 }
                group.leave()
            })
        }
        
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Master.shared.getMaxLevel { (maxLevel) in
                self?.maxPlayerLevel = maxLevel ?? Constant.presetMaxPlayerLevel
                group.leave()
            }
        }
        
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Master.shared.getMaxEnemyLevel(callback: { (level) in
                self?.maxEnemyLevel = level ?? Constant.presetMaxEnemyLevel
                group.leave()
            })
        }

        group.enter()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Master.shared.getCoefficient(callback: { (coefficient) in
                self?.coefficient = coefficient ?? Coefficient.default
                group.leave()
            })
        }

        group.enter()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Master.shared.getMaxRank(callback: { (rank) in
                self?.maxEquipmentRank = rank ?? Constant.presetMaxRank
                group.leave()
            })
        }
        
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Master.shared.getMaxUniqueEquipmentLevel(callback: { (level) in
                self?.maxUniqueEquipmentLevel = level ?? Constant.presetMaxUniqueEquipmentLevel
                group.leave()
            })
        }
        
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Master.shared.getGameEvents(callback: { (events) in
                self?.events = events
                group.leave()
            })
        }
        
        group.notify(queue: .main) {
            NotificationCenter.default.post(name: .preloadEnd, object: nil)
        }
        
    }
    
}

