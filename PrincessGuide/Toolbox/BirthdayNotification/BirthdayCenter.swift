//
//  BirthdayCenter.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import UserNotifications
import Kingfisher
import KingfisherWebP
import Klendario
import EventKit

fileprivate typealias Setting = BirthdayViewController.Setting

extension Card {
    
    var nextBirthday: Date? {
        
        let timeZone = Setting.default.timeZone
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = timeZone
        
        let now = Date()
        
        if let birthDay = Int(profile.birthDay),
            let birthMonth = Int(profile.birthMonth) {
            var dateComponent = gregorian.dateComponents([Calendar.Component.year, .month, .day], from: now)
            if (birthMonth, birthDay) < (dateComponent.month!, dateComponent.day!) {
                dateComponent.year = dateComponent.year! + 1
            }
            dateComponent.month = birthMonth
            dateComponent.day = birthDay
            return gregorian.date(from: dateComponent)
        } else {
            return nil
        }
        
    }
    
    var nextBirthdayComponents: DateComponents? {
        if let date = nextBirthday {
            var gregorian =  Calendar(identifier: .gregorian)
            gregorian.timeZone = TimeZone.current
            return gregorian.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        } else {
            return nil
        }
    }
    
}

class BirthdayCenter {
    
    static let `default` = BirthdayCenter()
    
    var cards = [Card]()
    
    var lastReloadDate = Date()
    
    private init() {

    }
    
    func initialize() {
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .preloadEnd, object: nil)
    }
    
    func loadData() {
        let cards = Preload.default.cards.values
        
        let sortedCards = cards.filter { $0.nextBirthday != nil }.sorted { $0.profile.unitId > $1.profile.unitId }
        for card in sortedCards {
            if !self.cards.contains(where: { $0.base.kana == card.base.kana }) {
                self.cards.append(card)
            }
        }
        
        self.cards.sort { $0.nextBirthday! < $1.nextBirthday! }
        lastReloadDate = Date()
    }
    
    @objc private func reload() {
        loadData()
        scheduleNotifications()
        scheduleBirthdayEvents()
    }
    
    func scheduleNotifications() {
        
        if !Setting.default.schedulesBirthdayNotifications {
            return
        }
        
        removeNotifications()
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            
            if self.lastReloadDate.truncateHours(timeZone: Setting.default.timeZone) != Date().truncateHours(timeZone: Setting.default.timeZone) {
                self.reload()
            }
            
            // iOS supprot max 64 local notifications
            for card in self.cards.prefix(64) {

                let content = UNMutableNotificationContent()
                content.title = NSLocalizedString("Chara Birthday", comment: "Birthday notification title")
                let body = NSLocalizedString("Today is %@'s birthday (%@/%@)", comment: "Birthday notification body")
                content.body = String(format: body, card.base.rawName, card.profile.birthMonth, card.profile.birthDay)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: card.nextBirthdayComponents!, repeats: false)
                
                let requestIdentifier = Constant.appBundle + ".\(card.profile.unitName)"
                content.categoryIdentifier = NotificationHandler.UserNotificationCategoryType.birthday
                
                let userInfo: [String: Any] = ["card_name": card.base.rawName, "card_id": card.base.unitId]
                content.userInfo = userInfo
                
                let url = URL.resource.appendingPathComponent("icon/unit/\(card.iconID()).webp")

                let cachedType = KingfisherManager.shared.cache.imageCachedType(forKey: url.absoluteString, processorIdentifier: WebPProcessor.default.identifier)
                if cachedType == .disk {
                    let path = KingfisherManager.shared.cache.cachePath(forKey: url.absoluteString, processorIdentifier: WebPProcessor.default.identifier)
                    let imageURL = URL(fileURLWithPath: path)
                    // by adding into a notification, the attachment will be moved to a new location so you need to copy it first
                    // let fileManager = FileManager.default
                    let newURL = URL(fileURLWithPath: Path.temporary + "\(card.profile.unitId).png")
                    do {
                        let data = try Data(contentsOf: imageURL)
                        if let image = WebPProcessor.default.process(item: .data(data), options: []) {
                            let data = image.pngData()
                            try data?.write(to: newURL)
                        }
                        // try fileManager.copyItem(at: imageURL, to: newURL)
                    } catch {
                        print(error.localizedDescription)
                    }
                    if let attachment = try? UNNotificationAttachment(identifier: "imageAttachment", url: newURL, options: nil) {
                        content.attachments = [attachment]
                    }
                }
                
                let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if error == nil {
                        // print("notification scheduled: \(requestIdentifier)")
                    } else {
                        // if userinfo is not property list, this closure will not be executed, no errors here
                        print("notification falied in scheduling: \(requestIdentifier)")
                        print(error!)
                    }
                }
            }
        }
    }
    
    func removeNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func scheduleBirthdayEvents() {
        if Setting.default.autoAddBirthdaysToEvents {
            DispatchQueue.global(qos: .userInitiated).async {
                self.removeBirthdayEvents {
                    self.addBirthdayEvents()
                }
            }
        }
    }
    
    func addBirthdayEvents() {
        findOrCreateCalendar { calendar in
            for card in self.cards {
                let event = Klendario.newEvent(in: calendar)
                let titleFormat = NSLocalizedString("%@'s birthday", comment: "")
                event.title = String(format: titleFormat, card.base.rawName)
                let recurrenceRule = EKRecurrenceRule(recurrenceWith: .yearly, interval: 1, daysOfTheWeek: nil, daysOfTheMonth: [NSNumber(value: Int(card.profile.birthDay)!)], monthsOfTheYear: [NSNumber(value: Int(card.profile.birthMonth)!)], weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: nil)
                event.startDate = Date(year: Date().year, month: Int(card.profile.birthMonth)!, day: Int(card.profile.birthDay)!)
                event.addRecurrenceRule(recurrenceRule)
                event.endDate = event.startDate.addingTimeInterval(60 * 60 * 24 - 1)
                event.isAllDay = true
                event.save { error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    } else {
                        print("event successfully created!")
                    }
                }
            }
        }
    }
    
    private var calendarTitle: String {
        return Constant.calendarPrefix + NSLocalizedString("Birthday", comment: "")
    }
    
    func removeBirthdayEvents(_ ifGrantedThen: (() -> Void)? = nil) {
        Klendario.requestAuthorization { granted, status, error in
            if granted {
                Klendario.resetStore()
                let calendars = Klendario.getCalendars()
                let needToDeleteCalenders = calendars.filter { $0.title == self.calendarTitle }
                let group = DispatchGroup()
                for calendar in needToDeleteCalenders {
                    group.enter()
                    calendar.delete(commit: false) { error in
                        if let error = error {
                            print("error: \(error.localizedDescription)")
                        } else {
                            print("calendar successfully deleted!")
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    Klendario.commitChanges()
                    ifGrantedThen?()
                }
            }
        }
    }
    
    func findOrCreateCalendar(then: ((EKCalendar) -> Void)? = nil) {
        
        if let calendar = Klendario.getCalendars().first(where: { $0.title == self.calendarTitle }) {
            then?(calendar)
        } else {
            let calendar = Klendario.newCalendar()
            calendar.title = calendarTitle
            calendar.save(commit: true) { error in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                } else {
                    print("calendar successfully created!")
                }
                then?(calendar)
            }
        }
    }
}
