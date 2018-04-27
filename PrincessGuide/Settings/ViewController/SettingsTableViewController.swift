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
        var feedbackRows = [Row]()
        feedbackRows.append(Row(title: NSLocalizedString("Email", comment: ""), detail: nil, hasDisclosure: true, accessoryView: nil, selector: #selector(sendEmail)))
        feedbackRows.append(Row(title: NSLocalizedString("Review at App Store", comment: ""), detail: nil, hasDisclosure: true, accessoryView: nil, selector: #selector(postReview)))
        feedbackRows.append(Row(title: NSLocalizedString("Twitter", comment: ""), detail: nil, hasDisclosure: true, accessoryView: nil, selector: #selector(sendTweet)))
        sections.append(Section(rows: feedbackRows, title: NSLocalizedString("Feedback", comment: "")))
        
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
    
    @objc private func sendTweet() {
        if let url = URL(string: "twitter://post?message=%23\(Config.appName)%0d"), UIApplication.shared.canOpenURL(url) {
            print("open twitter using url scheme")
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else if let url = URL(string: "https://twitter.com/intent/tweet?text=%23\(Config.appName)%0d"), UIApplication.shared.canOpenURL(url) {
            print("open twitter by openURL")
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("open twitter failed")
        }
    }
    
    @objc private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let vc = MFMailComposeViewController()
            vc.setSubject(NSLocalizedString("\(Config.appName) Feedback", comment: ""))
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
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(Config.appID)?action=write-review") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
