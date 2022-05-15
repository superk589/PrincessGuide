//
//  SecretDungeonFloorTabViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2022/5/15.
//  Copyright © 2022 zzk. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class SecretDungeonFloorTabViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {
    
    private var viewControllers = [UIViewController]()
    
    let floors: [SecretFloor]
        
    init(floors: [SecretFloor]) {
        self.floors = floors.sorted { $0.questId > $1.questId }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var items = [TMBarItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var vcs = [UIViewController]()
        
        let groups = floors
            .filter { $0.waveGroupId != 0 }
            .reduce(into: [Int: [SecretFloor]]()) {
                $0[$1.difficulty, default: [SecretFloor]()].append($1)
            }
            .sorted { $0.key > $1.key }
            .map { $0.value }
        
        for group in groups {
            let vc = QuestEnemyTableViewController(floors: group)
            let format = NSLocalizedString("D%d", comment: "")
            let title = String(format: format, group.first.flatMap { $0.difficulty } ?? 0)
            items.append(TMBarItem(title: title))
            vcs.append(vc)
        }
        
        viewControllers = vcs
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
        return .at(index: 0)
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return items[index]
    }
}
