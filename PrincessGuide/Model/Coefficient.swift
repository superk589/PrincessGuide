//
//  Coefficient.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/20.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

struct Coefficient: Codable {
    
    static let `default`: Coefficient = {
        
        let json = """
        {
            "coefficient_id": 1,
            "hp_coefficient": 0.1,
            "atk_coefficient": 1.0,
            "magic_str_coefficient": 1.0,
            "def_coefficient": 4.5,
            "magic_def_coefficient": 4.5,
            "physical_critical_coefficient": 0.5,
            "magic_critical_coefficient": 0.5,
            "wave_hp_recovery_coefficient": 0.1,
            "wave_energy_recovery_coefficient": 0.3,
            "dodge_coefficient": 6.0,
            "physical_penetrate_coefficient": 6.0,
            "magic_penetrate_coefficient": 6.0,
            "life_steal_coefficient": 4.5,
            "hp_recovery_rate_coefficient": 1.0,
            "energy_recovery_rate_coefficient": 1.5,
            "energy_reduce_rate_coefficient": 3.0,
            "skill_lv_coefficient": 10.0,
            "exskill_evolution_coefficient": 15,
            "overall_coefficient": 1.0
        }
        """
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let result = try! decoder.decode(Coefficient.self, from: json.data(using: .utf8)!)
        return result
    }()
    
    let atkCoefficient: Double
    let coefficientId: Int
    let defCoefficient: Double
    let dodgeCoefficient: Double
    let energyRecoveryRateCoefficient: Double
    let energyReduceRateCoefficient: Double
    let exskillEvolutionCoefficient: Double
    let hpCoefficient: Double
    let hpRecoveryRateCoefficient: Double
    let lifeStealCoefficient: Double
    let magicCriticalCoefficient: Double
    let magicDefCoefficient: Double
    let magicPenetrateCoefficient: Double
    let magicStrCoefficient: Double
    let overallCoefficient: Double
    let physicalCriticalCoefficient: Double
    let physicalPenetrateCoefficient: Double
    let skillLvCoefficient: Double
    let waveEnergyRecoveryCoefficient: Double
    let waveHpRecoveryCoefficient: Double

}
