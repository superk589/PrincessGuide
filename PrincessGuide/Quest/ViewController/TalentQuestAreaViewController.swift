//
//  TalentQuestAreaViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2024/3/12.
//  Copyright © 2024 zzk. All rights reserved.
//

import UIKit

class TalentQuestAreaViewController: UITableViewController, DataChecking {
    
    private var areas = [TalentArea]()
    
    let refresher = RefreshHeader()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            Master.shared.getTalentAreas(callback: { (areas) in
                // preload
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        LoadingHUDManager.default.hide()
                        self?.areas = areas.sorted { $0.areaId > $1.areaId }
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
        return areas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HatsuneEventTableViewCell.description(), for: indexPath) as! HatsuneEventTableViewCell
        let area = areas[indexPath.row]
        cell.configure(for: area.areaName, subtitle: "", unitID: area.quests.last?.wave?.enemies.first?.unit.prefabId)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let area = areas[indexPath.row]
        LoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//            area.quests.forEach { $0.preload() }
            DispatchQueue.main.async {
                LoadingHUDManager.default.hide()
                let vc = QuestEnemyTableViewController(talentQuests: area.quests.reversed())
                vc.navigationItem.title = area.areaName
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
