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
import Gestalt
import CoreData
import UserNotifications
import SwiftyStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootTabBarController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController") as! UITabBarController
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootTabBarController
        window?.makeKeyAndVisible()
        
        ThemeManager.default.theme = Defaults.prefersDarkTheme ? Theme.dark : Theme.light
        ThemeManager.default.apply(theme: Theme.self, to: self) { themeable, theme in
            let tabBar = rootTabBarController.tabBar
            tabBar.tintColor = theme.color.tint
            tabBar.barStyle = theme.barStyle
            themeable.window?.backgroundColor = theme.color.background
        }
        
        KingfisherManager.shared.defaultOptions = [.processor(WebPProcessor.default), .cacheSerializer(WebPSerializer.default)]

        // set Kingfisher cache never expiring
        ImageCache.default.maxCachePeriodInSecond = -1
        
        // prepare for preload master data
        Preload.default.syncLoad()
        
        UNUserNotificationCenter.current().delegate = NotificationHandler.default
        
        BirthdayCenter.default.scheduleNotifications()
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    if Constant.iAPProductIDs.contains(purchase.productId) {
                        Defaults.proEdition = true
                        NotificationCenter.default.post(name: .proEditionPurchased, object: nil)
                    }
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
        
        SwiftyStoreKit.shouldAddStorePaymentHandler = { payment, product in
            return true
        }
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        BirthdayCenter.default.scheduleNotifications()
    }
}
