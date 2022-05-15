//
//  QuestAreaTabViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/6.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class QuestAreaTabViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {
    
    private var viewControllers = [UIViewController]()
    
    private var items = [TMBarItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("Quests", comment: "")
        viewControllers = [
            HatsuneEventAreaTableViewController(),
            DungeonBossTableViewController(),
//            KaiserRaidViewController(),
            ClanBattleTableViewController(mode: .normal),
            SecretDungeonViewController(),
            TowerTableViewController(),
            QuestAreaTableViewController(areaType: .normal),
            QuestAreaTableViewController(areaType: .hard),
            QuestAreaTableViewController(areaType: .veryHard),
            ShioriEventAreaTableViewController(),
            MiscQuestAreaTableViewController(),
            Rarity6UnlockQuestViewController(),
            ClanBattleTableViewController(mode: .easy)
        ]
        dataSource = self
        
        self.items = [
            TMBarItem(title: NSLocalizedString("Event", comment: "")),
            TMBarItem(title: NSLocalizedString("Dungeon", comment: "")),
//            TMBarItem(title: NSLocalizedString("Raid", comment: "")),
            TMBarItem(title: NSLocalizedString("Clan Battle", comment: "")),
            TMBarItem(title: NSLocalizedString("Secret Dungeon", comment: "")),
            TMBarItem(title: NSLocalizedString("Tower", comment: ""))
            ]
            + [AreaType.normal, .hard, .veryHard].map { TMBarItem(title: $0.description) }
            + [TMBarItem(title: NSLocalizedString("Side Story", comment: "")),
                TMBarItem(title: NSLocalizedString("Exploration", comment: "")),
               TMBarItem(title: NSLocalizedString("Rarity 6", comment: "")),
               TMBarItem(title: NSLocalizedString("Clan Battle(Simple)", comment: ""))
        ]
        
        let bar = TMBarView<TMHorizontalBarLayout, TMLabelBarButton, TMBarIndicator.None>()
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bar.layout.transitionStyle = .progressive
        addBar(bar, dataSource: self, at: .bottom)
        
        view.backgroundColor = Theme.dynamic.color.background
        bar.indicator.tintColor = Theme.dynamic.color.tint
        bar.buttons.customize { (button) in
            button.selectedTintColor = Theme.dynamic.color.tint
            button.tintColor = Theme.dynamic.color.lightText
        }
        bar.backgroundView.style = .blur(style: .systemMaterial)
    }

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: 2)
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return items[index]
    }
    
}
