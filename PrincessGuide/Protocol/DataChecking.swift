//
//  DataChecking.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/27.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import MJRefresh

protocol DataChecking {
    var refresher: RefreshHeader { get }
    func check()
}

extension DataChecking where Self: UIViewController {
    
    func check() {
        let updater = Updater.shared
        defer {
            refresher.endRefreshing()
        }
        if updater.isUpdating { return }
        
        let hudManager = UpdatingHUDManager.shared
        hudManager.show()
        hudManager.setup(NSLocalizedString("Checking", comment: ""), animated: true)
     
        updater.checkTruthVersion { (truthVersion, hash, error) in
            hudManager.hide(animated: true)
            if let version = truthVersion, let hash = hash, VersionManager.shared.truthVersion < version || !Master.checkDatabaseFile() {
                DispatchQueue.main.async {
                    hudManager.show()                    
                }
                updater.getMaster(hash: hash, progressHandler: { (progress) in
                    DispatchQueue.main.async {
                        hudManager.setup("\(Int(progress.fractionCompleted * 100))%", animated: true)
                    }
                }, completion: { (data, error) in
                    if data != nil {
                        VersionManager.shared.hash = hash
                        VersionManager.shared.truthVersion = version
                    }
                    DispatchQueue.main.async {
                        hudManager.setup(NSLocalizedString("Finished", comment: ""), animated: false)
                        hudManager.hide(animated: true)
                    }
                })
            }
        }
    }
    
}
