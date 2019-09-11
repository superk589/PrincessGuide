//
//  BirthdayViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Eureka
import SwiftyJSON
import UserNotifications

class BirthdayViewController: FormViewController {
    
    struct Setting: Codable, Equatable, SettingProtocol {
        
        static let url = try! FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("birthday_notification_settings.json")

        var schedulesBirthdayNotifications: Bool = false { didSet { save() } }
        
        var timeZone: TimeZone = .tokyo { didSet { save() } }
        
        static var `default` = Setting.load() ?? Setting() {
            didSet {
                Setting.default.save()
            }
        }
    }
    
    var cards: [Card] {
        return BirthdayCenter.default.cards
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("Chara Birthday", comment: "")
        tableView.cellLayoutMarginsFollowReadableWidth = true
        view.tintColor = Theme.dynamic.color.tint
        
        func cellUpdate<T: RowType, U>(cell: T.Cell, row: T) where T.Cell.Value == U {
            EurekaAppearance.cellUpdate(cell: cell, row: row)
        }
        
        func cellSetup<T: RowType, U>(cell: T.Cell, row: T) where T.Cell.Value == U {
            EurekaAppearance.cellSetup(cell: cell, row: row)
        }
        
        func onCellSelection<T>(cell: PickerInlineCell<T>, row: PickerInlineRow<T>) {
            EurekaAppearance.onCellSelection(cell: cell, row: row)
        }
        
        func onExpandInlineRow<T>(cell: PickerInlineCell<T>, row: PickerInlineRow<T>, pickerRow: PickerRow<T>) {
            EurekaAppearance.onExpandInlineRow(cell: cell, row: row, pickerRow: pickerRow)
        }
        
        form
            +++ Section(NSLocalizedString("Settings", comment: "")) {
                $0.tag = "settings"
            }
        
            <<< SwitchRow("schedules_birthday_notifications") { (row : SwitchRow) -> Void in
                row.title = NSLocalizedString("Enable Notifications", comment: "")
                
                row.value = Setting.default.schedulesBirthdayNotifications
                
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onChange { [unowned self] (row) in
                    if let value = row.value {
                        Setting.default.schedulesBirthdayNotifications = value
                    }
                    self.rescheduleBirthdayNotifications()
                }
        
            <<< ActionSheetRow<TimeZone>("time_zone") {
                $0.title = NSLocalizedString("Time Zone", comment: "")
                $0.displayValueFor = { $0?.identifier }
                $0.value = Setting.default.timeZone
                $0.options = [.tokyo]
                if TimeZone.current != .tokyo {
                    $0.options?.append(.current)
                }
            }.cellSetup(cellSetup(cell:row:))
            .cellUpdate(cellUpdate(cell:row:))
            .onChange { [unowned self] (row) in
                self.form.rowBy(tag: "cards")?.reload()
                if let timeZone = row.value {
                    Setting.default.timeZone = timeZone
                }
            }
        
            <<< LabelRow("notification_status") { [unowned self] in
                $0.title = NSLocalizedString("Notification Permission", comment: "")
                $0.value = self.systemNotificationStatusString
            }.cellSetup(cellSetup(cell:row:))
            .cellUpdate { [unowned self] cell, row in
                cell.textLabel?.textColor = Theme.dynamic.color.title
                cell.detailTextLabel?.textColor = Theme.dynamic.color.tint
                cell.detailTextLabel?.text = self.systemNotificationStatusString
            }
            .onCellSelection { [unowned self] (cell, row) in
                self.openSystemNotificationSettings()
            }
            
            +++ Section(NSLocalizedString("Upcoming Birthdays", comment: ""))
        
            <<< CardWithBirthdayRow("upcoming_birthdays").cellSetup { (cell, row) in
                cell.textLabel?.textColor = Theme.dynamic.color.title
                cell.detailTextLabel?.textColor = Theme.dynamic.color.tint
                cell.configure(for: self.cards)
                cell.delegate = self
            }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCards(_:)), name: .preloadEnd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadSettings(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    @objc private func reloadCards(_ item: Notification) {
        let row = form.rowBy(tag: "upcoming_birthdays") as? CardWithBirthdayRow
        row?.cell.configure(for: cards)
        row?.reload()
    }
    
    @objc private func reloadSettings(_ item: Notification) {
        form.sectionBy(tag: "settings")?.reload()
    }
    
    @objc private func openSystemNotificationSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private var systemNotificationStatusString: String {
        let settings = DispatchSemaphore.sync { (closure) in
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: closure)
        }
        switch settings?.authorizationStatus {
        case .some(.authorized):
            return NSLocalizedString("Authorized", comment: "")
        case .some(.denied):
            return NSLocalizedString("Denied", comment: "")
        case .some(.notDetermined):
            return NSLocalizedString("Not Determined", comment: "")
        default:
            return NSLocalizedString("Unknown", comment: "")
        }
    }

    private func rescheduleBirthdayNotifications() {
        if Setting.default.schedulesBirthdayNotifications {
            UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert]) { [weak self] (granted, error) in
                if error == nil && granted {
                    BirthdayCenter.default.rescheduleNotifications()
                    DispatchQueue.main.async {
                        let row = self?.form.rowBy(tag: "notification_status") as? LabelRow
                        row?.value = self?.systemNotificationStatusString
                        row?.reload()
                    }
                }
            }
        } else {
            BirthdayCenter.default.removeNotifications()
        }
    }
    
}

extension BirthdayViewController: CardWithBirthdayCellDelegate {
    func cardWithBirthdayCell(_ cardWithBirthdayCell: CardWithBirthdayCell, didSelect card: Card) {
        let vc = CDTabViewController(card: card)
        navigationController?.pushViewController(vc, animated: true)
    }
}
