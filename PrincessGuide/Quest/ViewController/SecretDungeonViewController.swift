//
//  SecretDungeonViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2022/5/15.
//  Copyright © 2022 zzk. All rights reserved.
//

import UIKit

class SecretDungeonViewController: UITableViewController, DataChecking {
    
    private var dungeons = [SecretDungeon]()
    
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
            Master.shared.getSecretDungeons { (dungeons) in
                // preload
                DispatchQueue.global(qos: .userInitiated).async {
                    dungeons.forEach { _ = $0.floors.last?.wave?.enemies.first?.enemy }
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
        let unit = dungeon.floors.last?.wave?.enemies.first?.enemy?.unit
        cell.configure(for: "\(unit?.unitName ?? "")", subtitle: dungeon.name, unitID: unit?.prefabId)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dungeon = dungeons[indexPath.row]
        let vc = SecretDungeonFloorTabViewController(floors: dungeon.floors)
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.title = dungeon.floors.last?.wave?.enemies.first?.enemy?.unit.unitName
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
