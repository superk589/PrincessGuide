//
//  SettingsTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import MessageUI
import Social
import AcknowList
import Gestalt

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
        
        var settingRows = [Row]()
        
        let downloadAtStartSwitch = UISwitch()
        ThemeManager.default.apply(theme: Theme.self, to: downloadAtStartSwitch) { (themable, theme) in
            themable.onTintColor = theme.color.tint
        }
        downloadAtStartSwitch.isOn = Defaults.downloadAtStart
        downloadAtStartSwitch.addTarget(self, action: #selector(handleDownloadAtStartSwitch(_:)), for: .valueChanged)
        
        let darkThemeSwitch = UISwitch()
        ThemeManager.default.apply(theme: Theme.self, to: darkThemeSwitch) { (themable, theme) in
            themable.onTintColor = theme.color.tint
        }
        darkThemeSwitch.isOn = Defaults.prefersDarkTheme
        darkThemeSwitch.addTarget(self, action: #selector(handleDarkThemeSwitch(_:)), for: .valueChanged)
        
        settingRows.append(Row(title: NSLocalizedString("Check for Updates at Launch", comment: ""), detail: nil, hasDisclosure: false, accessoryView: downloadAtStartSwitch, selector: nil))
        settingRows.append(Row(title: NSLocalizedString("Use Dark Theme", comment: ""), detail: "", hasDisclosure: false, accessoryView: darkThemeSwitch, selector: nil))
        
        sections.append(Section(rows: settingRows, title: NSLocalizedString("Setting", comment: "")))
        
        var feedbackRows = [Row]()
        feedbackRows.append(Row(title: NSLocalizedString("Email", comment: ""), detail: nil, hasDisclosure: true, accessoryView: nil, selector: #selector(sendEmail)))
        feedbackRows.append(Row(title: NSLocalizedString("Review at App Store", comment: ""), detail: nil, hasDisclosure: true, accessoryView: nil, selector: #selector(postReview)))
        feedbackRows.append(Row(title: NSLocalizedString("Twitter", comment: ""), detail: nil, hasDisclosure: true, accessoryView: nil, selector: #selector(sendTweet)))
        sections.append(Section(rows: feedbackRows, title: NSLocalizedString("Feedback", comment: "")))
        
        var aboutRows = [Row]()
        aboutRows.append(Row(title: NSLocalizedString("Third-Party Libraries", comment: ""), detail: nil, hasDisclosure: true, accessoryView: nil, selector: #selector(showAckListViewController)))
        aboutRows.append(Row(title: NSLocalizedString("App Version", comment: ""), detail: VersionManager.shared.appVersion, hasDisclosure: false, accessoryView: nil, selector: nil))
        aboutRows.append(Row(title: NSLocalizedString("Data Version", comment: ""), detail: VersionManager.shared.truthVersion, hasDisclosure: false, accessoryView: nil, selector: nil))
        sections.append(Section(rows: aboutRows, title: NSLocalizedString("About", comment: "")))
    }
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            let navigationBar = themable.navigationController?.navigationBar
            navigationBar?.tintColor = theme.color.tint
            navigationBar?.barStyle = theme.barStyle
            themable.backgroundImageView.image = theme.backgroundImage
            themable.tableView.indicatorStyle = theme.indicatorStyle
        }
        
        navigationItem.title = NSLocalizedString("Settings", comment: "")
        prepareCellData()
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateEnd(_:)), name: .updateEnd, object: nil)
        tableView.cellLayoutMarginsFollowReadableWidth = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleUpdateEnd(_ notification: Notification) {
        sections.removeAll()
        prepareCellData()
        tableView.reloadData()
    }
    
    @objc private func handleDownloadAtStartSwitch(_ sender: UISwitch) {
        Defaults.downloadAtStart = sender.isOn
    }
    
    @objc private func handleDarkThemeSwitch(_ sender: UISwitch) {
        Defaults.prefersDarkTheme = sender.isOn
    }
    
    @objc private func showAckListViewController() {
        let vc = ThirdPartyLibrariesViewController()
        vc.navigationItem.title = NSLocalizedString("Third-Party Libraries", comment: "")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func sendTweet() {
        if let url = URL(string: "twitter://post?message=%23\(Constant.appNameHashtag)%0d"), UIApplication.shared.canOpenURL(url) {
            print("open twitter using url scheme")
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else if let url = URL(string: "https://twitter.com/intent/tweet?text=%23\(Constant.appNameHashtag)%0d"), UIApplication.shared.canOpenURL(url) {
            print("open twitter by openURL")
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            print("open twitter failed")
        }
    }
    
    @objc private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let vc = MFMailComposeViewController()
            vc.setSubject(NSLocalizedString("\(Constant.appName) Feedback", comment: ""))
            vc.mailComposeDelegate = self
            vc.setToRecipients(["superk589@vip.qq.com"])
            vc.addAttachmentData(DeviceInfo.default.description.data(using: .utf8)!, mimeType: "text/plain", fileName: "device_information.txt")
            present(vc, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Unable to open Mail", comment: ""), message: NSLocalizedString("There aren't any Mail accounts", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func postReview() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(Constant.appID)?action=write-review") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
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
        cell.selectedBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: cell) { (themable, theme) in
            themable.textLabel?.textColor = theme.color.title
            themable.detailTextLabel?.textColor = theme.color.body
            themable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themable.backgroundColor = theme.color.tableViewCell.background
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = sections[indexPath.section].rows[indexPath.row]
        if let selector = row.selector {
            perform(selector)
        }
    }
}

// MARK: MFMailComposeViewControllerDelegate

extension SettingsTableViewController: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
