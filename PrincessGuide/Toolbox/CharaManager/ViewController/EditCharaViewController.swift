//
//  EditCharaViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/6/29.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Eureka
import SwiftyJSON
import CoreData

class EditCharaViewController: FormViewController {
    
    let card: Card?
    let context: NSManagedObjectContext
    let parentContext: NSManagedObjectContext
    
    enum Mode {
        case edit
        case create
    }
    
    let mode: Mode
    
    let chara: Chara?
    
    init(card: Card) {
        self.card = card
        mode = .create
        context = CoreDataStack.default.newChildContext(parent: CoreDataStack.default.viewContext)
        chara = Chara(context: context)
        chara?.id = Int32(card.base.unitId)
        parentContext = CoreDataStack.default.viewContext
        super.init(nibName: nil, bundle: nil)
    }
    
    init(chara: Chara) {
        mode = .edit
        parentContext = chara.managedObjectContext ?? CoreDataStack.default.viewContext
        context = CoreDataStack.default.newChildContext(parent: parentContext)
        self.chara = context.object(with: chara.objectID) as? Chara
        card = Card.findByID(Int(chara.id))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Edit Chara", comment: "")
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveChara))
        
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
        
        form.inlineRowHideOptions = InlineRowHideOptions.AnotherInlineRowIsShown.union(.FirstResponderChanges)
        
        form
            +++ Section()
            <<< ImageRow(tag: "image")
                .cellSetup { [weak self] (cell, row) in
                    if let card = self?.card {
                        cell.configure(for: card)
                    }
                }
                .cellUpdate(cellUpdate(cell:row:))
                .onCellSelection { [weak self] (cell, row) in
                    if let card = self?.card {
                        let vc = CDTabViewController(card: card)
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            
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
                if mode == .create {
                    row.value = Preload.default.maxPlayerLevel
                } else {
                    row.value = (chara?.level).flatMap { Int($0) }
                }
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
                if mode == .create {
                    row.value = Preload.default.maxEquipmentRank
                } else {
                    row.value = (chara?.rank).flatMap { Int($0) }
                }
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onCellSelection(onCellSelection(cell:row:))
                .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))
                .onChange { [weak self] (pickerRow) in
                    if let card = self?.card, let row = self?.form.rowBy(tag: "slots") as? SlotsRow,
                        let value = pickerRow.value, card.promotions.indices ~= value - 1 {
                        let promotion = card.promotions[value - 1]
                        row.cell.configure(for: promotion, slots: promotion.defaultSlots)
                    }
                }
            
            <<< PickerInlineRow<Int>("bond_rank") { (row : PickerInlineRow<Int>) -> Void in
                row.title = NSLocalizedString("Bond Rank", comment: "")
                row.displayValueFor = { (rowValue: Int?) in
                    return rowValue.flatMap { String($0) }
                }
                row.options = []
                for i in 0..<Constant.presetMaxPossibleBondRank {
                    row.options.append(i + 1)
                }
                if mode == .create {
                    row.value = Constant.presetMaxPossibleBondRank
                } else {
                    row.value = (chara?.bondRank).flatMap { Int($0) }
                }
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
                for i in 0..<Constant.presetMaxPossibleRarity {
                    row.options.append(i + 1)
                }
                if mode == .create {
                    row.value = Constant.presetMaxPossibleRarity
                } else {
                    row.value = (chara?.rarity).flatMap { Int($0) }
                }
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
                if mode == .create {
                    row.value = Preload.default.maxPlayerLevel
                } else {
                    row.value = (chara?.skillLevel).flatMap { Int($0) }
                }
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onCellSelection(onCellSelection(cell:row:))
                .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))
        
            +++ Section(NSLocalizedString("Equipment", comment: ""))
            <<< SwitchRow("enables_unique_equipment") { (row : SwitchRow) -> Void in
                row.title = NSLocalizedString("Unique Equipment", comment: "")
                
                var isHidden = false
                if mode == .create {
                    if let card = self.card {
                        row.value = card.uniqueEquipIDs.count > 0
                        isHidden = card.uniqueEquipIDs.count == 0
                    } else {
                        isHidden = true
                    }
                } else {
                    if let chara = self.chara {
                        row.value = chara.enablesUniqueEquipment
                    } else {
                        isHidden = true
                    }
                }
                
                row.hidden = .init(booleanLiteral: isHidden)
                
                }
                .cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
            
            <<< PickerInlineRow<Int>("unique_equipment_level") { (row : PickerInlineRow<Int>) -> Void in
                row.title = NSLocalizedString("Unique Equipment Level", comment: "")
                row.displayValueFor = { (rowValue: Int?) in
                    return rowValue.flatMap { String($0) }
                }
                row.options = []
                for i in 0..<Preload.default.maxUniqueEquipmentLevel {
                    row.options.append(i + 1)
                }
                row.hidden = "$enables_unique_equipment == NO"
                if mode == .create {
                    row.value = Preload.default.maxUniqueEquipmentLevel
                } else {
                    row.value = (chara?.uniqueEquipmentLevel).flatMap { Int($0) }
                }
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onCellSelection(onCellSelection(cell:row:))
                .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))
            
            <<< SlotsRow("slots")
                .cellSetup{ [weak self] (cell, row) in
                    cell.textLabel?.textColor = Theme.dynamic.color.title
                    cell.detailTextLabel?.textColor = Theme.dynamic.color.tint
                    if let card = self?.card, let row = self?.form.rowBy(tag: "unit_rank") as? RowOf<Int>,
                        let value = row.value, card.promotions.indices ~= value - 1 {
                        let promotion = card.promotions[value - 1]
                        if self?.mode == .create {
                            cell.configure(for: promotion, slots: promotion.defaultSlots)
                        } else {
                            cell.configure(for: promotion, slots: self?.chara?.slots ?? promotion.defaultSlots)
                        }
                    }
                }
        
    }
    
    @objc func saveChara() {
        let values = form.values()
        let json = JSON(values)
        
        chara?.modifiedAt = Date()
        chara?.level = json["unit_level"].int16Value
        chara?.bondRank = json["bond_rank"].int16Value
        chara?.rank = json["unit_rank"].int16Value
        chara?.rarity = json["unit_rarity"].int16Value
        chara?.skillLevel = min(json["unit_level"].int16Value, json["skill_level"].int16Value)
        chara?.enablesUniqueEquipment = json["enables_unique_equipment"].boolValue
        chara?.uniqueEquipmentLevel = json["unique_equipment_level"].int16Value
        chara?.slots = json["slots"].arrayValue.map { $0.boolValue }
        
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
