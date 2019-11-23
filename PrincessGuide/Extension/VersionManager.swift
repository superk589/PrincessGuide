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
    
    var buildNumber: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
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
    
    func executeDocumentReset(_ reset: (Int) -> Void) {
        guard let documentVersion = Bundle.main.infoDictionary?["Document version"] as? Int else {
            return
        }
        let lastVersion = UserDefaults.standard.value(forKey: "last_document_version") as? Int ?? 0
        if documentVersion > lastVersion {
            reset(lastVersion)
        }
        UserDefaults.standard.set(documentVersion, forKey: "last_document_version")
    }
    
    var noticeVersion: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "notice_version")
        }
        get {
            return UserDefaults.standard.value(forKey: "notice_version") as? String ?? ""
        }
    }
}
