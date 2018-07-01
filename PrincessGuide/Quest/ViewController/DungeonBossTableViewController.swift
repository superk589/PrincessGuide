//
//  DungeonBossTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/6/14.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class DungeonBossTableViewController: UITableViewController, DataChecking {
    
    private var dungeons = [Dungeon]()
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateEnd(_:)), name: .updateConsoleVariblesEnd, object: nil)
        
        tableView.mj_header = refresher
        refresher.refreshingBlock = { [weak self] in self?.check() }
        
        tableView.keyboardDismissMode = .onDrag
        tableView.register(HatsuneEventTableViewCell.self, forCellReuseIdentifier: HatsuneEventTableViewCell.description())
        tableView.rowHeight = 84
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
            Master.shared.getDungeons { (dungeons) in
                // preload
                DispatchQueue.global(qos: .userInitiated).async {
                    dungeons.forEach { _ = $0.wave?.enemies.first?.enemy }
                    DispatchQueue.main.async {
                        LoadingHUDManager.default.hide()
                        self?.dungeons = dungeons.sorted { $0.dungeonAreaId > $1.dungeonAreaId }
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
        return dungeons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HatsuneEventTableViewCell.description(), for: indexPath) as! HatsuneEventTableViewCell
        let dungeon = dungeons[indexPath.row]
        let unit = dungeon.wave?.enemies.first?.enemy?.unit
        cell.configure(for: "\(unit?.unitName ?? "")", subtitle: dungeon.dungeonName, unitID: unit?.prefabId)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dungeon = dungeons[indexPath.row]
        
        /* debug */
        /*
        let enemy = DispatchSemaphore.sync { (closure) in
            Master.shared.getEnemies(enemyID: 501010401, callback: closure)
        }?.first
        if let enemy = enemy {
            let vc = EDTabViewController(enemy: enemy)
            vc.hidesBottomBarWhenPushed = true
            vc.navigationItem.title = enemy.unit.unitName
            navigationController?.pushViewController(vc, animated: true)
        }
         */
        
        if let enemy = dungeon.wave?.enemies.first?.enemy {
            let vc = EDTabViewController(enemy: enemy)
            vc.hidesBottomBarWhenPushed = true
            vc.navigationItem.title = enemy.unit.unitName
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
