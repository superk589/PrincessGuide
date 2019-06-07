//
//  GameEventCenter.swift
//  PrincessGuide
//
//  Created by zzk on 2019/5/12.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation
import EventKit

fileprivate typealias Setting = CalendarSettingViewController.Setting

class GameEventCenter {
    
    static let `default` = GameEventCenter()
    
    var events = [GameEvent]()
    
    let queue = DispatchQueue(label: "com.zzk.PrincessGuide.GameEventCenter")
    
    let eventStore = EKEventStore()
    
    private init() {
        
    }
    
    // call only once at AppDelegate's didLaunch
    func initialize() {
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .preloadEnd, object: nil)
    }
    
    @objc private func reload() {
        loadData()
        if Setting.default.autoAddGameEvents {
            rescheduleGameEvents()
        }
    }
    
    private func loadData() {
        self.events = Preload.default.events
    }
    
    func addGameEvents(then: (() -> Void)? = nil) {
        let filteredEvents = events.filter {
            switch $0 {
            case let event as CampaignEvent:
                if let bonusType = Setting.Option(vlCampaignBonusType: event.bonusType),
                    Setting.default.options.contains(bonusType) {
                    return true
                }
            case _ as StoryEvent:
                return Setting.default.options.contains(.story)
            case _ as TowerEvent:
                return Setting.default.options.contains(.tower)
            case _ as ClanBattleEvent:
                return Setting.default.options.contains(.clanBattle)
            case _ as GachaEvent:
                return Setting.default.options.contains(.gacha)
            default:
                break
            }
            return false
        }
        findOrCreateCalendar { [unowned self] calendar in
            for gameEvent in filteredEvents {
                let event = EKEvent(eventStore: self.eventStore)
                event.calendar = calendar
                event.startDate = gameEvent.startDate
                event.endDate = gameEvent.endDate
                event.timeZone = .tokyo
                event.title = gameEvent.title

                do {
                    try self.eventStore.save(event, span: .thisEvent)
                } catch let error {
                    print("error: \(error.localizedDescription)")
                }
            }
            then?()
        }
    }
    
    func rescheduleGameEvents(completion: (() -> Void)? = nil) {
        queue.async {
            self.removeGameEvents() { granted in
                if Setting.default.autoAddGameEvents && granted {
                    self.addGameEvents() {
                        completion?()
                    }
                } else {
                    completion?()
                }
            }
        }
    }
    
    private var calendarTitle: String {
        return Constant.calendarPrefix + NSLocalizedString("Game Event", comment: "")
    }
    
    func removeGameEvents(_ then: ((Bool) -> Void)? = nil) {
        eventStore.requestAccess(to: .event) { [unowned self] (granted, error) in
            if granted {
                self.eventStore.reset()
                let calendars = self.eventStore.calendars(for: .event)
                let needToDeleteCalenders = calendars.filter { $0.title == self.calendarTitle }
                
                do {
                    for calendar in needToDeleteCalenders {
                        try self.eventStore.removeCalendar(calendar, commit: false)
                    }
                    try self.eventStore.commit()
                    then?(true)
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                then?(false)
            }
        }
    }
    
    func findOrCreateCalendar(then: ((EKCalendar) -> Void)? = nil) {
        
        if let calendar = eventStore.calendars(for: .event).first(where: { $0.title == self.calendarTitle }) {
            then?(calendar)
        } else {
            let calendar = EKCalendar(for: .event, eventStore: eventStore)
            calendar.source = eventStore.defaultCalendarForNewEvents?.source
            calendar.title = calendarTitle
            do {
                try eventStore.saveCalendar(calendar, commit: true)
            } catch let error {
                print("error: \(error.localizedDescription)")
            }
            self.queue.async {
                then?(calendar)
            }
        }
    }
}
