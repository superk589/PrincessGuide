//
//  AppDelegate.swift
//  PrincessGuide
//
//  Created by zzk on 19/03/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Kingfisher
import KingfisherWebP
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootTabBarController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController") as! UITabBarController
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootTabBarController
        window?.makeKeyAndVisible()
        
        let tabBar = rootTabBarController.tabBar
        tabBar.tintColor = Theme.dynamic.color.tint
        window?.backgroundColor = Theme.dynamic.color.background
        UINavigationBar.appearance().tintColor = Theme.dynamic.color.tint
        
        KingfisherManager.shared.defaultOptions = [.processor(WebPProcessor.default), .cacheSerializer(WebPSerializer.default)]

        // set Kingfisher cache never expiring
        ImageCache.default.diskStorage.config.expiration = .never
        
        // prepare for preload master data
        Preload.default.syncLoad()
        
        UNUserNotificationCenter.current().delegate = NotificationHandler.default
        
        BirthdayCenter.default.initialize()
        BirthdayCenter.default.rescheduleNotifications()
        
        GameEventCenter.default.initialize()
        
        checkNotice()
//        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
//            for purchase in purchases {
//                switch purchase.transaction.transactionState {
//                case .purchased, .restored:
//                    if purchase.needsFinishTransaction {
//                        // Deliver content from server, then:
//                        SwiftyStoreKit.finishTransaction(purchase.transaction)
//                    }
//                    if Constant.iAPProductIDs.contains(purchase.productId) {
//                        Defaults.proEdition = true
//                        NotificationCenter.default.post(name: .proEditionPurchased, object: nil)
//                    }
//                case .failed, .purchasing, .deferred:
//                    break // do nothing
//                }
//            }
//        }
//
//        SwiftyStoreKit.shouldAddStorePaymentHandler = { payment, product in
//            return true
//        }
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        checkNotice()
        BirthdayCenter.default.rescheduleNotifications()
    }
    
    func checkNotice(ignoresExpireDate: Bool = false) {
        Updater.shared.getNotice { [weak self] (payload) in
            if let payload = payload, VersionManager.shared.noticeVersion < payload.version {
                VersionManager.shared.noticeVersion = payload.version
                self?.showNotice(payload: payload, ignoresExpireDate: ignoresExpireDate)
            }
        }
    }
    
    func showNotice(payload: NoticePayload, ignoresExpireDate: Bool = false) {
        if payload.expireDate > Date().toString(format: "yyyy/MM/dd HH:mm:ss", timeZone: .current) || ignoresExpireDate {
            let alert = UIAlertController(title: payload.localizedTitle, message: payload.localizedContent, preferredStyle: .alert)
            let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(action)
            window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
}
