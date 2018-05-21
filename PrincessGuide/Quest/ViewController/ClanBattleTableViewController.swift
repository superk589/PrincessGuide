//
//  ClanBattleTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class ClanBattleTableViewController: UITableViewController, DataChecking {

    private var clanBattles = [ClanBattle]()
    
    let refresher = RefreshHeader()
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            let navigationBar = themable.navigationController?.navigationBar
            navigationBar?.tintColor = theme.color.tint
            navigationBar?.barStyle = theme.barStyle
            themable.backgroundImageView.image = theme.backgroundImage
            themable.refresher.arrowImage.tintColor = theme.color.indicator
            themable.refresher.loadingView.color = theme.color.indicator
            themable.tableView.indicatorStyle = theme.indicatorStyle
            themable.tableView.backgroundColor = theme.color.background
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateEnd(_:)), name: .updateConsoleVariblesEnd, object: nil)
        
        tableView.mj_header = refresher
        refresher.refreshingBlock = { [weak self] in self?.check() }
        
        tableView.keyboardDismissMode = .onDrag
        tableView.register(QuestAreaTableViewCell.self, forCellReuseIdentifier: QuestAreaTableViewCell.description())
        tableView.rowHeight = 66
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
            Master.shared.getClanBattles { (clanBattles) in
                DispatchQueue.main.async {
                    LoadingHUDManager.default.hide()
                    self?.clanBattles = clanBattles.sorted { $0.period.startTime > $1.period.startTime }
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clanBattles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestAreaTableViewCell.description(), for: indexPath) as! QuestAreaTableViewCell
        let clanBattle = clanBattles[indexPath.row]
        cell.configure(for: clanBattle.name)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let clanBattle = clanBattles[indexPath.row]
        let vc = QuestEnemyTableViewController(clanBattle: clanBattle)
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.title = clanBattle.name
        navigationController?.pushViewController(vc, animated: true)
    }

}
