//
//  SettingsViewController.swift
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

class SettingsViewController: FormViewController {
        
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
                $0.value = "\(VersionManager.shared.appVersion)(\(VersionManager.shared.buildNumber))"
            }
            .cellSetup(cellSetup(cell:row:))
            .cellUpdate(cellUpdate(cell:row:))
            
            <<< LabelRow("data_version") {
                $0.title = NSLocalizedString("Data Version", comment: "")
                $0.value = VersionManager.shared.truthVersion
            }
            .cellSetup(cellSetup(cell:row:))
            .cellUpdate(cellUpdate(cell:row:))
            .onCellSelection({ [weak self] (cell, row) in
                let vc = UIAlertController(title: NSLocalizedString("Reset Data Version?", comment: ""), message: NSLocalizedString("If the data version is not synchronized with the data, reset it and then you can retrieve the newest version again.", comment: ""), preferredStyle: .alert)
                vc.addAction(.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { [weak vc] _ in
                    VersionManager.shared.truthVersion = "0"
                    row.value = "0"
                    cell.update()
                    vc?.dismiss(animated: true, completion: nil)
                }))
                vc.addAction(.init(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { [weak vc] _ in
                    vc?.dismiss(animated: true, completion: nil)
                }))
                self?.present(vc, animated: true, completion: nil)
            })
        
    }
    
    @objc private func handleUpdateEnd(_ notification: Notification) {
        let row = form.rowBy(tag: "data_version") as? LabelRow
        row?.value = VersionManager.shared.truthVersion
        row?.updateCell()
    }
    
    @objc private func handleDidBecameActive(_ notification: Notification) {
        let row = form.rowBy(tag: "current_language")
        row?.updateCell()
    }
    
    @objc private func showAckListViewController() {
        let vc = AcknowListViewController()
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

extension SettingsViewController: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
