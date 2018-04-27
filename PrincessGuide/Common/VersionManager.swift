//
//  VersionManager.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class VersionManager {

    static let shared = VersionManager()
    
    var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    var truthVersion: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "truth_version")
        }
        get {
            return UserDefaults.standard.value(forKey: "truth_version") as? String ?? ""
        }
    }
    
    var hash: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "master_hash")
        }
        get {
            return UserDefaults.standard.value(forKey: "master_hash") as? String ?? ""
        }
    }
    
}
