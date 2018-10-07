//
//  SearchableAddTeamToTeamViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/14.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt
import CoreData

class SearchableAddTeamToTeamViewController: AddTeamToTeamViewController {
    
    private func performSearch(_ searchText: String) {
        fetchedResultsController?.fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "%K CONTAINS[c] %@", #keyPath(Team.tag), searchText),
            NSPredicate(format: "%K CONTAINS[c] %@", #keyPath(Team.name), searchText)
        ])
        try? fetchedResultsController?.performFetch()
    }
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = NSLocalizedString("Team Tag", comment: "")
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        definesPresentationContext = true
        return searchController
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if navigationController?.navigationBar.barStyle == .default {
            return .default
        } else {
            return .lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        }
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.searchController.searchBar.tintColor = theme.color.tint
        }
    }
    
}

extension SearchableAddTeamToTeamViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        performSearch(searchText)
        tableView.reloadData()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        fetchedResultsController?.fetchRequest.predicate = nil
        try? fetchedResultsController?.performFetch()
        tableView.reloadData()
    }
    
}
