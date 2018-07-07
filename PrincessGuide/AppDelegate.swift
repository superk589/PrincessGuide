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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootTabBarController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController") as! UITabBarController
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootTabBarController
        window?.makeKeyAndVisible()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { themeable, theme in
            let tabBar = rootTabBarController.tabBar
            tabBar.tintColor = theme.color.tint
            tabBar.barStyle = theme.barStyle
            themeable.window?.backgroundColor = theme.color.background
        }
        
        ThemeManager.default.theme = Defaults.prefersDarkTheme ? Theme.dark : Theme.light
        
        KingfisherManager.shared.defaultOptions = [.processor(WebPProcessor.default), .cacheSerializer(WebPSerializer.default)]

        // set Kingfisher cache never expiring
        ImageCache.default.maxCachePeriodInSecond = -1
        
        VersionManager.shared.executeDocumentReset { (lastVersion) in
            do {
                if lastVersion < 2 {
                    try FileManager.default.removeItem(at: ConsoleVariables.url)
                }
            } catch (let error) {
                print(error)
            }
        }
        
        UNUserNotificationCenter.current().delegate = NotificationHandler.default
        
        if BirthdayViewController.Setting.default.schedulesBirthdayNotifications {
            BirthdayCenter.default.scheduleNotifications()
        }
        
        return true
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        Card.removeCache()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if BirthdayViewController.Setting.default.schedulesBirthdayNotifications {
            BirthdayCenter.default.scheduleNotifications()
        }
    }
}
