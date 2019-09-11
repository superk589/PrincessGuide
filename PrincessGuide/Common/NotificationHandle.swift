//
//  NotificationHandle.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    
    static let `default` = NotificationHandler()
    
    private override init() {
        super.init()
        // self.registerNotificationCategory()
    }
    
    struct UserNotificationCategoryType {
        static let birthday = "birthday_category"
    }
    
    struct BirthdayActionType {
        static let happy = "action.happy_birthday"
        static let cancel = "action.cancel"
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .alert])
        
        // completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // let category = response.notification.request.content.categoryIdentifier
        let action = response.actionIdentifier
        if action == UNNotificationDismissActionIdentifier {
            // dismissed, do nothing
        } else if action == BirthdayActionType.happy || action == BirthdayActionType.cancel {
            // handleBirthdayAction(response: response)
        } else if action == UNNotificationDefaultActionIdentifier {
            openSpecificPageBy(response: response)
        }
        completionHandler()
    }
    
    private func openSpecificPageBy(response: UNNotificationResponse) {
        let userInfo = response.notification.request.content.userInfo
        if let cardID = userInfo["card_id"] as? Int {
            if let card = Card.findByID(cardID),
                let nvc = (UIApplication.shared.currentWindow?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
                let vc = CDTabViewController(card: card)
                vc.hidesBottomBarWhenPushed = true
                nvc.pushViewController(vc, animated: false)
                nvc.navigationBar.setNeedsLayout()
            }
        }
    }
    
//    private func handleBirthdayAction(response: UNNotificationResponse) {
//        let actionType = response.actionIdentifier
//        if actionType == BirthdayActionType.happy {
//            let charName = response.notification.request.content.userInfo["charName"]! as! String
//            let reply = NSLocalizedString("%@ receives your blessing.", comment: "")
//            let message = String.init(format: reply, charName)
//
//            openSpecificPageBy(response: response)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//                UIAlertController.showConfirmAlertFromTopViewController(message: message)
//            })
//
//        } else if actionType == BirthdayActionType.cancel {
//            // do nothing
//        }
//    }
    
//    private func registerNotificationCategory() {
//        let birthdayCategory: UNNotificationCategory = {
//
//            let happyBirthdayAction = UNNotificationAction(
//                identifier: BirthdayActionType.happy,
//                title: NSLocalizedString("Happy Birthday!!", comment: ""),
//                options: [.foreground])
//
//            let cancelAction = UNNotificationAction(
//                identifier: BirthdayActionType.cancel,
//                title: NSLocalizedString("Cancel", comment: ""),
//                options: [.destructive])
//
//            return UNNotificationCategory(identifier: UserNotificationCategoryType.birthday, actions: [happyBirthdayAction, cancelAction], intentIdentifiers: [], options: [.customDismissAction])
//        }()
//
//        UNUserNotificationCenter.current().setNotificationCategories([birthdayCategory])
//    }
    
}

