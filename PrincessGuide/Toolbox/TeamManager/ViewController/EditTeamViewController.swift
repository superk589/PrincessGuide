//
//  EditTeamViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/10.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import CoreData
import Eureka
import Gestalt
import SwiftyJSON

class EditTeamViewController: FormViewController {
    
    let team: Team
    
    let context: NSManagedObjectContext
    let parentContext: NSManagedObjectContext?
    
    enum Mode {
        case edit
        case create
    }
    
    let mode: Mode
    
    init(cards: [Card]) {
        mode = .create
        context = CoreDataStack.default.newChildContext(parent: CoreDataStack.default.viewContext)
        team = Team(context: context)
        parentContext = CoreDataStack.default.viewContext
        super.init(nibName: nil, bundle: nil)
        cards.forEach {
            let member = Member(card: $0, context: context)
            team.addToMembers(member)
        }
    }
    
    init(team: Team) {
        mode = .edit
        parentContext = nil
        context = team.managedObjectContext ?? CoreDataStack.default.viewContext
        self.team = team
        super.init(nibName: nil, bundle: nil)
    }
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Edit Team", comment: "")
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAndPop(_:)))
        
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
                $0.title = NSLocalizedString("Custom Tag", comment: "")
                $0.placeholder = NSLocalizedString("Enter Tag", comment: "")
                if mode == .create {
                    $0.value = NSLocalizedString("", comment: "")
                } else {
                    $0.value = team.name
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
                        self?.saveTeam()
                    }
            }
            
            <<< PickerInlineRow<String>("tag") { (row : PickerInlineRow<String>) -> Void in
                row.title = NSLocalizedString("Tag", comment: "")
                row.displayValueFor = { (rowValue: String?) in
                    return rowValue.flatMap { Team.Tag(rawValue: $0)?.description }
                }
                row.options = Team.Tag.allLabels.map { $0.rawValue }
                if mode == .create {
                    row.value = Team.Tag.pvp.description
                } else {
                    row.value = team.tag
                }
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onCellSelection(onCellSelection(cell:row:))
                .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))
                .onChange { [weak self] (row) in
                    if self?.mode == .edit {
                        self?.saveTeam()
                    }
            }
        
            <<< PickerInlineRow<String>("mark") { (row : PickerInlineRow<String>) -> Void in
                row.title = NSLocalizedString("Mark", comment: "")
                row.displayValueFor = { (rowValue: String?) in
                    return rowValue.flatMap { Team.Mark(rawValue: $0)?.description }
                }
                row.options = Team.Mark.allLabels.map { $0.rawValue }
                if mode == .create {
                    row.value = Team.Mark.attack.description
                } else {
                    row.value = team.mark
                }
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onCellSelection(onCellSelection(cell:row:))
                .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))
                .onChange { [weak self] (row) in
                    if self?.mode == .edit {
                        self?.saveTeam()
                    }
            }
        
            <<< ButtonRow("select_wins") { (row) in
                row.title = NSLocalizedString("Select Wins", comment: "")
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
                    let vc = SearchableAddTeamToTeamViewController(team: self.team, parentContext: self.context, mode: .win)
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
            }
        
            <<< ButtonRow("select_loses") { (row) in
                row.title = NSLocalizedString("Select Loses", comment: "")
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
                    let vc = SearchableAddTeamToTeamViewController(team: self.team, parentContext: self.context, mode: .lose)
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
            }
        
        let members = team.members?.allObjects as? [Member] ?? []
        let sortedMembers = members.sorted { ($0.card?.base.searchAreaWidth ?? .min) < ($1.card?.base.searchAreaWidth ?? .min) }
        
        sortedMembers.enumerated().forEach {
            let offset = $0.offset
            let member = $0.element
            
            form
                +++ Section() {
                    if offset == 0 {
                        $0.header = HeaderFooterView(title: NSLocalizedString("Members", comment: ""))
                    }
                }
            
                <<< ImageRow(tag: "image_\(offset)")
                    .cellSetup { (cell, row) in
                        if let card = member.card {
                            cell.configure(for: card)
                        }
                    }
                    .cellUpdate(cellUpdate(cell:row:))
                
                <<< PickerInlineRow<Int>("unit_level_\(offset)") { (row : PickerInlineRow<Int>) -> Void in
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
                        row.value = Int(member.level)
                    }
                    }.cellSetup(cellSetup(cell:row:))
                    .cellUpdate(cellUpdate(cell:row:))
                    .onCellSelection(onCellSelection(cell:row:))
                    .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))
                    .onChange { [weak self] (row) in
                        if self?.mode == .edit {
                            self?.saveTeam()
                        }
                    }
                        
                <<< PickerInlineRow<Int>("unit_rarity_\(offset)") { (row : PickerInlineRow<Int>) -> Void in
                    row.title = NSLocalizedString("Star Rank", comment: "")
                    row.displayValueFor = { (rowValue: Int?) in
                        return rowValue.flatMap { String($0) }
                    }
                    row.options = []
                    for i in 0..<Constant.presetMaxRarity {
                        row.options.append(i + 1)
                    }
                    if mode == .create {
                        row.value = Constant.presetMaxRarity
                    } else {
                        row.value = Int(member.rarity)
                    }
                    }.cellSetup(cellSetup(cell:row:))
                    .cellUpdate(cellUpdate(cell:row:))
                    .onCellSelection(onCellSelection(cell:row:))
                    .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))
                    .onChange { [weak self] (row) in
                        if self?.mode == .edit {
                            self?.saveTeam()
                        }
                    }
            
            }
            
    }
    
    private func saveTeam() {
        let members = team.members?.allObjects as? [Member] ?? []
        let sortedMembers = members.sorted { ($0.card?.base.searchAreaWidth ?? .min) < ($1.card?.base.searchAreaWidth ?? .min) }
        let values = form.values()
        let json = JSON(values)
        sortedMembers.enumerated().forEach { (offset, member) in
            member.level = json["unit_level_\(offset)"].int16Value
            member.rarity = json["unit_rarity_\(offset)"].int16Value
        }
        
        team.modifiedAt = Date()
        team.mark = json["mark"].stringValue
        team.tag = json["tag"].stringValue
        team.name = json["name"].stringValue
        
        do {
            try context.save()
        } catch(let error) {
            print(error)
        }
        
    }
    
    func didSave() {
        do {
            try parentContext?.save()
        } catch(let error) {
            print(error)
        }
        if let vc = navigationController?.viewControllers[1] {
            navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    @objc private func saveAndPop(_ item: UIBarButtonItem) {
        saveTeam()
        didSave()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

extension EditTeamViewController: AddTeamToTeamViewControllerDelegate {
    func addTeamToTeamViewControllerDidSave(_ addTeamToTeamViewController: AddTeamToTeamViewController) {
        if mode == .edit {
            saveTeam()
        }
    }
}
