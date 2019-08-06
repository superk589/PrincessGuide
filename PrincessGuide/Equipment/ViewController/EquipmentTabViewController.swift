//
//  EquipmentTabViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/6.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Tabman
import Pageboy
import Gestalt

class EquipmentTabViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {
    
    private var viewControllers = [UIViewController]()
    
    private var items = [TMBarItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("Equipments", comment: "")
        viewControllers = [EquipmentViewController(equipmentType: .dropped), EquipmentViewController(equipmentType: .crafted), UniqueEquipmentViewController()]
        dataSource = self
        self.items = EquipmentType.allCases.map { TMBarItem(title: $0.description) }
        
        let bar = TMBarView<TMHorizontalBarLayout, TMLabelBarButton, TMBarIndicator.None>()
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bar.layout.transitionStyle = .progressive
        addBar(bar, dataSource: self, at: .bottom)
        
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
            bar.backgroundView.style = .blur(style: theme.blurEffectStyle)
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
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return items[index]
    }
    
}
