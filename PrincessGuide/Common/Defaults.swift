//
//  Defaults.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/27.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

struct Defaults {

    static var downloadAtStart: Bool {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "download_at_start")
        }
        get {
            return UserDefaults.standard.value(forKey: "download_at_start") as? Bool ?? true
        }
    }

}
