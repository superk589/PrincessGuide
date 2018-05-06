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

class CDTabViewController: TabmanViewController, PageboyViewControllerDataSource {

    private var viewControllers: [CDTableViewController]
    
    private var card: Card
    
    init(card: Card) {
        self.card = card
        viewControllers = [CDSkillTableViewController(), CDPromotionTableViewController(), CDProfileTableViewController()]
        viewControllers.forEach { $0.card = card }
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = card.base.unitName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = card.base.unitName

        dataSource = self
        bar.items = [NSLocalizedString("Skill", comment: ""),
                     NSLocalizedString("Equipment", comment: ""),
                     NSLocalizedString("Profile", comment: "")].map { Item(title: $0) }
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
        return nil
    }
}
