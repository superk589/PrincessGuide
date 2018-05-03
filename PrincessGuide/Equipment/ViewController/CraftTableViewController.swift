//
//  CraftTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/3.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class CraftTableViewController: UITableViewController {
    
    var equipment: Equipment? {
        didSet {
            if let _ = equipment {
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CraftSummaryTableViewCell.self, forCellReuseIdentifier: CraftSummaryTableViewCell.description())
        tableView.register(CraftTableViewCell.self, forCellReuseIdentifier: CraftTableViewCell.description())
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 84
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = equipment?.craft?.consumes.count {
            return count + 1
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let equipment = equipment?.craft?.consumes[indexPath.row - 1].equipment {
            if equipment.craftFlg == 0 {
                QuestTableViewController.configureAsync(equipment: equipment, callback: { [weak self] (vc) in
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
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let equipment = equipment, let craft = equipment.craft else {
            fatalError()
        }
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CraftSummaryTableViewCell.description(), for: indexPath) as! CraftSummaryTableViewCell
            cell.configure(for: equipment)
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CraftTableViewCell.description(), for: indexPath) as! CraftTableViewCell
            cell.configure(for: craft.consumes[indexPath.row - 1])
            return cell
        }
    }
    
}

extension CraftTableViewController: CraftSummaryTableViewCellDelegate {
    
    func craftSummaryTableViewCell(_ craftSummaryTableViewCell: CraftSummaryTableViewCell, didSelect consume: Craft.Consume) {
        if let equipment = consume.equipment {
            QuestTableViewController.configureAsync(equipment: equipment) { [weak self] (vc) in
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
