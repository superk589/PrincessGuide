//
//  DropSummaryTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class DropSummaryTableViewController: UITableViewController {
    
    static func configureAsync(equipment: Equipment, callback: @escaping (DropSummaryTableViewController) -> Void) {
        LoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async {
            Master.shared.getQuests(containsEquipment: equipment.equipmentId) { quests in
                DispatchQueue.main.async {
                    let subQuests = quests.sorted { $0.allRewards.first { $0.rewardID == equipment.equipmentId }!.odds > $1.allRewards.first { $0.rewardID == equipment.equipmentId }!.odds }
                    let vc = DropSummaryTableViewController(quests: subQuests)
                    vc.navigationItem.title = equipment.equipmentName
                    vc.hidesBottomBarWhenPushed = true
                    vc.focusedItemID = equipment.equipmentId
                    LoadingHUDManager.default.hide()
                    callback(vc)
                }
            }
        }
    }

    let quests: [Quest]
    
    init(quests: [Quest]) {
        self.quests = quests
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var focusedItemID: Int? {
        didSet {
            tableView.reloadData()
        }
    }
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.tableView.indicatorStyle = theme.indicatorStyle
        }
        
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 305
        tableView.rowHeight = UITableView.automaticDimension
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.register(DropSummaryTableViewCell.self, forCellReuseIdentifier: DropSummaryTableViewCell.description())
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [weak self] (context) in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
        }, completion: nil)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DropSummaryTableViewCell.description(), for: indexPath) as! DropSummaryTableViewCell
        cell.configure(for: quests[indexPath.row], focusedID: focusedItemID)
        return cell
    }
    
}
