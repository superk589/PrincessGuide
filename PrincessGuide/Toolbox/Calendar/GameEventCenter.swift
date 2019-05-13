//
//  GameEventCenter.swift
//  PrincessGuide
//
//  Created by zzk on 2019/5/12.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation
import Klendario
import EventKit

fileprivate typealias Setting = CalendarSettingViewController.Setting

class GameEventCenter {
    
    static let `default` = GameEventCenter()
    
    var events = [GameEvent]()
    
    let queue = DispatchQueue(label: "com.zzk.PrincessGuide.GameEventCenter")
    
    private init() {
        
    }
    
    // call only once at AppDelegate's didLaunch
    func initialize() {
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .preloadEnd, object: nil)
    }
    
    @objc private func reload() {
        loadData()
        scheduleGameEvents()
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
        findOrCreateCalendar { calendar in
            for gameEvent in filteredEvents {
                let event = Klendario.newEvent(in: calendar)
                
                event.startDate = gameEvent.startDate
                event.endDate = gameEvent.endDate
                event.timeZone = .tokyo
                event.title = gameEvent.title

                event.save { error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    } else {
                        print("event successfully created!")
                    }
                }
            }
            then?()
        }
    }
    
    func scheduleGameEvents(completion: (() -> Void)? = nil) {
        queue.async {
            self.removeGameEvents() {
                if Setting.default.autoAddGameEvents {
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
    
    func removeGameEvents(_ ifGrantedThen: (() -> Void)? = nil) {
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
                group.notify(queue: self.queue) {
                    Klendario.commitChanges()
                    ifGrantedThen?()
                }
            }
        }
    }
    
    func findOrCreateCalendar(then: ((EKCalendar) -> Void)? = nil) {
        
        if let calendar = Klendario.getCalendars().first(where: { $0.title == calendarTitle }) {
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
                self.queue.async {
                    then?(calendar)
                }
            }
        }
    }
}
