//
//  AddTeamToTeamViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/14.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import CoreData
import Gestalt

protocol AddTeamToTeamViewControllerDelegate: class {
    func addTeamToTeamViewControllerDidSave(_ addTeamToTeamViewController: AddTeamToTeamViewController)
}

class AddTeamToTeamViewController: UITableViewController {
    
    weak var delegate: AddTeamToTeamViewControllerDelegate?
    
    let team: Team
    
    let parentContext: NSManagedObjectContext
    
    let context: NSManagedObjectContext
    
    enum Mode {
        case win
        case lose
    }
    
    let mode: Mode
    
    init(team: Team, parentContext: NSManagedObjectContext, mode: Mode) {
        self.mode = mode
        self.parentContext = parentContext
        context = CoreDataStack.default.newChildContext(parent: parentContext)
        self.team = context.object(with: team.objectID) as! Team
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        }
        
        tableView.register(TeamTableViewCell.self, forCellReuseIdentifier: TeamTableViewCell.description())
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 104
        tableView.rowHeight = UITableView.automaticDimension
        prepareFetchRequest()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTeam(_:)))
        toolbarItems = [selectItem, spaceItem, deselectItem]
        tableView.setEditing(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    @objc private func selectAllCharas(_ item: UIBarButtonItem) {
        for i in 0..<teams.count {
            tableView.selectRow(at: IndexPath(row: i, section: 0), animated: false, scrollPosition: .none)
        }
        if mode == .win {
            team.addToWins(NSSet(array: teams))
        } else {
            team.addToLoses(NSSet(array: teams))
        }
    }
    
    @objc private func deselectAllCharas(_ item: UIBarButtonItem) {
        for i in 0..<teams.count {
            tableView.deselectRow(at: IndexPath(row: i, section: 0), animated: false)
        }
        if mode == .win {
            team.removeFromWins(NSSet(array: teams))
        } else {
            team.removeFromLoses(NSSet(array: teams))
        }
    }
    
    func teamOf(indexPath: IndexPath) -> Team {
        return teams[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle(rawValue: 0b11)!
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if mode == .win {
            if let wins = team.wins, wins.contains(teamOf(indexPath: indexPath)) {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        } else {
            if let loses = team.loses, loses.contains(teamOf(indexPath: indexPath)) {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mode == .win {
            team.addToWins(teamOf(indexPath: indexPath))
        } else {
            team.addToLoses(teamOf(indexPath: indexPath))
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if mode == .win {
            team.removeFromWins(teamOf(indexPath: indexPath))
        } else {
            team.removeFromLoses(teamOf(indexPath: indexPath))
        }
    }
    
    @objc private func saveTeam(_ item: UIBarButtonItem) {
        team.modifiedAt = Date()
        do {
            try context.save()
            // try parentContext.save()
        } catch (let error) {
            print(error)
        }
        navigationController?.popViewController(animated: true)
        delegate?.addTeamToTeamViewControllerDidSave(self)
    }
    
    var fetchedResultsController: NSFetchedResultsController<Team>?
    
    var teams: [Team] {
        return fetchedResultsController?.fetchedObjects ?? []
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
    
    private(set) lazy var selectItem = UIBarButtonItem(title: NSLocalizedString("Select All", comment: ""), style: .plain, target: self, action: #selector(selectAllCharas(_:)))
    private(set) lazy var deselectItem = UIBarButtonItem(title: NSLocalizedString("Deselect All", comment: ""), style: .plain, target: self, action: #selector(deselectAllCharas(_:)))
    private(set) lazy var spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeamTableViewCell.description(), for: indexPath) as! TeamTableViewCell
        let team = teamOf(indexPath: indexPath)
        cell.configure(for: team)
        return cell
    }
}
