//
//  TrialBattleViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2022/5/18.
//  Copyright © 2022 zzk. All rights reserved.
//

import UIKit

class TrialBattleViewController: UITableViewController, DataChecking {
    
    private var quests = [TrialQuest]()
    
    let refresher = RefreshHeader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateEnd(_:)), name: .preloadEnd, object: nil)
        
        tableView.mj_header = refresher
        refresher.refreshingBlock = { [weak self] in self?.check() }
        
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
            Master.shared.getTrialQeusts(callback: { quests in
                // preload
                DispatchQueue.global(qos: .userInitiated).async {
                    quests.forEach { _ = $0.battles.last?.wave?.enemies.first?.enemy }
                    DispatchQueue.main.async {
                        LoadingHUDManager.default.hide()
                        self?.quests = quests.sorted { $0.categoryId < $1.categoryId }
                        self?.tableView.reloadData()
                    }
                }
            })
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
        let unit = quest.battles.last?.wave?.enemies.first?.enemy?.unit
        cell.configure(for: "\(unit?.unitName ?? "")", subtitle: quest.description, unitID: unit?.prefabId)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quest = quests[indexPath.row]
        let vc = QuestEnemyTableViewController(trialBattles: quest.battles)
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.title = quest.battles.last?.wave?.enemies.first?.enemy?.unit.unitName
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
