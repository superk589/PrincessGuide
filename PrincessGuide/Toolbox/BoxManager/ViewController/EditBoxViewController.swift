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

class EditBoxViewController: FormViewController {
    
    let box: Box
    
    let context: NSManagedObjectContext
    let parentContext: NSManagedObjectContext
    
    enum Mode {
        case edit
        case create
    }
    
    let mode: Mode
    
    init(box: Box) {
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
        
            +++ Section(NSLocalizedString("Charas", comment: ""))
        
            <<< CharasRow("charas").cellSetup{ [unowned self] (cell, row) in
                cell.selectedBackgroundView = UIView()
                ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
                    themeable.textLabel?.textColor = theme.color.title
                    themeable.detailTextLabel?.textColor = theme.color.tint
                    themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
                    themeable.backgroundColor = theme.color.tableViewCell.background
                }
                cell.configure(for: self.box)
            }
        
            <<< ButtonRow("edit_charas") { (row) in
                row.title = NSLocalizedString("Edit Charas", comment: "")
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
                    let vc = AddCharaToBoxViewController(box: self.box)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
//            +++ MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete], header: NSLocalizedString("Charas", comment: ""), footer: "") {
//                $0.tag = "charas"
//                $0.addButtonProvider = { section in
//                    return ButtonRow() {
//                        $0.title = "Add New Chara"
//                        }.cellUpdate { cell, row in
//                            cell.textLabel?.textAlignment = .left
//                        }.onCellSelection { (cell, row) in
//                            let vc = CharaTableViewController()
//
//                        }
//                    }
//                $0.multivaluedRowToInsertAt = { index in
//                    return NameRow() {
//                        $0.placeholder = "Tag Name"
//                    }
//                }
//                $0 <<< NameRow() {
//                    $0.placeholder = "Tag Name"
//                }
//        }
        
    }

    @objc private func saveBox() {
        
    }
}
