//
//  TowerQuestTabViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/9/13.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Tabman
import Pageboy
import Gestalt

class TowerQuestTabViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {
    
    private var viewControllers = [UIViewController]()
    
    let quests: [Tower.Quest]
    
    let exQuests: [Tower.Quest]
    
    init(quests: [Tower.Quest], exQuests: [Tower.Quest]) {
        self.quests = quests.sorted { $0.waveGroupId > $1.waveGroupId }
        self.exQuests = exQuests.sorted { $0.waveGroupId > $1.waveGroupId }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var items = [TMBarItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var vcs = [UIViewController]()
        
        for i in 0... {
            let lowerBound = i * 10
            let upperBound = min((i + 1) * 10, exQuests.count)
            let subQuests = Array(exQuests[lowerBound..<upperBound])
            let vc = QuestEnemyTableViewController(towerQuests: subQuests)
            let title = "Ex \(subQuests.first?.floorNum ?? 0) - \(subQuests.last?.floorNum ?? 0)"
            items.append(TMBarItem(title: title))
            vcs.append(vc)
            if upperBound == exQuests.count { break }
        }
        
        for i in 0... {
            let lowerBound = i * 10
            let upperBound = min((i + 1) * 10, quests.count)
            let subQuests = Array(quests[lowerBound..<upperBound])
            let vc = QuestEnemyTableViewController(towerQuests: Array(subQuests))
            let title = "\(subQuests.first?.floorNum ?? 0) - \(subQuests.last?.floorNum ?? 0)"
            items.append(TMBarItem(title: title))
            vcs.append(vc)
            if upperBound == quests.count { break }
        }
        
        viewControllers = vcs
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
        return .at(index: 0)
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return items[index]
    }
}
