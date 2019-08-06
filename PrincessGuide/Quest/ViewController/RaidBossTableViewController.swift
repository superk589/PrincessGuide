//
//  RaidBossTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2019/3/31.
//  Copyright © 2019 zzk. All rights reserved.
//

import UIKit
import Gestalt

class RaidBossTableViewController: UITableViewController, DataChecking {
    
    private var enemies = [Enemy]()
    
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
        
        tableView.keyboardDismissMode = .onDrag
        tableView.register(QuestEnemyTableViewCell.self, forCellReuseIdentifier: QuestEnemyTableViewCell.description())
        tableView.estimatedRowHeight = 88
        tableView.rowHeight = UITableView.automaticDimension
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
            Master.shared.getRaidEnemies { (enemies) in
                // preload
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        LoadingHUDManager.default.hide()
                        self?.enemies = enemies.sorted { $0.base.enemyId > $1.base.enemyId }
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
        return enemies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestEnemyTableViewCell.description(), for: indexPath) as! QuestEnemyTableViewCell
        let enemy = enemies[indexPath.row]
        let unit = enemy.unit
        cell.configure(for: [enemy], title: unit.unitName)
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let enemy = enemies[indexPath.row]
        let vc = EDTabViewController(enemy: enemy)
        vc.navigationItem.title = enemy.unit.unitName
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension RaidBossTableViewController: QuestEnemyTableViewCellDelegate {
    
    func questEnemyTableViewCell(_ questEnemyTableViewCell: QuestEnemyTableViewCell, didSelect enemy: Enemy) {
        let vc = EDTabViewController(enemy: enemy)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
