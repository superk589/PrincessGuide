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

class MinionTabViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {
    
    static var defaultTabIndex: Int = 0
    
    private var viewControllers: [MinionTableViewController]
    
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
        
        let optionsItem = UIBarButtonItem(title: NSLocalizedString("Options", comment: ""), style: .plain, target: self, action: #selector(handleOptionsItem(_:)))
        let exportItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleExportItem(_:)))
        navigationItem.rightBarButtonItems = [optionsItem, exportItem]

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
        
        view.backgroundColor = Theme.dynamic.color.background
        bar.indicator.tintColor = Theme.dynamic.color.tint
        bar.buttons.customize { (button) in
            button.selectedTintColor = Theme.dynamic.color.tint
            button.tintColor = Theme.dynamic.color.lightText
        }
        systemBar.backgroundStyle = .blur(style: .systemMaterial)
    }
    
    @objc private func handleExportItem(_ item: UIBarButtonItem) {
        if let index = self.currentIndex,
            let foregroundImage = viewControllers[index].tableView.screenshot() {
            
            var image = foregroundImage
            if let navigationBarImage = navigationController?.navigationBar.screenshot(),
                let navigationBarImageWithBackground = navigationBarImage.addBackground(.systemBackground) {
                image = UIImage.verticalImage(from: [navigationBarImageWithBackground, image])
            }
            UIActivityViewController.show(images: [image], pointTo: item, in: self)
        }
    }
    
    @objc private func handleOptionsItem(_ item: UIBarButtonItem) {
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
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, willScrollToPageAt index: TabmanViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        super.pageboyViewController(pageboyViewController, willScrollToPageAt: index, direction: direction, animated: animated)
        let vc = viewControllers[index]
        guard vc is MinionSkillViewController || vc is MinionPropertyViewController else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.performWithoutAnimation {
                vc.tableView.beginUpdates()
                vc.tableView.endUpdates()
            }
        }
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didReloadWith currentViewController: UIViewController, currentPageIndex: TabmanViewController.PageIndex) {
        super.pageboyViewController(pageboyViewController, didReloadWith: currentViewController, currentPageIndex: currentPageIndex)
        guard let vc = currentViewController as? MinionTableViewController else { return }
        guard vc is MinionSkillViewController || vc is MinionPropertyViewController else { return }
        DispatchQueue.main.async {
            UIView.performWithoutAnimation {
                vc.tableView.beginUpdates()
                vc.tableView.endUpdates()
            }
        }
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return items[index]
    }
    
}
