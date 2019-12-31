//
//  EDTabViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class EDTabViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {
    
    static var defaultTabIndex: Int = 1
    
    private var viewControllers = [UITableViewController]()
    
    private var enemy: Enemy
    
    init(enemy: Enemy, isMinion: Bool = false) {
        self.enemy = enemy
        if enemy.resist != nil {
            viewControllers.append(EDResistTableViewController(enemy: enemy))
            items.append(TMBarItem(title: NSLocalizedString("Resist", comment: "")))
        }
        viewControllers.append(EDSkillTableViewController(enemy: enemy))
        items.append(TMBarItem(title: NSLocalizedString("Skill", comment: "")))
        viewControllers.append(EDStatusTableViewController(enemy: enemy, isMinion: isMinion))
        items.append(TMBarItem(title: NSLocalizedString("Status", comment: "")))
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = enemy.base.name
        print("load enemy, id: \(enemy.unit.unitId)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var items = [TMBarItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let optionsItem = UIBarButtonItem(title: NSLocalizedString("Options", comment: ""), style: .plain, target: self, action: #selector(handleOptionsItem(_:)))
        let exportItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleExportItem(_:)))
        navigationItem.rightBarButtonItems = [optionsItem, exportItem]
        
        dataSource = self
        let bar = TMBarView<TMHorizontalBarLayout, TMLabelBarButton, TMBarIndicator.None>()
        let systemBar = bar.systemBar()
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bar.layout.transitionStyle = .progressive
        addBar(systemBar, dataSource: self, at: .bottom)
        
        view.backgroundColor = Theme.dynamic.color.background
        bar.indicator.tintColor = Theme.dynamic.color.tint
        bar.buttons.customize { (button) in
            button.selectedTintColor = Theme.dynamic.color.tint
            button.tintColor = Theme.dynamic.color.lightText
        }
        systemBar.backgroundStyle = .blur(style: .systemMaterial)
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        if EDTabViewController.defaultTabIndex < viewControllers.count {
            return .at(index: EDTabViewController.defaultTabIndex)
        } else {
            return .last
        }
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: Int, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        super.pageboyViewController(pageboyViewController, didScrollToPageAt: index, direction: direction, animated: animated)
        EDTabViewController.defaultTabIndex = index
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, willScrollToPageAt index: TabmanViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        super.pageboyViewController(pageboyViewController, willScrollToPageAt: index, direction: direction, animated: animated)
        let vc = viewControllers[index]
        guard vc is EDSkillTableViewController || vc is EDStatusTableViewController else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.performWithoutAnimation {
                vc.tableView.beginUpdates()
                vc.tableView.endUpdates()
            }
        }
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didReloadWith currentViewController: UIViewController, currentPageIndex: TabmanViewController.PageIndex) {
        super.pageboyViewController(pageboyViewController, didReloadWith: currentViewController, currentPageIndex: currentPageIndex)
        guard let vc = currentViewController as? EDTableViewController else { return }
        guard vc is EDSkillTableViewController || vc is EDStatusTableViewController else { return }
        DispatchQueue.main.async {
            UIView.performWithoutAnimation {
                vc.tableView.beginUpdates()
                vc.tableView.endUpdates()
            }
        }
    }
    
    @objc private func handleExportItem(_ item: UIBarButtonItem) {
        if let index = self.currentIndex,
            let foregroundImage = viewControllers[index].tableView.screenshot() {
            
            var image = foregroundImage
            if let navigationBarImage = navigationController?.navigationBar.screenshot(),
                let navigationBarImageWithBackground = navigationBarImage.addBackground(.systemBackground) {
                image = UIImage.verticalImage(from: [navigationBarImageWithBackground, image])
            }
            UIActivityViewController.show(images: [image], pointTo: item, in: self)
        }
    }
    
    @objc private func handleOptionsItem(_ item: UIBarButtonItem) {
        let vc = EDSettingsViewController()
        let nc = UINavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .formSheet
        present(nc, animated: true, completion: nil)
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return items[index]
    }
}
