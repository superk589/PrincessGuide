//
//  SearchableTeamTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/13.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt
import CoreData

class SearchableTeamTableViewController: TeamTableViewController {
    
    var searchedResultsController: NSFetchedResultsController<Team>?
    
    var searchedTeams: [Team] = []
    
    private func performSearch(_ searchText: String) {
        let request: NSFetchRequest<Team> = Team.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "modifiedAt", ascending: false)]
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "%K CONTAINS[c] %@", #keyPath(Team.tag), searchText),
            NSPredicate(format: "%K CONTAINS[c] %@", #keyPath(Team.name), searchText)
        ])
        request.returnsObjectsAsFaults = false
        do {
            searchedTeams = try context.fetch(request)
        } catch (let error) {
            print(error)
        }
    }
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = NSLocalizedString("Team Tag", comment: "")
        searchController.searchResultsUpdater = self
        searchController.delegate = self
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
    
    override func teamOf(indexPath: IndexPath) -> Team {
        switch searchController.isActive {
        case true:
            return searchedTeams[indexPath.row]
        default:
            return super.teamOf(indexPath: indexPath)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        switch searchController.isActive {
        case true:
            return 1
        default:
            return super.numberOfSections(in: tableView)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch searchController.isActive {
        case true:
            return nil
        default:
            return super.tableView(tableView, titleForHeaderInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchController.isActive {
        case true:
            return searchedTeams.count
        default:
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        switch searchController.isActive {
        case true:
            return .none
        default:
            return super.tableView(tableView, editingStyleForRowAt: indexPath)
        }
    }

}

extension SearchableTeamTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        performSearch(searchText)
        tableView.reloadData()
    }
    
}
