//
//  CardNavigationController.swift
//  PrincessGuide
//
//  Created by zzk on 6/2/20.
//  Copyright © 2020 zzk. All rights reserved.
//

import UIKit

class CardNavigationController: UINavigationController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        updateListStyle(style: CardSortingViewController.Setting.default.listStyle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateListStyle(style: CardSortingViewController.Setting.default.listStyle)
    }

    private func commonInit() {
        switch CardSortingViewController.Setting.default.listStyle {
        case .collection:
            viewControllers = [SearchableHomeCardCollectionViewController()]
        case .table:
            viewControllers = [HomeCardTableViewController()]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleFilterChange(_:)), name: .cardSortingSettingsDidChange, object: nil)
    }
    
    @objc func handleFilterChange(_ notification: Notification) {
        updateListStyle(style: CardSortingViewController.Setting.default.listStyle)
    }

    func updateListStyle(style: CardSortingViewController.Setting.ListStyle) {
        switch CardSortingViewController.Setting.default.listStyle {
        case .collection:
            viewControllers = [SearchableHomeCardCollectionViewController()]
        case .table:
            viewControllers = [HomeCardTableViewController()]
        }
    }

}
