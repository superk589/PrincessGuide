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
import Eureka

class SettingsTableViewController: FormViewController {

//    private func prepareCellData() {
//
//        var settingRows = [Row]()
//
//        let downloadAtStartSwitch = UISwitch()
//        downloadAtStartSwitch.onTintColor = Theme.dynamic.color.tint
//        downloadAtStartSwitch.isOn = Defaults.downloadAtStart
//        downloadAtStartSwitch.addTarget(self, action: #selector(handleDownloadAtStartSwitch(_:)), for: .valueChanged)
//
//
//
//        settingRows.append(Row(title: NSLocalizedString("Check for Updates at Launch", comment: ""), detail: nil, hasDisclosure: false, accessoryView: downloadAtStartSwitch, selector: nil))
//        sections.append(Section(rows: settingRows, title: NSLocalizedString("General", comment: "")))
//
//        var feedbackRows = [Row]()
//        feedbackRows.append(Row(title: NSLocalizedString("Email", comment: ""), detail: nil, hasDisclosure: true, accessoryView: nil, selector: #selector(sendEmail)))
//        feedbackRows.append(Row(title: NSLocalizedString("Review at App Store", comment: ""), detail: nil, hasDisclosure: true, accessoryView: nil, selector: #selector(postReview)))
//        feedbackRows.append(Row(title: NSLocalizedString("Twitter", comment: ""), detail: nil, hasDisclosure: true, accessoryView: nil, selector: #selector(sendTweet)))
//        sections.append(Section(rows: feedbackRows, title: NSLocalizedString("Feedback", comment: "")))
//
//        var aboutRows = [Row]()
//        aboutRows.append(Row(title: NSLocalizedString("Show the Latest Notice", comment: ""), detail: nil, hasDisclosure: true, accessoryView: nil, selector: #selector(showRecentNotice)))
//        aboutRows.append(Row(title: NSLocalizedString("Third-Party Licenses", comment: ""), detail: nil, hasDisclosure: true, accessoryView: nil, selector: #selector(showAckListViewController)))
//        let versionInfo = VersionManager.shared.appVersion
//        aboutRows.append(Row(title: NSLocalizedString("App Version", comment: ""), detail: versionInfo, hasDisclosure: false, accessoryView: nil, selector: nil))
//        aboutRows.append(Row(title: NSLocalizedString("Data Version", comment: ""), detail: VersionManager.shared.truthVersion, hasDisclosure: false, accessoryView: nil, selector: nil))
//        sections.append(Section(rows: aboutRows, title: NSLocalizedString("About", comment: "")))
//    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Settings", comment: "")
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateEnd(_:)), name: .preloadEnd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDidBecameActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        func cellUpdate<T: RowType, U>(cell: T.Cell, row: T) where T.Cell.Value == U {
            EurekaAppearance.cellUpdate(cell: cell, row: row)
        }
        
        func cellSetup<T: RowType, U>(cell: T.Cell, row: T) where T.Cell.Value == U {
            EurekaAppearance.cellSetup(cell: cell, row: row)
        }
        
        func cellUpdateWithDisclosureIndicator<T: RowType, U>(cell: T.Cell, row: T) where T.Cell.Value == U {
            EurekaAppearance.cellUpdate(cell: cell, row: row)
            cell.accessoryType = .disclosureIndicator
        }
        
        func cellSetupWidthDisclosureIndicator<T: RowType, U>(cell: T.Cell, row: T) where T.Cell.Value == U {
            EurekaAppearance.cellSetup(cell: cell, row: row)
            cell.accessoryType = .disclosureIndicator
        }
        
        func onCellSelection<T>(cell: PickerInlineCell<T>, row: PickerInlineRow<T>) {
            EurekaAppearance.onCellSelection(cell: cell, row: row)
        }
        
        func onExpandInlineRow<T>(cell: PickerInlineCell<T>, row: PickerInlineRow<T>, pickerRow: PickerRow<T>) {
            EurekaAppearance.onExpandInlineRow(cell: cell, row: row, pickerRow: pickerRow)
        }
        
        form.inlineRowHideOptions = InlineRowHideOptions.AnotherInlineRowIsShown.union(.FirstResponderChanges)

        form
            +++ Section(NSLocalizedString("General", comment: ""))
            
            <<< SwitchRow() { (row : SwitchRow) -> Void in
                row.title = NSLocalizedString("Check for Updates at Launch", comment: "")
                row.value = Defaults.downloadAtStart
            }
            .cellSetup(cellSetup(cell:row:))
            .cellUpdate(cellUpdate(cell:row:))
            .onChange { row in
                Defaults.downloadAtStart = row.value ?? false
            }
            
            <<< LabelRow("current_language") {
                if let identifier = Bundle.main.preferredLocalizations.first {
                    let locale = Locale(identifier: identifier)
                    $0.value = locale.localizedString(forIdentifier: identifier)
                } else {
                    $0.value = nil
                }
                $0.title = NSLocalizedString("Current Language", comment: "")
            }
            .cellSetup(cellSetupWidthDisclosureIndicator(cell:row:))
            .cellUpdate(cellUpdateWithDisclosureIndicator(cell:row:))
            .onCellSelection { _, _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            
            +++ Section(NSLocalizedString("Feedback", comment: ""))
            
            <<< LabelRow() {
                $0.title = NSLocalizedString("Email", comment: "")
            }
            .cellSetup(cellSetupWidthDisclosureIndicator(cell:row:))
            .cellUpdate(cellUpdateWithDisclosureIndicator(cell:row:))
            .onCellSelection { [unowned self] _, _ in
                self.sendEmail()
            }
        
            <<< LabelRow() {
                $0.title = NSLocalizedString("Review at App Store", comment: "")
            }
            .cellSetup(cellSetupWidthDisclosureIndicator(cell:row:))
            .cellUpdate(cellUpdateWithDisclosureIndicator(cell:row:))
            .onCellSelection { [unowned self] _, _ in
                self.postReview()
            }
            
            <<< LabelRow() {
                $0.title = NSLocalizedString("Twitter", comment: "")
            }
            .cellSetup(cellSetupWidthDisclosureIndicator(cell:row:))
            .cellUpdate(cellUpdateWithDisclosureIndicator(cell:row:))
            .onCellSelection { [unowned self] _, _ in
                self.sendTweet()
            }
        
            +++ Section(NSLocalizedString("About", comment: ""))
            
            <<< LabelRow() {
                $0.title = NSLocalizedString("Show the Latest Notice", comment: "")
            }
            .cellSetup(cellSetupWidthDisclosureIndicator(cell:row:))
            .cellUpdate(cellUpdateWithDisclosureIndicator(cell:row:))
            .onCellSelection { [unowned self] _, _ in
                self.showRecentNotice()
            }
            
            <<< LabelRow() {
                $0.title = NSLocalizedString("Third-Party Licenses", comment: "")
            }
            .cellSetup(cellSetupWidthDisclosureIndicator(cell:row:))
            .cellUpdate(cellUpdateWithDisclosureIndicator(cell:row:))
            .onCellSelection { [unowned self] _, _ in
                self.showAckListViewController()
            }
            
            <<< LabelRow() {
                $0.title = NSLocalizedString("App Version", comment: "")
                $0.value = VersionManager.shared.appVersion
            }
            .cellSetup(cellSetup(cell:row:))
            .cellUpdate(cellUpdate(cell:row:))
            
            <<< LabelRow("data_version") {
                $0.title = NSLocalizedString("Data Version", comment: "")
                $0.value = VersionManager.shared.truthVersion
            }
            .cellSetup(cellSetup(cell:row:))
            .cellUpdate(cellUpdate(cell:row:))
        
    }
    
    @objc private func handleDidBecameActive(_ notification: Notification) {
        let row = form.rowBy(tag: "current_language")
        row?.updateCell()
    }
    
    @objc private func handleUpdateEnd(_ notification: Notification) {
        let row = form.rowBy(tag: "data_version")
        row?.updateCell()
    }
    
    @objc private func showAckListViewController() {
        let vc = ThirdPartyLibrariesViewController()
        vc.navigationItem.title = NSLocalizedString("Third-Party Licenses", comment: "")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func showRecentNotice() {
        VersionManager.shared.noticeVersion = ""
        (UIApplication.shared.delegate as? AppDelegate)?.checkNotice(ignoresExpireDate: true)
    }
    
    @objc private func upgradeToProEdition() {
        let vc = BuyProEditionViewController()
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
            vc.setSubject(String(format: NSLocalizedString("%@ Feedback", comment: ""), Constant.appName))
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
}

// MARK: MFMailComposeViewControllerDelegate

extension SettingsTableViewController: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
