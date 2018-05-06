//
//  CDProfileTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/6.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class CDProfileTableViewController: CDTableViewController {
    
    override func prepareRows(for card: Card) {
        rows = [Row(type: CDBasicTableViewCell.self, data: .card(card.base))]
    }
    
}
