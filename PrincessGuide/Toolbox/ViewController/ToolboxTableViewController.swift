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
        var isProFeature: Bool
    }
    
    private var rows = [
        Row(title: NSLocalizedString("Birthday Notification", comment: ""), vcType: BirthdayViewController.self, isProFeature: false),
        Row(title: NSLocalizedString("Chara Management", comment: ""), vcType: CharaTableViewController.self, isProFeature: true),
        Row(title: NSLocalizedString("Box Management", comment: ""), vcType: BoxTableViewController.self, isProFeature: true),
        Row(title: NSLocalizedString("Team Management", comment: ""), vcType: SearchableTeamTableViewController.self, isProFeature: true),
        Row(title: NSLocalizedString("Version Log", comment: ""), vcType: VLTableViewController.self, isProFeature: false)
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
        tableView.estimatedRowHeight = 0
        tableView.tableFooterView = UIView()
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleEditionChange(_:)), name: .proEditionPurchased, object: nil)
        
    }
    
    @objc private func handleEditionChange(_ notification: Notification) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToolboxTableViewCell.description(), for: indexPath) as! ToolboxTableViewCell
        let row = rows[indexPath.row]
//        if row.isProFeature && !Defaults.proEdition {
//            cell.configure(for: row.title + " (Pro)")
//        } else {
            cell.configure(for: row.title)
//        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = rows[indexPath.row]
        
//        #if targetEnvironment(simulator)
            let vc = row.vcType.init()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
//        #else
//            if row.isProFeature && !Defaults.proEdition {
//                let vc = BuyProEditionViewController()
//                vc.hidesBottomBarWhenPushed = true
//                navigationController?.pushViewController(vc, animated: true)
//            } else {
//                let vc = row.vcType.init()
//                vc.hidesBottomBarWhenPushed = true
//                navigationController?.pushViewController(vc, animated: true)
//            }
//        #endif
    }
}
