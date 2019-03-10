//
//  HatsuneEventAreaTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/17.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class HatsuneEventAreaTableViewController: UITableViewController, DataChecking {
    
    private var events = [HatsuneEvent]()
    
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
            Master.shared.getHatsuneEvents { (events) in
                // preload
                DispatchQueue.global(qos: .userInitiated).async {
                    events.forEach { _ = $0.quests.first?.wave?.enemies.first?.enemy }
                    DispatchQueue.main.async {
                        LoadingHUDManager.default.hide()
                        self?.events = events.sorted { $0.base.startTime > $1.base.startTime }
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
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HatsuneEventTableViewCell.description(), for: indexPath) as! HatsuneEventTableViewCell
        let event = events[indexPath.row]
        let unit = event.quests.first?.wave?.enemies.first?.enemy?.unit
        cell.configure(for: "\(unit?.unitName ?? "")", subtitle: event.base.title, unitID: unit?.prefabId)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        let vc = QuestEnemyTableViewController(hatsuneEvent: event)
        vc.hidesBottomBarWhenPushed = true
        let unit = event.quests.first?.wave?.enemies.first?.enemy?.unit
        vc.navigationItem.title = unit?.unitName
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
