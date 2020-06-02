//
//  SearchableHomeCardCollectionViewController.swift
//  PrincessGuide
//
//  Created by zzk on 6/2/20.
//  Copyright © 2020 zzk. All rights reserved.
//

import UIKit

class SearchableHomeCardCollectionViewController: HomeCardCollectionViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch searchController.isActive {
        case true:
            return 1
        default:
            return super.numberOfSections(in: collectionView)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch searchController.isActive {
        case true:
            return filteredCards.count
        default:
            return super.collectionView(collectionView, numberOfItemsInSection: section)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch searchController.isActive {
        case true:
            return .zero
        default:
            return super.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section)
        }
    }
    
    override func cardOf(indexPath: IndexPath) -> Card {
        switch searchController.isActive {
        case true:
            return filteredCards[indexPath.item]
        default:
            return super.cardOf(indexPath: indexPath)
        }
    }
    
}

extension SearchableHomeCardCollectionViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        filteredCards = cards.filter { $0.base.kana.contains(searchText) ||
            $0.base.unitName.contains(searchText) ||
            ($0.actualUnit?.unitName.contains(searchText) ?? false)
        }
        
        collectionView.reloadData()
    }
    
}
