//
//  EditBoxViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/5.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import CoreData
import Eureka
import Gestalt
import SwiftyJSON

class EditBoxViewController: FormViewController {
 
    let box: Box
    
    let context: NSManagedObjectContext
    let parentContext: NSManagedObjectContext?
    
    enum Mode {
        case edit
        case create
    }
    
    let mode: Mode
    
    init(box: Box) {
        mode = .edit
        context = box.managedObjectContext ?? CoreDataStack.default.viewContext
        self.parentContext = nil
        self.box = box
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        mode = .create
        parentContext = CoreDataStack.default.viewContext
        context = CoreDataStack.default.newChildContext(parent: CoreDataStack.default.viewContext)
        box = Box(context: context)
        box.name = ""
        box.modifiedAt = Date()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let backgroundImageView = UIImageView()
    
    private lazy var navigationAccessoryView = NavigationAccessoryView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44.0))
    
    override var customNavigationAccessoryView: (UIView & NavigationAccessory)? {
        return navigationAccessoryView
    }

    lazy var saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAndPop))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Edit Box", comment: "")

        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        navigationItem.rightBarButtonItem = saveItem
        
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            let navigationBar = themeable.navigationController?.navigationBar
            navigationBar?.tintColor = theme.color.tint
            navigationBar?.barStyle = theme.barStyle
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.tableView.indicatorStyle = theme.indicatorStyle
            themeable.tableView.backgroundColor = theme.color.background
            themeable.view.tintColor = theme.color.tint
            themeable.navigationAccessoryView.barStyle = theme.barStyle
            themeable.navigationAccessoryView.tintColor = theme.color.tint
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
            +++ Section(NSLocalizedString("General", comment: ""))
        
            <<< TextRow("name") {
                $0.title = NSLocalizedString("Box Name", comment: "")
                $0.placeholder = NSLocalizedString("Enter Name", comment: "")
                if mode == .create {
                    $0.value = NSLocalizedString("", comment: "")
                } else {
                    $0.value = box.name
                }
//                $0.add(rule: RuleMaxLength(maxLength: 16, msg: NSLocalizedString("max 16 characters", comment: "")))
                }.cellSetup { (cell, row) in
                    cell.selectedBackgroundView = UIView()
                    ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
                        themeable.textLabel?.textColor = theme.color.title
                        themeable.detailTextLabel?.textColor = theme.color.tint
                        themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
                        themeable.backgroundColor = theme.color.tableViewCell.background
                        themeable.textField.textColor = theme.color.tint
                        themeable.textField.keyboardAppearance = theme.keyboardAppearance
                    }
                    ThemeManager.default.apply(theme: Theme.self, to: row) { (themeable, theme) in
                        themeable.placeholderColor = theme.color.lightText
                    }
                }
                .cellUpdate { (cell, row) in
                    ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
                        themeable.textLabel?.textColor = theme.color.title
                        themeable.detailTextLabel?.textColor = theme.color.tint
                        themeable.textField.textColor = theme.color.tint
                    }
                }
                .onChange { [weak self] (row) in
                    if self?.mode == .edit {
                        self?.saveBox()
                    }
                }
        
