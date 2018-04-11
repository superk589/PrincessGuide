//
//  CardTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/9.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class CardTableViewController: UITableViewController {
    
    var cards = [Card]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.keyboardDismissMode = .onDrag
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: CardTableViewCell.description())
        tableView.rowHeight = 44
        tableView.tableFooterView = UIView()
        
        navigationItem.title = NSLocalizedString("Cards", comment: "")
        
        loadData()
    }
    
    func loadData() {
        LoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Master.shared.getCards(callback: { (cards) in
                DispatchQueue.main.async {
                    LoadingHUDManager.default.hide()
                    self?.cards = cards
                    self?.tableView.reloadData()
                }
            })
        }
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
        let vc = CardDetailTableViewController()
        vc.card = cards[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
