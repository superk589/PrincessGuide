//
//  SettingsTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import AcknowList

class SettingsTableViewController: UITableViewController {

    private struct Row {
        var title: String
        var detail: String?
        var hasDisclosure: Bool
        var accessoryView: UIView?
        var selector: Selector?
    }
    
    private struct Section {
        var rows: [Row]
        var title: String
    }
    
    private var sections = [Section]()
    
    private func prepareCellData() {
        var aboutRows = [Row]()
        aboutRows.append(Row(title: NSLocalizedString("Third-Party Libraries", comment: ""), detail: nil, hasDisclosure: true, accessoryView: nil, selector: #selector(showAckListViewController)))
        aboutRows.append(Row(title: NSLocalizedString("Current Version", comment: ""), detail: VersionManager.shared.appVersionString, hasDisclosure: false, accessoryView: nil, selector: nil))
        sections.append(Section(rows: aboutRows, title: NSLocalizedString("About", comment: "")))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("Settings", comment: "")
        prepareCellData()
    }
    
    @objc private func showAckListViewController() {
        let vc = AcknowListViewController()
        vc.navigationItem.title = NSLocalizedString("Third-Party Libraries", comment: "")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: UITableViewDelegate & DataSource
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description()) ?? UITableViewCell(style: .value1, reuseIdentifier: UITableViewCell.description())
        
        let row = sections[indexPath.section].rows[indexPath.row]
        
        cell.textLabel?.text = row.title
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.text = row.detail
        cell.accessoryType = row.hasDisclosure ? .disclosureIndicator : .none
        cell.accessoryView = row.accessoryView
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = sections[indexPath.section].rows[indexPath.row]
        if let selector = row.selector {
            perform(selector)
        }
    }
}
