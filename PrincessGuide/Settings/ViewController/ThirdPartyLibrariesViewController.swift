//
//  ThirdPartyLibrariesViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/5.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt
import AcknowList

class ThirdPartyLibrariesViewController: AcknowListViewController {
    
    class func acknowledgementsPlistPath(name:String) -> String? {
        return Bundle.main.path(forResource: name, ofType: "plist")
    }
    
    class func defaultAcknowledgementsPlistPath() -> String? {
        guard let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
            return nil
        }
        
        let defaultAcknowledgementsPlistName = "Pods-\(bundleName)-acknowledgements"
        let defaultAcknowledgementsPlistPath = self.acknowledgementsPlistPath(name: defaultAcknowledgementsPlistName)
        
        if let defaultAcknowledgementsPlistPath = defaultAcknowledgementsPlistPath,
            FileManager.default.fileExists(atPath: defaultAcknowledgementsPlistPath) == true {
            return defaultAcknowledgementsPlistPath
        }
        else {
            // Legacy value
            return self.acknowledgementsPlistPath(name: "Pods-acknowledgements")
        }
    }
    
    convenience init() {
        let path = ThirdPartyLibrariesViewController.defaultAcknowledgementsPlistPath()
        self.init(acknowledgementsPlistPath: path)
    }
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            themable.backgroundImageView.image = theme.backgroundImage
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
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
        if let acknowledgements = self.acknowledgements,
            let acknowledgement = acknowledgements[(indexPath as NSIndexPath).row] as Acknow?,
            let navigationController = self.navigationController {
            let viewController = CustomAcknowViewController(acknowledgement: acknowledgement)
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
