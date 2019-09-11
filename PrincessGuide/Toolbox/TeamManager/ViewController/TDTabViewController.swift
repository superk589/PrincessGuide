//
//  TDTabViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/14.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Tabman
import Pageboy
import SwiftyJSON
import CoreData

class TDTabViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {
    
    static var defaultTabIndex: Int = 1
    
    private var viewControllers: [UIViewController]
    
    private var team: Team
    
    init(team: Team) {
        self.team = team
        viewControllers = [
            TDBattleViewController(team: team, predicate: NSPredicate(format: "%K CONTAINS %@", #keyPath(Team.wins), team)),
            TDBattleViewController(team: team, predicate: NSPredicate(format: "%K CONTAINS %@", #keyPath(Team.loses), team)),
            EditTeamViewController(team: team)
        ]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var items = [TMBarItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Team Detail", comment: "")
        
        let items = [
            NSLocalizedString("Loses", comment: ""),
            NSLocalizedString("Wins", comment: ""),
            NSLocalizedString("Edit", comment: "")
            ].map { TMBarItem(title: $0) }
        
        self.items = items
        
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
        return .at(index: TDTabViewController.defaultTabIndex)
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: Int, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        super.pageboyViewController(pageboyViewController, didScrollToPageAt: index, direction: direction, animated: animated)
        TDTabViewController.defaultTabIndex = index
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return items[index]
    }
}
