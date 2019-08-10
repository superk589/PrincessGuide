//
//  CDTabViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/6.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Tabman
import Pageboy
import Gestalt
import DHSmartScreenshot

class CDTabViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {
    
    static var defaultTabIndex: Int = 2

    private var viewControllers: [CDTableViewController]
    
    private var card: Card
    
    init(card: Card) {
        self.card = card
        viewControllers = [CDImageTableViewController(), CDSkillTableViewController(), CDProfileTableViewController(), CDPropertyViewController(), CDPromotionTableViewController()]
        viewControllers.forEach { $0.card = card }
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = card.base.unitName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var items = [TMBarItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = card.base.unitName
        let optionsItem = UIBarButtonItem(title: NSLocalizedString("Options", comment: ""), style: .plain, target: self, action: #selector(handleOptionsItem(_:)))
        let exportItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleExportItem(_:)))
        navigationItem.rightBarButtonItems = [optionsItem, exportItem]
        
        dataSource = self
        delegate = self

        let items = [
            NSLocalizedString("Image", comment: ""),
            NSLocalizedString("Skill", comment: ""),
            NSLocalizedString("Profile", comment: ""),
            NSLocalizedString("Status", comment: ""),
            NSLocalizedString("Equipment", comment: "")
        ].map { TMBarItem(title: $0) }
 
        self.items = items
        
        let bar = TMBarView<TMHorizontalBarLayout, TMLabelBarButton, TMBarIndicator.None>()
        let systemBar = bar.systemBar()
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bar.layout.transitionStyle = .progressive
        addBar(systemBar, dataSource: self, at: .bottom)
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            let navigationBar = themeable.navigationController?.navigationBar
            navigationBar?.tintColor = theme.color.tint
            navigationBar?.barStyle = theme.barStyle
            
            themeable.view.backgroundColor = theme.color.background
            bar.indicator.tintColor = theme.color.tint
            bar.buttons.customize({ (button) in
                button.selectedTintColor = theme.color.tint
                button.tintColor = theme.color.lightText
            })
            systemBar.backgroundStyle = .blur(style: theme.blurEffectStyle)
        }
        
    }
    
    @objc private func handleExportItem(_ item: UIBarButtonItem) {
        if let index = self.currentIndex,
            let foregroundImage = viewControllers[index].tableView.screenshot(),
            let backgroundImage = viewControllers[index].backgroundImageView.image,
            let tableViewImage = foregroundImage.addBackground(backgroundImage) {
            
            var image = tableViewImage
            if let navigationBarImage = navigationController?.navigationBar.screenshot() {
                image = UIImage.verticalImage(from: [navigationBarImage, image])
            }
            UIActivityViewController.show(images: [image], pointTo: item, in: self)
        }
    }
    
    @objc private func handleOptionsItem(_ item: UIBarButtonItem) {
        let vc = CDSettingsViewController()
        let nc = UINavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .formSheet
        present(nc, animated: true, completion: nil)
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: CDTabViewController.defaultTabIndex)
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: Int, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        super.pageboyViewController(pageboyViewController, didScrollToPageAt: index, direction: direction, animated: animated)
        CDTabViewController.defaultTabIndex = index
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, willScrollToPageAt index: TabmanViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        super.pageboyViewController(pageboyViewController, willScrollToPageAt: index, direction: direction, animated: animated)
        guard let vc = viewControllers[index] as? CDSkillTableViewController else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.performWithoutAnimation {
                vc.tableView.beginUpdates()
                vc.tableView.endUpdates()
            }
        }
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didReloadWith currentViewController: UIViewController, currentPageIndex: TabmanViewController.PageIndex) {
        super.pageboyViewController(pageboyViewController, didReloadWith: currentViewController, currentPageIndex: currentPageIndex)
        guard let vc = currentViewController as? CDSkillTableViewController else { return }
        DispatchQueue.main.async {
            UIView.performWithoutAnimation {
                vc.tableView.beginUpdates()
                vc.tableView.endUpdates()
            }
        }
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return items[index]
    }
}
