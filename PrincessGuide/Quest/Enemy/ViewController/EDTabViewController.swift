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
    
    static var defaultTabIndex: Int = 0
    
    private var viewControllers: [UIViewController]
    
    private var enemy: Enemy
    
    init(enemy: Enemy) {
        self.enemy = enemy
        viewControllers = [EDStatusTableViewController(enemy: enemy), EDSkillTableViewController(enemy: enemy)]
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = enemy.base.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = [NSLocalizedString("Status", comment: ""),
                     NSLocalizedString("Skill", comment: "")].map { Item(title: $0) }
        
        dataSource = self
        bar.items = items
        bar.location = .bottom
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            let navigationBar = themable.navigationController?.navigationBar
            navigationBar?.tintColor = theme.color.tint
            navigationBar?.barStyle = theme.barStyle
            
            themable.view.backgroundColor = theme.color.background
            themable.bar.appearance = TabmanBar.Appearance({ (appearance) in
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
}
