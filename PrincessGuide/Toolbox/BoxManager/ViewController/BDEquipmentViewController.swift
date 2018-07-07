//
//  BDEquipmentViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt
import CoreData

class BDEquipmentViewController: UITableViewController, BoxDetailConfigurable {
    
    let box: Box
    
    let context: NSManagedObjectContext
    
    let parentContext: NSManagedObjectContext?
    
    let refresher = RefreshHeader()
    
    required init(box: Box) {
        parentContext = box.managedObjectContext
        context = CoreDataStack.default.newChildContext(parent: parentContext ?? CoreDataStack.default.viewContext, concurrencyType: .privateQueueConcurrencyType)
        self.box = box
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let backgroundImageView = UIImageView()
    
    private var consumes = [Craft.Consume]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.tableView.indicatorStyle = theme.indicatorStyle
            themeable.refresher.arrowImage.tintColor = theme.color.indicator
            themeable.refresher.loadingView.color = theme.color.indicator
        }
        
        tableView.estimatedRowHeight = 84
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(CraftTableViewCell.self, forCellReuseIdentifier: CraftTableViewCell.description())
        tableView.tableFooterView = UIView()
        
        tableView.mj_header = refresher
        refresher.refreshingBlock = { [weak self] in self?.loadData() }
        
        loadData()
    }

    func loadData() {
        defer {
            refresher.endRefreshing()
        }
        let objectID = box.objectID
        LoadingHUDManager.default.show()
        context.perform { [weak self] in
            let box = self?.context.object(with: objectID) as? Box
            let charas = box?.charas?.allObjects as? [Chara] ?? []
            let consumes: [Craft.Consume] = charas.flatMap { (chara) -> [Craft.Consume] in
                var array = [Craft.Consume]()
                if let promotions = chara.card?.promotions, promotions.count >= chara.rank {
                    let currentPromotion = promotions[Int(chara.rank - 1)]
                    let higherPromotions = promotions[Int(chara.rank)..<promotions.count]
                    
                    array += currentPromotion.equipmentsInSlot.enumerated().flatMap { (offset, element) -> [Craft.Consume] in
                        if !chara.slots[offset] {
                            return element?.recursiveConsumes ?? []
                        } else {
                            return []
                        }
                    }
                    
                    array += higherPromotions.flatMap {
                        $0.equipmentsInSlot.enumerated().flatMap { (offset, element) -> [Craft.Consume] in
                            element?.recursiveConsumes ?? []
                        }
                    }
                }
                return array
            }
            let mergedConsumes = consumes.reduce(into: [Craft.Consume]()) { (result, consume) in
                if let index = result.index(where: { $0.equipmentID == consume.equipmentID }) {
                    let removedConsume = result.remove(at: index)
                    result.append(Craft.Consume(equipmentID: removedConsume.equipmentID, consumeNum: removedConsume.consumeNum + consume.consumeNum))
                } else {
                    result.append(consume)
                }
            }
            
            let sortedConsumes = mergedConsumes.sorted { $0.consumeNum > $1.consumeNum }
            DispatchQueue.main.async {
                LoadingHUDManager.default.hide()
                self?.consumes = sortedConsumes
                self?.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consumes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CraftTableViewCell.description(), for: indexPath) as! CraftTableViewCell
        let consume = consumes[indexPath.row]
        cell.configure(for: consume)
        return cell
    }
}
