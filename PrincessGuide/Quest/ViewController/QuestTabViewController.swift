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

class QuestTabViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {
    
    private var viewControllers = [UIViewController]()
        
    let quests: [Quest]

    init(quests: [Quest]) {
        self.quests = quests
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var items = [TMBarItem]()
    override func viewDidLoad() {
        super.viewDidLoad()

        var vcs: [UIViewController] = [DropSummaryTableViewController(quests: quests)]
        var items = [NSLocalizedString("Drops", comment: "")].map { TMBarItem(title: $0) }
        
        for i in 0... {
            let lowerBound = i * 5
            let upperBound = min((i + 1) * 5, quests.count)
            let subQuests = quests[lowerBound..<upperBound]
            let vc = QuestEnemyTableViewController(quests: Array(subQuests))
            let title = "\(lowerBound + 1) - \(upperBound)"
            items.append(TMBarItem(title: title))
            vcs.append(vc)
            if upperBound == quests.count { break }
        }
        
        viewControllers = vcs
        dataSource = self
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
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: 0)
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return items[index]
    }
}
