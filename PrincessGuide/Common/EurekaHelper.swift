//
//  Eureka+Helper.swift
//  PrincessGuide
//
//  Created by zzk on 2018/10/17.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Eureka

struct EurekaAppearance {
    
    static func cellUpdate<T: RowType, U>(cell: T.Cell, row: T) where T.Cell.Value == U {
        cell.textLabel?.textColor = Theme.dynamic.color.title
        cell.detailTextLabel?.textColor = Theme.dynamic.color.tint
    }
    
    static func cellSetup<T: RowType, U>(cell: T.Cell, row: T) where T.Cell.Value == U {
        cell.textLabel?.textColor = Theme.dynamic.color.title
        cell.detailTextLabel?.textColor = Theme.dynamic.color.tint
        
        if let segmentedControl = (cell as? SegmentedCell<U>)?.segmentedControl {
            segmentedControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
            segmentedControl.setTitleTextAttributes([.foregroundColor: Theme.dynamic.color.tint], for: .normal)
            segmentedControl.setTitleTextAttributes([.foregroundColor: Theme.dynamic.color.background], for: .selected)
            segmentedControl.selectedSegmentTintColor = Theme.dynamic.color.tint
        }
        if let switchControl = (cell as? SwitchCell)?.switchControl {
            switchControl.onTintColor = Theme.dynamic.color.tint
        }
    }
    
    static func onCellSelection<T>(cell: PickerInlineCell<T>, row: PickerInlineRow<T>) {
        cell.textLabel?.textColor = Theme.dynamic.color.title
        cell.detailTextLabel?.textColor = Theme.dynamic.color.tint
    }
    
    static func onExpandInlineRow<T>(cell: PickerInlineCell<T>, row: PickerInlineRow<T>, pickerRow: PickerRow<T>) {
        pickerRow.cellUpdate { (cell, row) in
            cell.pickerTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.dynamic.color.body]
        }
    }
    
}
