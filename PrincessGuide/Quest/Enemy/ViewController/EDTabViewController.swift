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

class EDTabViewController: TabmanViewController, PageboyViewControllerDataSource {
    
    static var defaultTabIndex: Int = 1
    
    private var viewControllers: [UIViewController]
    
    private var enemy: Enemy
    
    init(enemy: Enemy, isMinion: Bool = false) {
        self.enemy = enemy
        viewControllers = [EDResistTableViewController(enemy: enemy), EDSkillTableViewController(enemy: enemy), EDStatusTableViewController(enemy: enemy, isMinion: isMinion)]
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = enemy.base.name
        print("load enemy, id: \(enemy.unit.unitId)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Options", comment: ""), style: .plain, target: self, action: #selector(handleNavigationRightItem(_:)))
        
        let items = [NSLocalizedString("Resist", comment: ""),
                     NSLocalizedString("Skill", comment: ""),
                     NSLocalizedString("Status", comment: "")]
            .map { Item(title: $0) }
        
        dataSource = self
        bar.items = items
        bar.location = .bottom
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            let navigationBar = themeable.navigationController?.navigationBar
            navigationBar?.tintColor = theme.color.tint
            navigationBar?.barStyle = theme.barStyle
            
            themeable.view.backgroundColor = theme.color.background
            themeable.bar.appearance = TabmanBar.Appearance({ (appearance) in
                appearance.indicator.color = theme.color.tint
                appearance.state.selectedColor = theme.color.tint
                appearance.state.color = theme.color.lightText
                appearance.layout.itemDistribution = .centered
                appearance.style.background = .blur(style: theme.blurEffectStyle)
                appearance.indicator.preferredStyle = .clear
                appearance.layout.extendBackgroundEdgeInsets = true
            })
        }
        
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: EDTabViewController.defaultTabIndex)
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
}
