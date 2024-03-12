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
        rows.removeAll()
        rows += [
            Row.card(card),
            Row.sameUnit(card.sameUnits),
            Row.textArray([
                TextItem(title: NSLocalizedString("True Name", comment: ""), content: card.actualUnit?.unitName ?? NSLocalizedString("None", comment: ""), colorMode: .normal)
            ]),
            Row.textArray([
                TextItem(title: NSLocalizedString("Catch Copy", comment: ""), content: card.profile.catchCopy, colorMode: .normal)
            ]),
            Row.profileItems([
                card.profile.item(for: .height),
                card.profile.item(for: .weight)
            ]),
            Row.profileItems([
                card.profile.item(for: .birthday),
                card.profile.item(for: .blood)
            ]),
            Row.profileItems([
                card.profile.item(for: .race),
                card.profile.item(for: .age)
            ]),
            Row.profileItems([
                card.profile.item(for: .guild)
            ]),
            Row.profileItems([
                card.profile.item(for: .favorite)
            ]),
            Row.profileItems([
                card.profile.item(for: .voice)
            ])
        ]
        
        rows += card.comments.map { Row.comment($0) }
    }
    
}
