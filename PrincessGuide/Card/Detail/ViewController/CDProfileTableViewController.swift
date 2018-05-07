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
        rows = [
            Row(type: CDBasicTableViewCell.self, data: .card(card.base)),
            Row(type: CDProfileTableViewCell.self, data: .profile([
                card.profile.item(for: .height),
                card.profile.item(for: .weight)
            ])),
            Row(type: CDProfileTableViewCell.self, data: .profile([
                card.profile.item(for: .birthday),
                card.profile.item(for: .blood)
            ])),
            Row(type: CDProfileTableViewCell.self, data: .profile([
                card.profile.item(for: .race)
            ])),
            Row(type: CDProfileTableViewCell.self, data: .profile([
                card.profile.item(for: .guild)
            ])),
            Row(type: CDProfileTableViewCell.self, data: .profile([
                card.profile.item(for: .favorite)
            ])),
            Row(type: CDProfileTableViewCell.self, data: .profile([
                card.profile.item(for: .voice)
            ])),
        ]
    }
    
}
