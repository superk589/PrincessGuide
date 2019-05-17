//
//  CalendarSettingViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2019/5/12.
//  Copyright © 2019 zzk. All rights reserved.
//

import UIKit
import Eureka
import Gestalt
import SwiftyJSON
import Klendario
import EventKit

class CalendarSettingViewController: FormViewController {
    
    struct Setting: Codable, Equatable, SettingProtocol {
        static let url = try! FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
            ).appendingPathComponent("calendar_settings.json")
        
        var autoAddBirthdayEvents = false { didSet { save() } }
        var autoAddGameEvents = false { didSet { save() } }
        
        struct Option: OptionSet, Codable, CustomStringConvertible {

            let rawValue: UInt
            
            init(rawValue: UInt) {
                self.rawValue = rawValue
            }
            
            static let exp = Option(rawValue: 1 << 0)
            static let drop = Option(rawValue: 1 << 1)
            static let mana = Option(rawValue: 1 << 2)
            static let clanBattle = Option(rawValue: 1 << 3)
            static let story = Option(rawValue: 1 << 4)
            static let tower = Option(rawValue: 1 << 5)
            static let gacha = Option(rawValue: 1 << 6)
            
            init?(vlCampaignBonusType: VLCampaign.BonusType) {
                switch vlCampaignBonusType {
                case .unknown:
                    return nil
                case .drop:
                    self = .drop
                case .mana:
                    self = .mana
                case .exp:
                    self = .exp
                }
            }

            var description: String {
                switch self {
                case .exp:
                    return NSLocalizedString("Exp.", comment: "")
                case .drop:
                    return NSLocalizedString("Drop Rate", comment: "")
                case .mana:
                    return NSLocalizedString("Mana", comment: "")
                case .tower:
                    return NSLocalizedString("Tower", comment: "")
                case .story:
                    return NSLocalizedString("Story Event", comment: "")
                case .gacha:
                    return NSLocalizedString("Gacha", comment: "")
                case .clanBattle:
                    return NSLocalizedString("Clan Battle", comment: "")
                default:
                    return ""
                }
            }
            
            static let allLabels: [Option] = [.exp, .drop, .mana, .tower, .clanBattle, .story, .gacha]
        }
        
        var options: Option = [.drop, .mana, .clanBattle, .story, .tower, .gacha, .exp]
        
        static var `default` = Setting.load() ?? Setting() {
            didSet {
                Setting.default.save()
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Calendar Settings", comment: "")
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.backgroundView = backgroundImageView
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            let navigationBar = themeable.navigationController?.navigationBar
            navigationBar?.tintColor = theme.color.tint
            navigationBar?.barStyle = theme.barStyle
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.tableView.indicatorStyle = theme.indicatorStyle
            themeable.tableView.backgroundColor = theme.color.background
            themeable.view.tintColor = theme.color.tint
        }
        
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
                $0.footer = HeaderFooterView(title: NSLocalizedString("These settings are used for automatically adding events to your system Calendar whenever game data is updated inside this app. The events in system Calendar will be grouped in separate calendars with prefix \"Hatsune's Notes\".\\n**IMPORTANT**: It's not recommended to enable these settings on multiple devices of the same iCloud account, which will result in multiple calendar groups with the same content." , comment: "").replacingOccurrences(of: "\\n", with: "\n"))
            }
            
            <<< SwitchRow("birthday_events_auto_update") { (row) in
                row.title = NSLocalizedString("Enable Birthday Events", comment: "")
                row.value = Setting.default.autoAddBirthdayEvents
                }
                .cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onChange { (row) in
                    if let value = row.value {
                        Setting.default.autoAddBirthdayEvents = value
                    }
                    LoadingHUDManager.default.show()
                    BirthdayCenter.default.rescheduleBirthdayEvents() {
                        DispatchQueue.main.async {
                            LoadingHUDManager.default.hide()
                        }
                    }
            }
            
            <<< SwitchRow("game_events_auto_update") { (row) in
                row.title = NSLocalizedString("Enable Game Events", comment: "")
                row.value = Setting.default.autoAddGameEvents
                }
                .cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onChange { row in
                    if let value = row.value {
                        Setting.default.autoAddGameEvents = value
                    }
                    LoadingHUDManager.default.show()
                    GameEventCenter.default.rescheduleGameEvents() {
                        DispatchQueue.main.async {
                            LoadingHUDManager.default.hide()
                        }
                    }
                }
        
            <<< LabelRow("calendar_status") {
                $0.title = NSLocalizedString("Calendar Permission", comment: "")
                }.cellSetup { [unowned self] cell, row in
                    row.value = self.systemCalendarStatusString
                    cell.selectedBackgroundView = UIView()
                    ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
                        themeable.textLabel?.textColor = theme.color.title
                        themeable.detailTextLabel?.textColor = theme.color.tint
                        themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
                        themeable.backgroundColor = theme.color.tableViewCell.background
                    }
                }
                .cellUpdate { [unowned self] cell, row in
                    ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
                        themeable.textLabel?.textColor = theme.color.title
                        themeable.detailTextLabel?.textColor = theme.color.tint
                    }
                    cell.detailTextLabel?.text = self.systemCalendarStatusString
                }
                .onCellSelection { [unowned self] (cell, row) in
                    self.openSystemSettings()
            }
            
            +++ Section(NSLocalizedString("Game Events Filter", comment: "")) {
                $0.tag = "filter"
                $0.hidden = "$game_events_auto_update == NO"
            }
        
            <<< ButtonRow("apply") {
                $0.title = NSLocalizedString("Apply", comment: "")
            }
                .cellSetup(cellSetup(cell:row:))
                .onCellSelection { _, _ in
                    LoadingHUDManager.default.show()
                    GameEventCenter.default.rescheduleGameEvents() {
                        DispatchQueue.main.async {
                            LoadingHUDManager.default.hide()
                        }
                    }
        }
        
        let section = form.sectionBy(tag: "filter")
        for (index, label) in Setting.Option.allLabels.enumerated() {
            let row = CheckRow("label_\(index)") { row in
                row.title = label.description
                row.value = Setting.default.options.contains(label)
            }
            .cellSetup(cellSetup(cell:row:))
            .cellUpdate(cellUpdate(cell:row:))
            .onCellSelection { cell, row in
                if let value = row.value {
                    if value {
                        Setting.default.options.insert(label)
                    } else {
                        Setting.default.options.remove(label)
                    }
                    
                }
            }
            section?.append(row)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadSettings(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleStoreChanged(_:)), name: .EKEventStoreChanged, object: nil)
        
    }
    
    private var systemCalendarStatusString: String {
        let status = EKEventStore.authorizationStatus(for: .event)
        switch status {
        case .authorized:
            return NSLocalizedString("Authorized", comment: "")
        case .denied:
            return NSLocalizedString("Denied", comment: "")
        case .notDetermined:
            return NSLocalizedString("Not Determined", comment: "")
        default:
            return NSLocalizedString("Unknown", comment: "")
        }
    }
    
    @objc private func openSystemSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func handleStoreChanged(_ notification: Notification) {
        let row = self.form.rowBy(tag: "calendar_status") as? LabelRow
        row?.value = self.systemCalendarStatusString
        row?.reload()
    }
    
    @objc private func reloadSettings(_ item: Notification) {
        form.sectionBy(tag: "settings")?.reload()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
