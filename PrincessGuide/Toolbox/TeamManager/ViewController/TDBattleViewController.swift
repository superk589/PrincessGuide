//
//  TDBattleViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/14.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import CoreData
import Gestalt

class TDBattleViewController: UITableViewController {
    
    var fetchedResultsController: NSFetchedResultsController<Team>?
    var context: NSManagedObjectContext {
        return CoreDataStack.default.viewContext
    }
    
    private var team: Team
    private var predicate: NSPredicate
    
    init(team: Team, predicate: NSPredicate) {
        self.team = team
        self.predicate = predicate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var teams: [Team] {
        return fetchedResultsController?.fetchedObjects ?? []
    }
    
    private let backgroundImageView = UIImageView()
    
    private func prepareFetchRequest() {
        let request: NSFetchRequest<Team> = Team.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "modifiedAt", ascending: false)]
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        try? fetchedResultsController?.performFetch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Teams", comment: "")
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.tableView.indicatorStyle = theme.indicatorStyle
            themeable.navigationController?.toolbar.barStyle = theme.barStyle
            themeable.navigationController?.toolbar.tintColor = theme.color.tint
            themeable.tableView.backgroundColor = theme.color.background
        }
        
        tableView.register(TeamTableViewCell.self, forCellReuseIdentifier: TeamTableViewCell.description())
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 104
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        prepareFetchRequest()
    }
    
    func teamOf(indexPath: IndexPath) -> Team {
        return teams[indexPath.row]
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let team = teamOf(indexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: TeamTableViewCell.description(), for: indexPath) as! TeamTableViewCell
        cell.configure(for: team)
        return cell
    }
    
}
