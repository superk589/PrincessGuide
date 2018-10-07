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

class TowerQuestTabViewController: TabmanViewController, PageboyViewControllerDataSource {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var vcs = [UIViewController]()
        var items = [Item]()
        
        for i in 0... {
            let lowerBound = i * 10
            let upperBound = min((i + 1) * 10, exQuests.count)
            let subQuests = Array(exQuests[lowerBound..<upperBound])
            let vc = QuestEnemyTableViewController(towerQuests: subQuests)
            let title = "Ex \(subQuests.first?.floorNum ?? 0) - \(subQuests.last?.floorNum ?? 0)"
            items.append(Item(title: title))
            vcs.append(vc)
            if upperBound == exQuests.count { break }
        }
        
        for i in 0... {
            let lowerBound = i * 10
            let upperBound = min((i + 1) * 10, quests.count)
            let subQuests = Array(quests[lowerBound..<upperBound])
            let vc = QuestEnemyTableViewController(towerQuests: Array(subQuests))
            let title = "\(subQuests.first?.floorNum ?? 0) - \(subQuests.last?.floorNum ?? 0)"
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