//            <<< ButtonRow("save_box") { (row) in
//                row.title = NSLocalizedString("Save Box", comment: "")
//                }
//                .cellSetup { (cell, row) in
//                    cell.selectedBackgroundView = UIView()
//                    ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
//                        themeable.textLabel?.textColor = theme.color.title
//                        themeable.detailTextLabel?.textColor = theme.color.tint
//                        themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
//                        themeable.backgroundColor = theme.color.tableViewCell.background
//                    }
//                }
//                .onCellSelection { [unowned self] (cell, row) in
//                    self.saveBox()
//                }
            
            +++ Section(NSLocalizedString("Charas", comment: "")) { [unowned self] in
                $0.tag = "charas_section"
                if self.mode == .edit {
                    $0.footer = HeaderFooterView(title: NSLocalizedString("The first chara added will be used as cover image.", comment: ""))
                }
            }
            
            <<< ButtonRow("select_charas") { (row) in
                row.title = NSLocalizedString("Select Charas", comment: "")
                }
                .cellSetup(cellSetup(cell:row:))
                .onCellSelection { [unowned self] (cell, row) in
                    let vc = AddCharaToBoxViewController(box: self.box, parentContext: self.context)
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
            }
            
            <<< ButtonRow("import_charas") { (row) in
                row.title = NSLocalizedString("Import All Charas", comment: "")
                row.hidden = Condition.function([]) {[weak self] form in
                    return self?.mode == .edit
                }
                }
                .cellSetup(cellSetup(cell:row:))
                .onCellSelection { [unowned self] (cell, row) in
                    Array(Preload.default.cards.values).sorted(settings: CardSortingViewController.Setting.default).forEach {
                        let chara = Chara(context: self.context)
                        
                        chara.modifiedAt = Date()
                        chara.level = Int16(Preload.default.maxPlayerLevel)
                        chara.bondRank = Int16(Constant.presetMaxPossibleBondRank)
                        chara.rank = Int16(Preload.default.maxEquipmentRank)
                        chara.rarity = Int16(Constant.presetMaxPossibleRarity)
                        chara.skillLevel = Int16(Preload.default.maxPlayerLevel)
                        chara.id = Int32($0.base.unitId)
                        chara.uniqueEquipmentLevel = Int16(Preload.default.maxUniqueEquipmentLevel)
                        chara.enablesUniqueEquipment = $0.uniqueEquipIDs.count > 0
                        chara.slots = $0.promotions.last?.defaultSlots ?? [Bool](repeating: false, count: 6)
                        self.box.addToCharas(chara)
                    }
                    
                    let charasRow = self.form.rowBy(tag: "charas") as? CharasRow
                    charasRow?.cell.configure(for: self.box)
                    charasRow?.reload()
                    
                    row.disabled = Condition.function([]) { (form) -> Bool in
                        return true
                    }
                    row.evaluateDisabled()
                    
            }
            
            <<< ButtonRow("batch_edit") { (row) in
                row.title = NSLocalizedString("Batch Edit", comment: "")
                }
                .cellSetup(cellSetup(cell:row:))
                .onCellSelection { [unowned self] (cell, row) in
                    let vc = BatchEditCharaInBoxViewController(charas: self.box.charas?.array as? [Chara] ?? [], parentContext: self.context)
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
            }
            
            <<< CharasRow("charas").cellSetup{ [unowned self] (cell, row) in
                cell.selectedBackgroundView = UIView()
                ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
                    themeable.textLabel?.textColor = theme.color.title
                    themeable.detailTextLabel?.textColor = theme.color.tint
                    themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
                    themeable.backgroundColor = theme.color.tableViewCell.background
                }
                cell.configure(for: self.box)
                cell.delegate = self
            }
        
    }
    
    func saveBox() {
        let json = JSON(form.values())
        box.modifiedAt = Date()
        box.name = json["name"].stringValue
        do {
            try context.save()
            try parentContext?.save()
        } catch (let error) {
            print(error)
        }
    }

    @objc private func saveAndPop() {
        saveBox()
        navigationController?.popViewController(animated: true)
    }
    
}

extension EditBoxViewController: AddCharaToBoxViewControllerDelegate {
    
    func addCharaToBoxViewControllerDidSave(_ addCharaToBoxViewController: AddCharaToBoxViewController) {
        let row = form.rowBy(tag: "charas") as? CharasRow
        row?.cell.configure(for: box)
        row?.reload()
        if mode == .edit {
            saveBox()
        }
    }
}

extension EditBoxViewController: CharasCellDelegate {
    
    func charasCell(_ charasCell: CharasCell, didSelect chara: Chara) {
        let vc = EditCharaInBoxViewController(chara: chara)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func charasCell(_ charasCell: CharasCell, move fromIndex: Int, to toIndex: Int) {
        guard var charas = box.charas?.array else {
            return
        }
        let source = charas.remove(at: fromIndex)
        charas.insert(source, at: toIndex)
        box.charas = NSOrderedSet(array: charas)
        if mode == .edit {
            saveBox()
        }
    }
    
}

extension EditBoxViewController: EditCharaInBoxViewControllerDelegate {
    
    func editCharaInBoxViewController(_ editCharaInBoxViewController: EditCharaInBoxViewController, didSave chara: Chara) {
        let row = form.rowBy(tag: "charas") as? CharasRow
        row?.cell.configure(for: box)
        row?.reload()
        if mode == .edit {
            saveBox()
        }
    }
    
}

extension EditBoxViewController: BatchEditCharaInBoxViewControllerDelegate {
    
    func batchEditCharaInBoxViewController(_ batchEditCharaInBoxViewController: BatchEditCharaInBoxViewController, didSave charas: [Chara]) {
        let row = form.rowBy(tag: "charas") as? CharasRow
        row?.cell.configure(for: box)
        row?.reload()
        if mode == .edit {
            saveBox()
        }
    }
    
}
