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
import Gestalt

class EDTabViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {
    
    static var defaultTabIndex: Int = 1
    
    private var viewControllers = [UIViewController]()
    
    private var enemy: Enemy
    
    init(enemy: Enemy, isMinion: Bool = false) {
        self.enemy = enemy
        if enemy.resist != nil {
            viewControllers.append(EDResistTableViewController(enemy: enemy))
            items.append(TMBarItem(title: NSLocalizedString("Resist", comment: "")))
        }
        if !enemy.isBossPart {
            viewControllers.append(EDSkillTableViewController(enemy: enemy))
            items.append(TMBarItem(title: NSLocalizedString("Skill", comment: "")))
        }
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Options", comment: ""), style: .plain, target: self, action: #selector(handleNavigationRightItem(_:)))
        
        dataSource = self
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
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        if EDTabViewController.defaultTabIndex <= viewControllers.count {
            return .at(index: EDTabViewController.defaultTabIndex)
        } else {
            return .last
        }
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: Int, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        super.pageboyViewController(pageboyViewController, didScrollToPageAt: index, direction: direction, animated: animated)
        EDTabViewController.defaultTabIndex = index
    }
    
    @objc private func handleNavigationRightItem(_ item: UIBarButtonItem) {
        let vc = EDSettingsViewController()
        let nc = UINavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .formSheet
        present(nc, animated: true, completion: nil)
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return items[index]
    }
}
