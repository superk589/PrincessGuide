//
//  CardTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/9.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import MJRefresh

class CardTableViewController: UITableViewController, DataChecking {
    
    var cards = [Card]()

    let refresher = RefreshHeader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateEnd(_:)), name: .updateEnd, object: nil)
        
        tableView.mj_header = refresher
        refresher.refreshingBlock = { [weak self] in self?.check() }
        
        tableView.keyboardDismissMode = .onDrag
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: CardTableViewCell.description())
        tableView.estimatedRowHeight = 84
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        navigationItem.title = NSLocalizedString("Cards", comment: "")
        
        loadData()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func loadData() {
        LoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Master.shared.getCards(callback: { (cards) in
                DispatchQueue.main.async {
                    LoadingHUDManager.default.hide()
                    self?.cards = cards // .sorted { $0.base.unitName < $1.base.unitName }
                    self?.tableView.reloadData()
                }
            })
        }
    }
    
    @objc private func handleUpdateEnd(_ notification: Notification) {
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.description(), for: indexPath) as! CardTableViewCell
        
        let card = cards[indexPath.row]
        cell.configure(for: card)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CDTableViewController()
        vc.card = cards[indexPath.row]
        print("card id: \(cards[indexPath.row].base.unitId)")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
