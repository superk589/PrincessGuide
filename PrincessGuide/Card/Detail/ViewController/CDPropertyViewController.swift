//
//  CDPropertyViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class CDPropertyViewController: CDTableViewController {

    override func prepareRows(for card: Card) {
        rows.removeAll()
        rows += [
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                card.maxProperty.item(for: .atk),
                card.maxProperty.item(for: .magicStr)
                ])),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                card.maxProperty.item(for: .def),
                card.maxProperty.item(for: .magicDef)
                ])),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                card.maxProperty.item(for: .hp),
                card.maxProperty.item(for: .physicalCritical)
                ])),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                card.maxProperty.item(for: .dodge),
                card.maxProperty.item(for: .magicCritical)
                ])),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                card.maxProperty.item(for: .waveHpRecovery)
                ])),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                card.maxProperty.item(for: .waveEnergyRecovery)
                ])),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                card.maxProperty.item(for: .lifeSteal)
                ])),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                card.maxProperty.item(for: .hpRecoveryRate)
                ])),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                card.maxProperty.item(for: .energyRecoveryRate)
                ])),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                card.maxProperty.item(for: .energyReduceRate)
                ]))
        ]
    }

}
