//
//  ToolboxTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/6/28.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class ToolboxTableViewController: UITableViewController {
    
    struct Row {
        var title: String
        var iconID: Int
        var vcType: UIViewController.Type
    }
    
    private var rows = [
        Row(title: NSLocalizedString("Box Manager", comment: ""), iconID: 100131, vcType: BoxManagerTableViewController.self)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    
    
        tableView.register(ToolboxTableViewCell.self, forCellReuseIdentifier: ToolboxTableViewCell.description())

        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = 66
        tableView.tableFooterView = UIView()
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToolboxTableViewCell.description(), for: indexPath) as! ToolboxTableViewCell
        
        cell.configure(for: rows[indexPath.row].title)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = rows[indexPath.row]
        let vc = row.vcType.init()
        
        vc.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
