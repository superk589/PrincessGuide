//
//  CDPromotionTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/6.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class CDPromotionTableViewController: CDTableViewController {

    override func prepareRows(for card: Card) {
    
        rows = [Row(type: CDPromotionTableViewCell.self, data: .uniqueEquipments(card.uniqueEquipIDs))]

        rows += card.promotions.map { Row(type: CDPromotionTableViewCell.self, data: .promotion($0)) }.reversed()
    }
    
}
