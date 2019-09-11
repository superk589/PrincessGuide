//
//  CraftTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/3.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class CraftTableViewController: UITableViewController {
    
    struct CardRequire {
        let card: Card
        let number: Int
    }
    
    enum Row {
        case summary(Equipment)
        case consume(Craft.Consume)
        case properties([Property.Item])
        case charas([CardRequire])
        case textArray([TextItem])
    }
    
    var equipment: Equipment? {
        didSet {
            if let _ = equipment {
                prepareRows()
                tableView.reloadData()
            }
        }
    }
    
    private var rows = [Row]()
    
    private func prepareRows() {
        rows.removeAll()
        guard let equipment = equipment, let craft = equipment.craft else {
            return
        }
        rows = [Row.summary(equipment)]
        
        rows += craft.consumes.map { Row.consume($0) }
        rows += equipment.property.ceiled().noneZeroProperties().map { Row.properties([$0]) }
        
        let craftCost = equipment.recursiveCraft.reduce(0) { $0 + $1.craftedCost }
        let enhanceCost = equipment.enhanceCost
        rows += [
            Row.textArray([
                TextItem(title: NSLocalizedString("Mana Cost of Crafting", comment: ""), content: String(craftCost), colorMode: .normal)
            ]),
            Row.textArray([
                TextItem(title: NSLocalizedString("Mana Cost of Enhancing", comment: ""), content: String(enhanceCost), colorMode: .normal)
            ])
        ]

        let requires = Preload.default.cards.values
            .map { CardRequire(card: $0, number: $0.countOf(equipment)) }
            .filter { $0.number > 0 }
            .sorted { $0.number > $1.number }
        if requires.count > 0 {
            rows.append(Row.charas(requires))
        }
        rows.append(Row.textArray([
            TextItem(title: NSLocalizedString("Description", comment: ""), content: equipment.description.replacingOccurrences(of: "\\n", with: ""), colorMode: .normal)
        ]))
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.estimatedRowHeight = 84
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(cellType: CraftSummaryTableViewCell.self)
        tableView.register(cellType: CraftTableViewCell.self)
        tableView.register(cellType: CraftCharaTableViewCell.self)
        tableView.register(cellType: CDProfileTableViewCell.self)
        tableView.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = rows[indexPath.row]
        switch row {
        case .consume(let consume):
            if let equipment = consume.equipment {
                if equipment.craftFlg == 0 {
                    DropSummaryTableViewController.configureAsync(equipment: equipment, callback: { [weak self] (vc) in
                        self?.navigationController?.pushViewController(vc, animated: true)
                    })
                } else {
                    let vc = CraftTableViewController()
                    vc.navigationItem.title = equipment.equipmentName
                    vc.equipment = equipment
                    vc.hidesBottomBarWhenPushed = true
                    LoadingHUDManager.default.hide()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = rows[indexPath.row]
        switch row {
        case .charas(let charas):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CraftCharaTableViewCell.self)
            cell.configure(for: charas.map { CraftCharaTableViewCell.Item(number: $0.number, url: $0.card.iconURL()) })
            cell.delegate = self
            return cell
        case .consume(let consume):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CraftTableViewCell.self)
            cell.configure(
                name: consume.equipment?.equipmentName,
                number: consume.consumeNum,
                itemURL: consume.itemURL
            )
            return cell
        case .properties(let properties):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDProfileTableViewCell.self)
            cell.configure(items: properties.map {
                return TextItem(
                    title: $0.key.description,
                    content: String(Int($0.value)),
                    colorMode: .normal
                )
            })
            return cell
        case .summary(let equipment):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CraftSummaryTableViewCell.self)
            cell.configure(for: equipment.recursiveConsumes.map { CraftSummaryTableViewCell.Item(number: $0.consumeNum, url: $0.itemURL) })
            cell.delegate = self
            return cell
        case .textArray(let items):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDProfileTableViewCell.self)
            cell.configure(items: items)
            return cell
        }
    }
    
}

extension CraftTableViewController: CraftSummaryTableViewCellDelegate {
    
    func craftSummaryTableViewCell(_ craftSummaryTableViewCell: CraftSummaryTableViewCell, didSelect index: Int) {
        if let indexPath = tableView.indexPath(for: craftSummaryTableViewCell) {
            let model = rows[indexPath.row]
            guard case .summary(let equipment) = model else {
                return
            }
            DropSummaryTableViewController.configureAsync(equipment: equipment) { [weak self] (vc) in
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension CraftTableViewController: CraftCharaTableViewCellDelegate {
    
    func craftCharaTableViewCell(_ craftCharaTableViewCell: CraftCharaTableViewCell, didSelect index: Int) {
        if let indexPath = tableView.indexPath(for: craftCharaTableViewCell) {
            let model = rows[indexPath.row]
            guard case .charas(let requires) = model else {
                return
            }
            let vc = CDTabViewController(card: requires[index].card)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
