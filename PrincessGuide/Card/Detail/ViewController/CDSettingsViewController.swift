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
            
            static let allLabels = [ExpressionStyle.full, .short, .valueOnly, .valueInCombat]
        }
        
        enum SkillStyle: String, Codable, CustomStringConvertible, CaseIterable {
            case both = "both"
            case evolutionFirst = "evolution_first"
            
            var description: String {
                switch self {
                case .both:
                    return NSLocalizedString("both", comment: "skill style")
                case .evolutionFirst:
                    return NSLocalizedString("evolution first", comment: "skill style")
                }
            }
        }
        
        var unitLevel: Int
        var unitRank: Int
        var bondRank: Int
        var skillLevel: Int
        var unitRarity: Int
        var targetLevel: Int
        var expressionStyle: ExpressionStyle = .short
        var addsEx: Bool
        var statusComparison: Bool
        var rankFrom: Int
        var rankTo: Int
        var skillStyle: SkillStyle = .evolutionFirst
        
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
        
        
        static let url = try! FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("unit_detail_settings.json")
        
        static var `default` = Setting.load() ?? Setting() {
            didSet {
                Setting.default.save()
            }
        }
        
        init() {
            unitLevel = Preload.default.maxPlayerLevel
            skillLevel = Preload.default.maxPlayerLevel
            bondRank = Constant.presetMaxBondRank
            unitRank = Preload.default.maxEquipmentRank
            unitRarity = Constant.presetMaxRarity
            targetLevel = unitLevel
            addsEx = true
            statusComparison = false
            rankFrom = max(0, Preload.default.maxEquipmentRank - 1)
            rankTo = Preload.default.maxEquipmentRank
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
        
        form.inlineRowHideOptions = InlineRowHideOptions.AnotherInlineRowIsShown.union(.FirstResponderChanges)

        form
            +++ Section(NSLocalizedString("Unit", comment: ""))
            
            <<< PickerInlineRow<Int>("unit_level") { (row : PickerInlineRow<Int>) -> Void in
                row.title = NSLocalizedString("Level", comment: "")
                row.displayValueFor = { (rowValue: Int?) in
                    return rowValue.flatMap { String($0) }
                }
                row.options = []
                for i in 0..<Preload.default.maxPlayerLevel {
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
                for i in 0..<Preload.default.maxEquipmentRank {
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
                let maxLevel = max(Preload.default.maxEnemyLevel, Preload.default.maxPlayerLevel)
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
                for i in 0..<Preload.default.maxPlayerLevel {
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
            
            <<< PickerInlineRow<String>("skill_style") { (row : PickerInlineRow<String>) -> Void in
                row.title = NSLocalizedString("Evolution Skill Style", comment: "")
                row.displayValueFor = { (rowValue: String?) in
                    return rowValue.flatMap { Setting.SkillStyle(rawValue: $0)?.description }
                }
                row.options = Setting.SkillStyle.allCases.map { $0.rawValue }
                row.value = Setting.default.skillStyle.rawValue
                
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onCellSelection(onCellSelection(cell:row:))
                .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))
            
            +++ Section(NSLocalizedString("Status", comment: ""))
            
            <<< SwitchRow("adds_ex") { (row : SwitchRow) -> Void in
                row.title = NSLocalizedString("Adds Ex Bonus", comment: "")
                
                row.value = Setting.default.addsEx
                
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
        
            <<< SwitchRow("status_comparison") { (row : SwitchRow) -> Void in
                row.title = NSLocalizedString("Status Comparison", comment: "")
                
                row.value = Setting.default.statusComparison
                
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
        
            <<< PickerInlineRow<Int>("rank_from") { (row : PickerInlineRow<Int>) -> Void in
                row.title = NSLocalizedString("Rank From", comment: "")
                row.displayValueFor = { (rowValue: Int?) in
                    return rowValue.flatMap { String($0) }
                }
                row.options = []
                for i in 0..<Preload.default.maxEquipmentRank {
                    row.options.append(i + 1)
                }
                row.value = Setting.default.rankFrom
                row.hidden = "$status_comparison == NO"
                
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onCellSelection(onCellSelection(cell:row:))
                .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))
        
            <<< PickerInlineRow<Int>("rank_to") { (row : PickerInlineRow<Int>) -> Void in
                row.title = NSLocalizedString("Rank To", comment: "")
                row.displayValueFor = { (rowValue: Int?) in
                    return rowValue.flatMap { String($0) }
                }
                row.options = []
                for i in 0..<Preload.default.maxEquipmentRank {
                    row.options.append(i + 1)
                }
                row.value = Setting.default.rankTo
                row.hidden = "$status_comparison == NO"
                
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onCellSelection(onCellSelection(cell:row:))
                .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))

            +++ Section()
    
            <<< ButtonRow("reset") { (row) in
                row.title = NSLocalizedString("Reset", comment: "")
                }
                .cellSetup(cellSetup(cell:row:))
                .onCellSelection { [unowned self] (cell, row) in
                    let encoder = JSONEncoder()
                    encoder.keyEncodingStrategy = .convertToSnakeCase
                    let data = try! encoder.encode(Setting())
                    let json = try! JSON(data: data)
                    self.form.setValues(json.dictionaryObject ?? [:])
                    self.tableView.reloadData()
                    
        }
        
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
