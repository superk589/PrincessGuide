//
//  CDSettingsViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/9.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Eureka
import Gestalt
import SwiftyJSON

extension Notification.Name {
    
    static let cardDetailSettingsDidChange = Notification.Name(rawValue: "card_detail_settings_did_change")
}

class CDSettingsViewController: FormViewController {
    
    struct Setting: Codable, Equatable {
        var unitLevel: Int
        var unitRank: Int
        var unitLove: Int
        var skillLevel: Int
        var unitRarity: Int
        
        func save() {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            try? encoder.encode(self).write(to: Setting.url)
            NotificationCenter.default.post(name: .cardDetailSettingsDidChange, object: nil)
        }
        
        static func load() -> Setting? {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = try? Data(contentsOf: url) else {
                return nil
            }
            return try? decoder.decode(Setting.self, from: data)
        }
        
        
        static let url = URL(fileURLWithPath: Path.document).appendingPathComponent("unit_detail_settings.json")
        
        static var `default` = Setting.load() ?? Setting() {
            didSet {
                Setting.default.save()
            }
        }
        
        init() {
            unitLevel = ConsoleVariables.default.maxPlayerLevel
            skillLevel = ConsoleVariables.default.maxPlayerLevel
            unitLove = Constant.presetMaxCharaLoveRank
            unitRank = ConsoleVariables.default.maxEquipmentRank
            unitRarity = Constant.presetMaxRarity
        }
    }

    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleNavigationRightItem(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleNavigationLeftItem(_:)))
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            let navigationBar = themable.navigationController?.navigationBar
            navigationBar?.tintColor = theme.color.tint
            navigationBar?.barStyle = theme.barStyle
            themable.backgroundImageView.image = theme.backgroundImage
            themable.tableView.indicatorStyle = theme.indicatorStyle
            themable.tableView.backgroundColor = theme.color.background
        }
        
        PickerInlineRow<Int>.defaultCellSetup = { (cell, row) in
            cell.selectedBackgroundView = UIView()
            ThemeManager.default.apply(theme: Theme.self, to: cell) { (themable, theme) in
                themable.textLabel?.textColor = theme.color.title
                themable.detailTextLabel?.textColor = theme.color.tint
                themable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
                themable.backgroundColor = theme.color.tableViewCell.background
            }
        }
        PickerInlineRow<Int>.defaultCellUpdate = { (cell, row) in
            ThemeManager.default.apply(theme: Theme.self, to: cell) { (themable, theme) in
                themable.textLabel?.textColor = theme.color.title
                themable.detailTextLabel?.textColor = theme.color.tint
            }
        }
        
        func onCellSelection(cell: PickerInlineCell<Int>, row: PickerInlineRow<Int>) {
            ThemeManager.default.apply(theme: Theme.self, to: cell) { (themable, theme) in
                themable.textLabel?.textColor = theme.color.title
                themable.detailTextLabel?.textColor = theme.color.tint
            }
        }
        
        func onExpandInlineRow(cell: PickerInlineCell<Int>, row: PickerInlineRow<Int>, pickerRow: PickerRow<Int>) {
            pickerRow.cell.selectedBackgroundView = UIView()
            pickerRow.cellSetup{ (cell, row) in
                ThemeManager.default.apply(theme: Theme.self, to: row) { (themable, theme) in
                    themable.cell.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
                    themable.cell.backgroundColor = theme.color.tableViewCell.background
                }
            }
            pickerRow.cellUpdate { (cell, row) in
                cell.picker.showsSelectionIndicator = false
                ThemeManager.default.apply(theme: Theme.self, to: row) { (themable, theme) in
                    themable.cell.backgroundColor = theme.color.tableViewCell.background
                    themable.onProvideStringAttributes = {
                        return [NSAttributedStringKey.foregroundColor: theme.color.body]
                    }
                }
            }
        }
        
        form.inlineRowHideOptions = InlineRowHideOptions.AnotherInlineRowIsShown.union(.FirstResponderChanges)

        form
            +++ Section(NSLocalizedString("Unit", comment: ""))
            
            <<< PickerInlineRow<Int>("unit_level") { (row : PickerInlineRow<Int>) -> Void in
                row.title = NSLocalizedString("Level", comment: "")
                row.displayValueFor = { (rowValue: Int?) in
                    return rowValue.flatMap { String($0) }
                }
                row.options = []
                for i in 0..<ConsoleVariables.default.maxPlayerLevel {
                    row.options.append(i + 1)
                }
                row.value = Setting.default.unitLevel
                }.onCellSelection(onCellSelection(cell:row:))
                .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))
            <<< PickerInlineRow<Int>("unit_rank") { (row : PickerInlineRow<Int>) -> Void in
                row.title = NSLocalizedString("Rank", comment: "")
                row.displayValueFor = { (rowValue: Int?) in
                    return rowValue.flatMap { String($0) }
                }
                row.options = []
                for i in 0..<ConsoleVariables.default.maxEquipmentRank {
                    row.options.append(i + 1)
                }
                row.value = Setting.default.unitRank
                
                }.onCellSelection(onCellSelection(cell:row:))
                .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))
            <<< PickerInlineRow<Int>("unit_love") { (row : PickerInlineRow<Int>) -> Void in
                row.title = NSLocalizedString("Bond Rank", comment: "")
                row.displayValueFor = { (rowValue: Int?) in
                    return rowValue.flatMap { String($0) }
                }
                row.options = []
                for i in 0..<ConsoleVariables.default.maxEquipmentRank {
                    row.options.append(i + 1)
                }
                row.value = Setting.default.unitLove
                
                }.onCellSelection(onCellSelection(cell:row:))
                .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))
            <<< PickerInlineRow<Int>("unit_rarity") { (row : PickerInlineRow<Int>) -> Void in
                row.title = NSLocalizedString("Star Rank", comment: "")
                row.displayValueFor = { (rowValue: Int?) in
                    return rowValue.flatMap { String($0) }
                }
                row.options = []
                for i in 0..<Constant.presetMaxRarity {
                    row.options.append(i + 1)
                }
                row.value = Setting.default.unitRarity
                
                }.onCellSelection(onCellSelection(cell:row:))
                .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))
            
            +++ Section(NSLocalizedString("Skill", comment: ""))
            
            <<< PickerInlineRow<Int>("skill_level") { (row : PickerInlineRow<Int>) -> Void in
                row.title = NSLocalizedString("Level", comment: "")
                row.displayValueFor = { (rowValue: Int?) in
                    return rowValue.flatMap { String($0) }
                }
                row.options = []
                for i in 0..<ConsoleVariables.default.maxPlayerLevel {
                    row.options.append(i + 1)
                }
                row.value = Setting.default.skillLevel
                
                }.onCellSelection(onCellSelection(cell:row:))
                .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))

    }
    
    @objc private func handleNavigationRightItem(_ item: UIBarButtonItem) {
        let json = JSON(form.values())
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
