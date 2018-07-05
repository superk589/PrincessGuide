//
//  ToolboxTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/6/28.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class ToolboxTableViewController: UITableViewController {
    
    struct Row {
        var title: String
        var vcType: UIViewController.Type
    }
    
    private var rows = [
        Row(title: NSLocalizedString("Chara Management", comment: ""), vcType: CharaTableViewController.self),
        Row(title: NSLocalizedString("Box Management", comment: ""), vcType: BoxTableViewController.self),
        Row(title: NSLocalizedString("Team Management", comment: ""), vcType: TeamTableViewController.self)
    ]
    
    let backgroundImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = backgroundImageView
        
        navigationItem.title = NSLocalizedString("Toolbox", comment: "")
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            let navigationBar = themeable.navigationController?.navigationBar
            navigationBar?.tintColor = theme.color.tint
            navigationBar?.barStyle = theme.barStyle
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.tableView.indicatorStyle = theme.indicatorStyle
        }
    
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
