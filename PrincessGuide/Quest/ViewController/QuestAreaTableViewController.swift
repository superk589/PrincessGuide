//
//  QuestAreaTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class QuestAreaTableViewController: UITableViewController {
    
    private var areas = [Area]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("Quest", comment: "")
        
        tableView.keyboardDismissMode = .onDrag
        tableView.register(QuestAreaTableViewCell.self, forCellReuseIdentifier: QuestAreaTableViewCell.description())
        tableView.estimatedRowHeight = 84
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        loadData()
    }
    
    private func loadData() {
        LoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Master.shared.getAreas(callback: { (areas) in
                DispatchQueue.main.async {
                    LoadingHUDManager.default.hide()
                    self?.areas = areas
                    self?.tableView.reloadData()
                }
            })
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestAreaTableViewCell.description(), for: indexPath) as! QuestAreaTableViewCell
        
        cell.configure(for: areas[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let area = areas[indexPath.row]
        let vc = QuestTableViewController()
        vc.quest = area.quests
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
