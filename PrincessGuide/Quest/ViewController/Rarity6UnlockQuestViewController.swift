//
//  Rarity6UnlockQuestViewController.swift
//  PrincessGuide
//
//  Created by zzk on 9/1/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import UIKit
import Gestalt

class Rarity6UnlockQuestViewController: UITableViewController, DataChecking {
    
    private var quests = [Rarity6UnlockQuest]()
    
    let refresher = RefreshHeader()
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            let navigationBar = themeable.navigationController?.navigationBar
            navigationBar?.tintColor = theme.color.tint
            navigationBar?.barStyle = theme.barStyle
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.refresher.arrowImage.tintColor = theme.color.indicator
            themeable.refresher.loadingView.color = theme.color.indicator
            themeable.tableView.indicatorStyle = theme.indicatorStyle
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateEnd(_:)), name: .preloadEnd, object: nil)
        
        tableView.mj_header = refresher
        refresher.refreshingBlock = { [weak self] in self?.check() }
        
        navigationItem.title = NSLocalizedString("Quests", comment: "")
        
        tableView.keyboardDismissMode = .onDrag
        tableView.register(HatsuneEventTableViewCell.self, forCellReuseIdentifier: HatsuneEventTableViewCell.description())
        tableView.rowHeight = 84
        tableView.estimatedRowHeight = 0
        tableView.tableFooterView = UIView()
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        loadData()
    }
    
    @objc private func handleUpdateEnd(_ notification: NSNotification) {
        loadData()
    }
    
    private func loadData() {
        LoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Master.shared.getRarity6UnlockQuest { quests in
                DispatchQueue.global(qos: .userInitiated).async {
                    quests.forEach { _ = $0.wave?.enemies.last?.enemy }
                    DispatchQueue.main.async {
                        LoadingHUDManager.default.hide()
                        self?.quests = quests.sorted { $0.unitId > $1.unitId }
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HatsuneEventTableViewCell.description(), for: indexPath) as! HatsuneEventTableViewCell
        let quest = quests[indexPath.row]
        
        cell.configure(for: quest.questName, subtitle: "", unitID: quest.unitId + 60)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quest = quests[indexPath.row]
        let vc = QuestEnemyTableViewController(rarity6UnlockQuest: quest)
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.title = quest.questName
        navigationController?.pushViewController(vc, animated: true)
    }
}
