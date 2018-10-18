//
//  Eureka+Helper.swift
//  PrincessGuide
//
//  Created by zzk on 2018/10/17.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Eureka
import Gestalt

struct EurekaAppearance {
    
    static func cellUpdate<T: RowType, U>(cell: T.Cell, row: T) where T.Cell.Value == U {
        ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
            themeable.textLabel?.textColor = theme.color.title
            themeable.detailTextLabel?.textColor = theme.color.tint
        }
    }
    
    static func cellSetup<T: RowType, U>(cell: T.Cell, row: T) where T.Cell.Value == U {
        cell.selectedBackgroundView = UIView()
        ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
            themeable.textLabel?.textColor = theme.color.title
            themeable.detailTextLabel?.textColor = theme.color.tint
            themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.backgroundColor = theme.color.tableViewCell.background
            if let segmentedControl = (themeable as? SegmentedCell<U>)?.segmentedControl {
                segmentedControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
            }
            if let switchControl = (themeable as? SwitchCell)?.switchControl {
                switchControl.onTintColor = theme.color.tint
            }
        }
    }
    
    static func onCellSelection<T>(cell: PickerInlineCell<T>, row: PickerInlineRow<T>) {
        ThemeManager.default.apply(theme: Theme.self, to: cell) { (themeable, theme) in
            themeable.textLabel?.textColor = theme.color.title
            themeable.detailTextLabel?.textColor = theme.color.tint
        }
    }
    
    static func onExpandInlineRow<T>(cell: PickerInlineCell<T>, row: PickerInlineRow<T>, pickerRow: PickerRow<T>) {
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
    
}
