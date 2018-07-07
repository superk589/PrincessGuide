//
//  BDTabViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Tabman
import Pageboy
import Gestalt

protocol BoxDetailConfigurable {
    init(box: Box)
}

class BDTabViewController: TabmanViewController, PageboyViewControllerDataSource {
    
    static var defaultTabIndex: Int = 1
    
    private var viewControllers: [BoxDetailConfigurable & UIViewController]
    
    private var box: Box
    
    init(box: Box) {
        self.box = box
        viewControllers = [
            BDEquipmentViewController(box: box),
            BDInfoViewController(box: box),
            EditBoxViewController(box: box)
        ]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Box Detail", comment: "")
        
        let items = [
            NSLocalizedString("Equipment", comment: ""),
            NSLocalizedString("Info", comment: ""),
            NSLocalizedString("Edit", comment: "")
        ].map { Item(title: $0) }
        
        dataSource = self
        bar.items = items
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
        return .at(index: BDTabViewController.defaultTabIndex)
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: Int, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        super.pageboyViewController(pageboyViewController, didScrollToPageAt: index, direction: direction, animated: animated)
        BDTabViewController.defaultTabIndex = index
    }
}
