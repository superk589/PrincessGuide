//
//  SearchableCardTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/28.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class SearchableCardTableViewController: CardTableViewController {
    
    var filteredCards = [Card]()

    lazy var searchController: UISearchController = { [unowned self] in
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = NSLocalizedString("Chara Name", comment: "")
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.tintColor = Theme.dynamic.color.tint
        searchController.searchBar.backgroundColor = .systemBackground
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
            return filteredCards.count
        default:
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func cardOf(indexPath: IndexPath) -> Card {
        if searchController.isActive {
            return filteredCards[indexPath.row]
        } else {
            return super.cardOf(indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch searchController.isActive {
        case true:
            let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.description(), for: indexPath) as! CardTableViewCell
            let card = filteredCards[indexPath.row]
            let (mode, text) = cardViewRightContent(card: card, settings: CardSortingViewController.Setting.default)
            cell.configure(for: filteredCards[indexPath.row], value: text, mode: mode)
            return cell
        default:
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch searchController.isActive {
        case true:
            let card = filteredCards[indexPath.row]
            let vc = CDTabViewController(card: card)
            print("card id: \(card.base.unitId)")
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        default:
            super.tableView(tableView, didSelectRowAt: indexPath)
        }
    }

}

extension SearchableCardTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        filteredCards = cards.filter { $0.base.kana.contains(searchText) ||
            $0.base.unitName.contains(searchText) ||
            ($0.actualUnit?.unitName.contains(searchText) ?? false)
        }
        
        tableView.reloadData()
    }
    
}
