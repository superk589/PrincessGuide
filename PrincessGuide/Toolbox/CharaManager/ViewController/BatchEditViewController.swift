//
//  BatchEditViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/5.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Eureka
import Gestalt
import CoreData
import SwiftyJSON

class BatchEditViewController: FormViewController {

    let context: NSManagedObjectContext
    let parentContext: NSManagedObjectContext
    
    let charas: [Chara]
        
    init(charas: [Chara], parentContext: NSManagedObjectContext = CoreDataStack.default.viewContext) {
        self.parentContext = parentContext
        let context = CoreDataStack.default.newChildContext(parent: parentContext)
        self.charas = charas.map { context.object(with: $0.objectID) as! Chara }
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Batch Edit", comment: "")
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveCharas))
        
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
                    themeable.cell.pickerTextAttributes = [NSAttributedString.Key.foregroundColor: theme.color.body]
                }
            }
        }
        
        form.inlineRowHideOptions = InlineRowHideOptions.AnotherInlineRowIsShown.union(.FirstResponderChanges)
        
        form
            
            +++ Section(NSLocalizedString("General", comment: "")) {
                $0.footer = HeaderFooterView(title: NSLocalizedString("Generally, you only want to batch edit unit level and skill level. If switch on this option, every field will be saved on all selected charas. Make sure you have understood what's the meaning of this option before saving.", comment: ""))
            }
            
            <<< SwitchRow("save_all") { (row : SwitchRow) -> Void in
                row.title = NSLocalizedString("Show All Field", comment: "")
                
                row.value = false
                
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
                
                row.value = (charas.first?.level).flatMap { Int($0) } ?? Preload.default.maxPlayerLevel
                
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
                
                row.hidden = "$save_all == NO"
                
                row.value = (charas.first?.rank).flatMap { Int($0) } ?? Preload.default.maxEquipmentRank

                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onCellSelection(onCellSelection(cell:row:))
                .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))
                .onChange { [weak self] (pickerRow) in
                    if let card = self?.charas.first?.card, let row = self?.form.rowBy(tag: "slots") as? SlotsRow,
                        let value = pickerRow.value, card.promotions.indices ~= value - 1 {
                        row.cell.configure(for: card.promotions[value - 1], slots: [Bool](repeating: true, count: 6))
                    }
            }
            
            <<< PickerInlineRow<Int>("bond_rank") { (row : PickerInlineRow<Int>) -> Void in
                row.title = NSLocalizedString("Bond Rank", comment: "")
                row.displayValueFor = { (rowValue: Int?) in
                    return rowValue.flatMap { String($0) }
                }
                row.options = []
                for i in 0..<Constant.presetMaxBondRank {
                    row.options.append(i + 1)
                }
                row.hidden = "$save_all == NO"
                row.value = (charas.first?.bondRank).flatMap { Int($0) } ?? Constant.presetMaxBondRank

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
                row.hidden = "$save_all == NO"
                row.value = (charas.first?.rarity).flatMap { Int($0) } ?? Constant.presetMaxRarity

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
                
                row.value = (charas.first?.skillLevel).flatMap { Int($0) } ?? Preload.default.maxPlayerLevel

                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onCellSelection(onCellSelection(cell:row:))
                .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))
            
            +++ Section(NSLocalizedString("Equipment", comment: "")) {
                $0.footer = HeaderFooterView(title: NSLocalizedString("Only shows the first chara's equipments, but will reflect on all selected charas.", comment: ""))
                $0.hidden = "$save_all == NO"
            }
            
            <<< SlotsRow("slots")
                .cellSetup{ [weak self] (cell, row) in
                    cell.selectedBackgroundView = UIView()
                    ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
                        themeable.textLabel?.textColor = theme.color.title
                        themeable.detailTextLabel?.textColor = theme.color.tint
                        themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
                        themeable.backgroundColor = theme.color.tableViewCell.background
                    }
                    if let card = self?.charas.first?.card, let row = self?.form.rowBy(tag: "unit_rank") as? RowOf<Int>,
                        let value = row.value, card.promotions.indices ~= value - 1 {
                        cell.configure(for: card.promotions[value - 1], slots: self?.charas.first?.slots ?? [Bool](repeating: true, count: 6))
                    }
            }
        
    }
    
    @objc func saveCharas() {
        let values = form.values()
        let json = JSON(values)
        
        charas.forEach {
            $0.modifiedAt = Date()
            if json["save_all"].boolValue {
                $0.bondRank = json["bond_rank"].int16Value
                $0.rank = json["unit_rank"].int16Value
                $0.rarity = json["unit_rarity"].int16Value
                $0.slots = json["slots"].arrayValue.map { $0.boolValue }
            }
            $0.level = json["unit_level"].int16Value
            $0.skillLevel = min(json["unit_level"].int16Value, json["skill_level"].int16Value)
        }
        
        do {
            try context.save()
        } catch(let error) {
            print(error)
        }
        
        didSave()
        
    }
    
    func didSave() {
        do {
            try parentContext.save()
        } catch(let error) {
            print(error)
        }
        if let vc = navigationController?.viewControllers[1] {
            navigationController?.popToViewController(vc, animated: true)
        }
    }

}
