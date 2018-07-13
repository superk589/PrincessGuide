//
//  ChooseTeamViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/13.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import CoreData
import Gestalt

protocol ChooseTeamViewControllerDelegate: class {
    func chooseTeamViewControllerDidSave(_ chooseTeamViewController: ChooseTeamViewController, didChoose team: Team)
}

class ChooseTeamViewController: UITableViewController {
    
    weak var delegate: ChooseTeamViewControllerDelegate?
    
    var fetchedResultsController: NSFetchedResultsController<Team>?
    
    var teams: [Team] {
        return fetchedResultsController?.fetchedObjects ?? []
    }
    
    let context: NSManagedObjectContext
    
    var selectedTeams: [Team]
    
    init(teams: [Team] = [], context: NSManagedObjectContext) {
        selectedTeams = teams
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let backgroundImageView = UIImageView()
    
    private func prepareFetchRequest() {
        let request: NSFetchRequest<Team> = Team.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "modifiedAt", ascending: false)]
        request.returnsObjectsAsFaults = false
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        try? fetchedResultsController?.performFetch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Choose Team", comment: "")
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.tableView.indicatorStyle = theme.indicatorStyle
            themeable.navigationController?.toolbar.barStyle = theme.barStyle
            themeable.navigationController?.toolbar.tintColor = theme.color.tint
        }
        
        tableView.register(TeamTableViewCell.self, forCellReuseIdentifier: TeamTableViewCell.description())
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 103
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.setEditing(true, animated: false)
        
        prepareFetchRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle(rawValue: 0b11)!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let team = teams[indexPath.row]
        selectedTeams.append(team)
        delegate?.chooseTeamViewControllerDidSave(self, didChoose: team)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeamTableViewCell.description(), for: indexPath) as! TeamTableViewCell
        let team = teams[indexPath.row]
        cell.configure(for: team)
        return cell
    }
}
