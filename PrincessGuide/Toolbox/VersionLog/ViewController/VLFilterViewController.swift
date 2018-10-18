//
//  VLFilterViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/10/3.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Eureka
import Gestalt
import SwiftyJSON

extension Notification.Name {
    
    static let versionLogFilterDidChange = Notification.Name(rawValue: "version_log_filter_did_change")
}

class VLFilterViewController: FormViewController {
    
    struct Setting: Codable, Equatable {
        
        enum Filter: String, Codable, CustomStringConvertible, CaseIterable {
            case clanBattle = "clan_battle"
            case dungeonArea = "dungeon_area"
            case gacha
            case questArea = "quest_area"
            case story
            case unit
            case maxLv = "max_lv"
            case event
            case campaign
            case none
            
            var description: String {
                switch self {
                
                case .clanBattle:
                    return NSLocalizedString("Clan Battle", comment: "")
                case .dungeonArea:
                    return NSLocalizedString("Dungeon", comment: "")
                case .gacha:
                    return NSLocalizedString("Gacha", comment: "")
                case .questArea:
                    return NSLocalizedString("Quest Area", comment: "")
                case .story:
                    return NSLocalizedString("Story", comment: "")
                case .unit:
                    return NSLocalizedString("Unit", comment: "")
                case .maxLv:
                    return NSLocalizedString("Max. lv.", comment: "")
                case .event:
                    return NSLocalizedString("Event", comment: "")
                case .campaign:
                    return NSLocalizedString("Campaign", comment: "")
                case .none:
                    return NSLocalizedString("None", comment: "")
                }
            }
        }
        
        var filter: Filter
        
        func save() {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            try? encoder.encode(self).write(to: Setting.url)
            NotificationCenter.default.post(name: .versionLogFilterDidChange, object: nil)
        }
        
        static func load() -> Setting? {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = try? Data(contentsOf: url) else {
                return nil
            }
            return try? decoder.decode(Setting.self, from: data)
        }
        
        
        static let url = URL(fileURLWithPath: Path.document).appendingPathComponent("version_log_filter.json")
        
        static var `default` = Setting.load() ?? Setting() {
            didSet {
                Setting.default.save()
            }
        }
        
        init() {
            filter = .none
        }
    }
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleNavigationRightItem(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleNavigationLeftItem(_:)))
        tableView.backgroundView = backgroundImageView
        tableView.cellLayoutMarginsFollowReadableWidth = true
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            let navigationBar = themeable.navigationController?.navigationBar
            navigationBar?.tintColor = theme.color.tint
            navigationBar?.barStyle = theme.barStyle
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.tableView.indicatorStyle = theme.indicatorStyle
            themeable.tableView.backgroundColor = theme.color.background
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
        
        form.inlineRowHideOptions = InlineRowHideOptions.AnotherInlineRowIsShown.union(.FirstResponderChanges)
        
        form
            +++ Section(NSLocalizedString("Filter", comment: ""))
            
            <<< PickerInlineRow<String>("filter") { (row : PickerInlineRow<String>) -> Void in
                row.title = NSLocalizedString("Filter Condition", comment: "")
                row.displayValueFor = { filter in
                    return filter.flatMap { Setting.Filter(rawValue: $0) }?.description
                }
                row.options = Setting.Filter.allCases.map { $0.rawValue }
                
                row.value = Setting.default.filter.rawValue
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onCellSelection(onCellSelection(cell:row:))
                .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))
    }
    
    @objc private func handleNavigationRightItem(_ item: UIBarButtonItem) {
        let json = JSON(form.values(includeHidden: true))
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let setting = try? decoder.decode(Setting.self, from: json.rawData()) {
            Setting.default = setting
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleNavigationLeftItem(_ item: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
