//
//  Card+Talent.swift
//  PrincessGuide
//
//  Created by zzk on 2024/3/11.
//  Copyright © 2024 zzk. All rights reserved.
//

import UIKit

enum CardTalent: Int, Codable, CustomStringConvertible, CaseIterable {
    case fire = 1
    case water
    case wind
    case light
    case dark
    
    var description: String {
        switch self {
        case .fire:
            return NSLocalizedString("Fire", comment: "")
        case .water:
            return NSLocalizedString("Water", comment: "")
        case .wind:
            return NSLocalizedString("Wind", comment: "")
        case .light:
            return NSLocalizedString("Light", comment: "")
        case .dark:
            return NSLocalizedString("Dark", comment: "")
        }
    }
    
    var image: UIImage? {
        switch self {
        case .fire:
            return UIImage(named: "fire")
        case .water:
            return UIImage(named: "water")
        case .wind:
            return UIImage(named: "wind")
        case .light:
            return UIImage(named: "light")
        case .dark:
            return UIImage(named: "dark")
        }
        return nil
    }
}
