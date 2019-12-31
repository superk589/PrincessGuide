//
//  EDResistTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/17.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class EDResistTableViewController: UITableViewController {
    
    struct Row {
        var items: [TextItem]
    }
    
    struct Section {
        var rows: [Row]
        var title: String
    }
    
    var sections = [Section]()
    
    let enemy: Enemy
    
    init(enemy: Enemy) {
        self.enemy = enemy
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadAll() {
        navigationItem.title = enemy.base.name
        prepareRows()
        tableView.reloadData()
    }
        
    func prepareRows() {
        sections.removeAll()
        let items = enemy.resist?.items ?? []
        sections.append(
            Section(
                rows: items
                    .filter { $0.ailment.ailmentType == .action }
                    .map { TextItem(title: $0.ailment.description, content: String($0.rate) + "%", colorMode: .normal) }
                    .chunks(size: 2)
                    .map { Row(items: $0) },
                title: NSLocalizedString("Control", comment: "")
            )
        )
        sections.append(
            Section(
                rows: items
                    .filter { $0.ailment.ailmentType == .dot }
                    .map { TextItem(title: $0.ailment.description, content: String($0.rate) + "%", colorMode: .normal) }
                    .chunks(size: 2)
                    .map { Row(items: $0) },
                title: NSLocalizedString("Damage Over Time", comment: "")
            )
        )
        sections.append(
            Section(
                rows: items
                    .filter { $0.ailment.ailmentType != .action && $0.ailment.ailmentType != .dot }
                    .map { TextItem(title: $0.ailment.description, content: String($0.rate) + "%", colorMode: .normal) }
                    .chunks(size: 2)
                    .map { Row(items: $0) },
                title: NSLocalizedString("Special Effect", comment: "")
            )
        )
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.register(cellType: CDProfileTableViewCell.self)
        reloadAll()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [weak self] (context) in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
            }, completion: nil)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sections[indexPath.section].rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDProfileTableViewCell.self)
        cell.configure(items: row.items)
        return cell
    }
}
