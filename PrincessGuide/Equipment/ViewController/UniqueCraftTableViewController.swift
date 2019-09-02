//
//  UniqueCraftTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/11/27.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class UniqueCraftTableViewController: UITableViewController {
    
    enum Row {
        case summary(UniqueEquipment)
        case consume(UniqueCraft.Consume)
        case properties([Property.Item])
        case textArray([TextItem])
    }
    
    var equipment: UniqueEquipment? {
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
        rows += equipment.property().ceiled().noneZeroProperties().map { Row.properties([$0]) }
        
        rows.append(Row.textArray([
            TextItem(title: NSLocalizedString("Description", comment: ""), content: equipment.description.replacingOccurrences(of: "\\n", with: ""), colorMode: .normal)
        ]))
    }
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.tableView.indicatorStyle = theme.indicatorStyle
        }
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.estimatedRowHeight = 84
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(cellType: CraftSummaryTableViewCell.self)
        tableView.register(cellType: CraftTableViewCell.self)
        tableView.register(cellType: CraftCharaTableViewCell.self)
        tableView.register(cellType: CDProfileTableViewCell.self)
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        switch row {
        case .consume(let consume):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CraftTableViewCell.self)
            cell.configure(
                name: "",
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
            return cell
        case .textArray(let items):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDProfileTableViewCell.self)
            cell.configure(items: items)
            return cell
        }
    }
    
}
