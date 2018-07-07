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

class EditBoxViewController: FormViewController, BoxDetailConfigurable {
    
    let box: Box
    
    let context: NSManagedObjectContext
    let parentContext: NSManagedObjectContext
    
    enum Mode {
        case edit
        case create
    }
    
    let mode: Mode
    
    required init(box: Box) {
        mode = .edit
        parentContext = CoreDataStack.default.viewContext
        context = CoreDataStack.default.newChildContext(parent: parentContext)
        self.box = context.object(with: box.objectID) as! Box
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        mode = .create
        parentContext = CoreDataStack.default.viewContext
        context = CoreDataStack.default.newChildContext(parent: parentContext)
        box = Box(context: context)
        box.modifiedAt = Date()
        box.name = NSLocalizedString("My Box", comment: "")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Edit Box", comment: "")

        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBox))
        
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
        
        form.inlineRowHideOptions = InlineRowHideOptions.AnotherInlineRowIsShown.union(.FirstResponderChanges)
        
        form
            +++ Section(NSLocalizedString("General", comment: ""))
        
            <<< TextRow("name") {
                $0.title = NSLocalizedString("Box Name", comment: "")
                if mode == .create {
                    $0.value = NSLocalizedString("My Box", comment: "")
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
                }
                .cellUpdate { (cell, row) in
                    ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
                        themeable.textLabel?.textColor = theme.color.title
                        themeable.detailTextLabel?.textColor = theme.color.tint
                        themeable.textField.textColor = theme.color.tint
                    }
                }
        
            <<< ButtonRow("save_box") { (row) in
                row.title = NSLocalizedString("Save Box", comment: "")
                }
                .cellSetup { (cell, row) in
                    cell.selectedBackgroundView = UIView()
                    ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
                        themeable.textLabel?.textColor = theme.color.title
                        themeable.detailTextLabel?.textColor = theme.color.tint
                        themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
                        themeable.backgroundColor = theme.color.tableViewCell.background
                    }
                }
                .onCellSelection { [unowned self] (cell, row) in
                    self.saveBox()
                }
            
            +++ Section(NSLocalizedString("Charas", comment: ""))
            
            <<< ButtonRow("select_charas") { (row) in
                row.title = NSLocalizedString("Select Charas", comment: "")
                }
                .cellSetup { (cell, row) in
                    cell.selectedBackgroundView = UIView()
                    ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
                        themeable.textLabel?.textColor = theme.color.title
                        themeable.detailTextLabel?.textColor = theme.color.tint
                        themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
                        themeable.backgroundColor = theme.color.tableViewCell.background
                    }
                }
                .onCellSelection { [unowned self] (cell, row) in
                    let vc = AddCharaToBoxViewController(box: self.box, parentContext: self.context)
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
            }
            
            <<< ButtonRow("batch_edit") { (row) in
                row.title = NSLocalizedString("Batch Edit", comment: "")
                }
                .cellSetup { (cell, row) in
                    cell.selectedBackgroundView = UIView()
                    ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
                        themeable.textLabel?.textColor = theme.color.title
                        themeable.detailTextLabel?.textColor = theme.color.tint
                        themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
                        themeable.backgroundColor = theme.color.tableViewCell.background
                    }
                }
                .onCellSelection { [unowned self] (cell, row) in
                    let vc = BatchEditCharaInBoxViewController(charas: self.box.charas?.allObjects as? [Chara] ?? [], parentContext: self.context)
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

    @objc private func saveBox() {
        let json = JSON(form.values())
        box.modifiedAt = Date()
        box.name = json["name"].stringValue
        do {
            try context.save()
            try parentContext.save()
        } catch (let error) {
            print(error)
        }
        navigationController?.popViewController(animated: true)
    }
}

extension EditBoxViewController: AddCharaToBoxViewControllerDelegate {
    
    func addCharaToBoxViewControllerDidSave(_ addCharaToBoxViewController: AddCharaToBoxViewController) {
        let row = form.rowBy(tag: "charas") as? CharasRow
        row?.cell.configure(for: box)
        row?.reload()
    }
}

extension EditBoxViewController: CharasCellDelegate {
    
    func charasCell(_ charasCell: CharasCell, didSelect chara: Chara) {
        let vc = EditCharaInBoxViewController(chara: chara)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension EditBoxViewController: EditCharaInBoxViewControllerDelegate {
    
    func editCharaInBoxViewController(_ editCharaInBoxViewController: EditCharaInBoxViewController, didSave chara: Chara) {
        let row = form.rowBy(tag: "charas") as? CharasRow
        row?.cell.configure(for: box)
        row?.reload()
    }
    
}

extension EditBoxViewController: BatchEditCharaInBoxViewControllerDelegate {
    
    func batchEditCharaInBoxViewController(_ batchEditCharaInBoxViewController: BatchEditCharaInBoxViewController, didSave charas: [Chara]) {
        let row = form.rowBy(tag: "charas") as? CharasRow
        row?.cell.configure(for: box)
        row?.reload()
    }
    
}
