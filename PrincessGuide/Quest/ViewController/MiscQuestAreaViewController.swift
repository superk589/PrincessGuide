//
//  MiscQuestAreaViewController.swift
//  PrincessGuide
//
//  Created by zzk on 8/31/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import UIKit
import Gestalt

class MiscQuestAreaTableViewController: UITableViewController, DataChecking {
    
    private var areas = [Area]()
    
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
            let explorations = DispatchSemaphore.sync({ closure in
                Master.shared.getAreas(type: .exploration, callback: closure)
            }) ?? []
            let shrines = DispatchSemaphore.sync({ closure in
                Master.shared.getAreas(type: .shrine, callback: closure)
            }) ?? []
            let temples = DispatchSemaphore.sync({ closure in
                Master.shared.getAreas(type: .temple, callback: closure)
            }) ?? []
            
            DispatchQueue.main.async {
                LoadingHUDManager.default.hide()
                self?.areas = [temples, shrines, explorations].map { $0.sorted { $0.areaId > $1.areaId } }.flatMap { $0 }
                self?.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HatsuneEventTableViewCell.description(), for: indexPath) as! HatsuneEventTableViewCell
        let area = areas[indexPath.row]
        cell.configure(for: area.areaName, subtitle: "", unitID: area.quests.last?.waves.last?.enemies.first?.enemy?.unit.prefabId)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let area = areas[indexPath.row]
        LoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            area.quests.forEach { $0.preload() }
            DispatchQueue.main.async {
                LoadingHUDManager.default.hide()
                let vc = QuestTabViewController(quests: area.quests)
                vc.navigationItem.title = area.areaName
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
