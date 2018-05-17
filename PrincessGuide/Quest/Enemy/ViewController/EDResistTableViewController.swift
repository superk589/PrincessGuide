//
//  EDResistTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/17.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class EDResistTableViewController: EDTableViewController {

    override func prepareRows() {
        rows.removeAll()
        let items = enemy.resist?.items ?? []
        rows += items.map {
            Row(type: EDProfileTextTableViewCell.self, data: .text($0.ailment.description, String($0.rate)))
        }
        
    }

}
