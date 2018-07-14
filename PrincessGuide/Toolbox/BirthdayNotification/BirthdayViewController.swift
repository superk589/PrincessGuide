//
//  BirthdayViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Eureka
import Gestalt
import SwiftyJSON
import UserNotifications

class BirthdayViewController: FormViewController {
    
    struct Setting: Codable, Equatable, SettingProtocol {
        
        static let url = URL(fileURLWithPath: Path.document).appendingPathComponent("birthday_notification_settings.json")

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
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("Chara Birthday", comment: "")
        tableView.backgroundView = backgroundImageView
        tableView.cellLayoutMarginsFollowReadableWidth = true
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.tableView.indicatorStyle = theme.indicatorStyle
            themeable.tableView.backgroundColor = theme.color.background
            themeable.view.tintColor = theme.color.tint
        }
        
        func cellUpdate<T: RowType, U>(cell: T.Cell, row: T) where T.Cell.Value == U {
            ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
                themeable.textLabel?.textColor = theme.color.title
                themeable.detailTextLabel?.textColor = theme.color.tint
            }
        }
        
        func cellSetup<T: RowType, U>(cell: T.Cell, row: T) where T.Cell.Value == U {
            cell.selectedBackgroundView = UIView()
            ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
                themeable.textLabel?.textColor = theme.color.title
                themeable.detailTextLabel?.textColor = theme.color.tint
                themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
                themeable.backgroundColor = theme.color.tableViewCell.background
            }
            if let segmentedControl = (cell as? SegmentedCell<U>)?.segmentedControl {
                segmentedControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
            }
        }
        
        func onCellSelection<T>(cell: PickerInlineCell<T>, row: PickerInlineRow<T>) {
            ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
                themeable.textLabel?.textColor = theme.color.title
                themeable.detailTextLabel?.textColor = theme.color.tint
            }
        }
        
        func onExpandInlineRow<T>(cell: PickerInlineCell<T>, row: PickerInlineRow<T>, pickerRow: PickerRow<T>) {
            pickerRow.cellSetup{ (cell, row) in
                cell.selectedBackgroundView = UIView()
                ThemeManager.default.apply(theme: Theme.self, to: row) { (themeable, theme) in
                    themeable.cell.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
                    themeable.cell.backgroundColor = theme.color.tableViewCell.background
                }
            }
            pickerRow.cellUpdate { (cell, row) in
                cell.picker.showsSelectionIndicator = false
                ThemeManager.default.apply(theme: Theme.self, to: row) { (themeable, theme) in
                    themeable.cell.backgroundColor = theme.color.tableViewCell.background
                    themeable.onProvideStringAttributes = {
                        return [NSAttributedStringKey.foregroundColor: theme.color.body]
                    }
                }
            }
        }
        
        form
            +++ Section(NSLocalizedString("Settings", comment: "")) {
                $0.tag = "settings"
            }
        
            <<< SwitchRow("schedules_birthday_notifications") { (row : SwitchRow) -> Void in
                row.title = NSLocalizedString("Enable Notifications", comment: "")
                
                row.value = Setting.default.schedulesBirthdayNotifications
                
                }.cellSetup { (cell, row) in
                    cell.selectedBackgroundView = UIView()
                    ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
                        themeable.textLabel?.textColor = theme.color.title
                        themeable.detailTextLabel?.textColor = theme.color.tint
                        themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
                        themeable.backgroundColor = theme.color.tableViewCell.background
                        themeable.switchControl.onTintColor = theme.color.tint
                    }
                }.cellUpdate(cellUpdate(cell:row:))
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
            .onChange { [weak self] (row) in
                self?.form.rowBy(tag: "cards")?.reload()
                if let timeZone = row.value {
                    Setting.default.timeZone = timeZone
                }
            }
        
            <<< LabelRow("notification_status") {
                $0.title = NSLocalizedString("Notification Permission", comment: "")
            }.cellSetup { [weak self] cell, row in
                row.value = self?.systemNotificationStatusString
                cell.selectedBackgroundView = UIView()
                ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
                    themeable.textLabel?.textColor = theme.color.title
                    themeable.detailTextLabel?.textColor = theme.color.tint
                    themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
                    themeable.backgroundColor = theme.color.tableViewCell.background
                }
            }
            .cellUpdate { [weak self] cell, row in
                ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
                    themeable.textLabel?.textColor = theme.color.title
                    themeable.detailTextLabel?.textColor = theme.color.tint
                }
                cell.detailTextLabel?.text = self?.systemNotificationStatusString
            }
            .onCellSelection { [weak self] (cell, row) in
                self?.openSystemNotificationSettings()
            }
            
            +++ Section(NSLocalizedString("Upcoming Birthdays", comment: ""))
        
            <<< CardWithBirthdayRow("upcoming_birthdays").cellSetup { (cell, row) in
                cell.selectedBackgroundView = UIView()
                ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
                    themeable.textLabel?.textColor = theme.color.title
                    themeable.detailTextLabel?.textColor = theme.color.tint
                    themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
                    themeable.backgroundColor = theme.color.tableViewCell.background
                }
                cell.configure(for: self.cards)
                cell.delegate = self
            }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCards(_:)), name: .preloadEnd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadSettings(_:)), name: .UIApplicationDidBecomeActive, object: nil)
        
    }
    
    @objc private func reloadCards(_ item: Notification) {
        (form.rowBy(tag: "upcoming_birthdays") as? CardWithBirthdayRow)?.cell.configure(for: cards)
    }
    
    @objc private func reloadSettings(_ item: Notification) {
        form.sectionBy(tag: "settings")?.reload()
    }
    
    @objc private func openSystemNotificationSettings() {
        if let url = URL(string: UIApplicationOpenSettingsURLString), UIApplication.shared.canOpenURL(url) {
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
                    BirthdayCenter.default.scheduleNotifications()
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
