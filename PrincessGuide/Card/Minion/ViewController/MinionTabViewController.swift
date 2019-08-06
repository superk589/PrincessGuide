//
//  MinionTabViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/12/1.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Tabman
import Pageboy
import Gestalt

class MinionTabViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {
    
    static var defaultTabIndex: Int = 0
    
    private var viewControllers: [UIViewController]
    
    private var minion: Minion
    
    init(minion: Minion) {
        self.minion = minion
        viewControllers = [MinionSkillViewController(minion: minion), MinionPropertyViewController(minion: minion)]
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = minion.base.unitName
        print("load minion, id: \(minion.base.unitId)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var items = [TMBarItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Options", comment: ""), style: .plain, target: self, action: #selector(handleNavigationRightItem(_:)))

        let items = [
                 NSLocalizedString("Skill", comment: ""),
                 NSLocalizedString("Status", comment: "")
            ]
            .map { TMBarItem(title: $0) }
        self.items = items
        
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
    
    @objc private func handleNavigationRightItem(_ item: UIBarButtonItem) {
        let vc = CDSettingsViewController()
        let nc = UINavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .formSheet
        present(nc, animated: true, completion: nil)
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: MinionTabViewController.defaultTabIndex)
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: Int, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        super.pageboyViewController(pageboyViewController, didScrollToPageAt: index, direction: direction, animated: animated)
        MinionTabViewController.defaultTabIndex = index
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return items[index]
    }
    
}
