//
//  SearchableAddTeamToTeamViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/14.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
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
        searchController.hidesNavigationBarDuringPresentation = true
        definesPresentationContext = true
        searchController.searchBar.tintColor = Theme.dynamic.color.tint
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
        navigationItem.searchController = searchController
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
