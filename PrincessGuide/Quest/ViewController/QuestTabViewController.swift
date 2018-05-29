//
//  QuestTabViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/9.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Tabman
import Pageboy
import Gestalt

class QuestTabViewController: TabmanViewController, PageboyViewControllerDataSource {
    
    private var viewControllers = [UIViewController]()
        
    let quests: [Quest]

    init(quests: [Quest]) {
        self.quests = quests
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var vcs: [UIViewController] = [DropSummaryTableViewController(quests: quests)]
        var items = [NSLocalizedString("Drops", comment: "")].map { Item(title: $0) }
        
        for i in 0... {
            let lowerBound = i * 5
            let upperBound = min((i + 1) * 5, quests.count)
            let subQuests = quests[lowerBound..<upperBound]
            let vc = QuestEnemyTableViewController(quests: Array(subQuests))
            let title = "\(lowerBound + 1) - \(upperBound)"
            items.append(Item(title: title))
            vcs.append(vc)
            if upperBound == quests.count { break }
        }
        
        viewControllers = vcs
        bar.items = items
        dataSource = self
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
        return .at(index: 0)
    }
}
