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
        
        enum ExpressionStyle: String, Codable, CustomStringConvertible {
            case full = "full"
            case short = "short"
            case valueOnly = "value_only"
            case valueInCombat = "value_in_combat"
            
            var description: String {
                switch self {
                case .full:
                    return NSLocalizedString("full", comment: "expression style")
                case .short:
                    return NSLocalizedString("short", comment: "expression style")
                case .valueOnly:
                    return NSLocalizedString("value only", comment: "expression style")
                case .valueInCombat:
                    return NSLocalizedString("value in combat", comment: "expression style")
                }
            }
            
            static var allLabels = [ExpressionStyle.full, .short, .valueOnly, .valueInCombat]
        }
        
        var unitLevel: Int
        var unitRank: Int
        var bondRank: Int
        var skillLevel: Int
        var unitRarity: Int
        var targetLevel: Int
        var expressionStyle: ExpressionStyle = .short
        
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
            bondRank = Constant.presetMaxBondRank
            unitRank = ConsoleVariables.default.maxEquipmentRank
            unitRarity = Constant.presetMaxRarity
            targetLevel = unitLevel
        }
    }

    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleNavigationRightItem(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleNavigationLeftItem(_:)))
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            let navigationBar = themeable.navigationController?.navigationBar
            navigationBar?.tintColor = theme.color.tint
            navigationBar?.barStyle = theme.barStyle
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.tableView.indicatorStyle = theme.indicatorStyle
            themeable.tableView.backgroundColor = theme.color.background
        }
        
        func cellUpdate<T: RowType>(cell: T.Cell, row: T) {
            ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
                themeable.textLabel?.textColor = theme.color.title
                themeable.detailTextLabel?.textColor = theme.color.tint
            }
        }
        
        func cellSetup<T: RowType>(cell: T.Cell, row: T) {
            cell.selectedBackgroundView = UIView()
            ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
                themeable.textLabel?.textColor = theme.color.title
                themeable.detailTextLabel?.textColor = theme.color.tint
                themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
                themeable.backgroundColor = theme.color.tableViewCell.background
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
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onCellSelection(onCellSelection(cell:row:))
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
                
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onCellSelection(onCellSelection(cell:row:))
                .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))
            <<< PickerInlineRow<Int>("bond_rank") { (row : PickerInlineRow<Int>) -> Void in
                row.title = NSLocalizedString("Bond Rank", comment: "")
                row.displayValueFor = { (rowValue: Int?) in
                    return rowValue.flatMap { String($0) }
                }
                row.options = []
                for i in 0..<Constant.presetMaxBondRank {
                    row.options.append(i + 1)
                }
                row.value = Setting.default.bondRank
                
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onCellSelection(onCellSelection(cell:row:))
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
                
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onCellSelection(onCellSelection(cell:row:))
                .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))
            
            <<< PickerInlineRow<Int>("target_level") { (row : PickerInlineRow<Int>) -> Void in
                row.title = NSLocalizedString("Target Level", comment: "")
                row.displayValueFor = { (rowValue: Int?) in
                    return rowValue.flatMap { String($0) }
                }
                row.options = []
                let maxLevel = max(ConsoleVariables.default.maxEnemyLevel, ConsoleVariables.default.maxPlayerLevel)
                for i in 0..<maxLevel {
                    row.options.append(i + 1)
                }
                row.value = Setting.default.targetLevel
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onCellSelection(onCellSelection(cell:row:))
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
                
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onCellSelection(onCellSelection(cell:row:))
                .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))
            
            <<< PickerInlineRow<String>("expression_style") { (row : PickerInlineRow<String>) -> Void in
                row.title = NSLocalizedString("Expression Style", comment: "")
                row.displayValueFor = { (rowValue: String?) in
                    return rowValue.flatMap { Setting.ExpressionStyle(rawValue: $0)?.description }
                }
                row.options = Setting.ExpressionStyle.allLabels.map { $0.rawValue }
                row.value = Setting.default.expressionStyle.rawValue
                
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onCellSelection(onCellSelection(cell:row:))
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
