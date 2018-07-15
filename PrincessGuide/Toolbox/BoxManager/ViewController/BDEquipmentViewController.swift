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

class BDEquipmentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let box: Box
    
    let context: NSManagedObjectContext
    
    let parentContext: NSManagedObjectContext?
    
    private var collectionView: UICollectionView!
    
    private var layout: UICollectionViewFlowLayout!
    
    private var observer: ManagedObjectObserver?
    
    init(box: Box) {
        parentContext = box.managedObjectContext
        context = CoreDataStack.default.newChildContext(parent: parentContext ?? CoreDataStack.default.viewContext, concurrencyType: .privateQueueConcurrencyType)
        self.box = box
        super.init(nibName: nil, bundle: nil)
        
        observer = ManagedObjectObserver(object: box, changeHandler: { [weak self] (type) in
            if type == .delete {
                self?.navigationController?.popViewController(animated: true)
            } else if type == .update {
                self?.loadData()
            }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let backgroundImageView = UIImageView()
    
    private var consumes = [Craft.Consume]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
                
        layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        if #available(iOS 11.0, *) {
            layout.sectionInsetReference = .fromSafeArea
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        // layout.itemSize = CGSize(width: 64, height: 92)
        layout.itemSize = CGSize(width: 64, height: 78)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        collectionView.register(CraftSummaryCollectionViewCell.self, forCellWithReuseIdentifier: CraftSummaryCollectionViewCell.description())
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollsToTop = false
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            let navigationBar = themeable.navigationController?.navigationBar
            navigationBar?.tintColor = theme.color.tint
            navigationBar?.barStyle = theme.barStyle
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.collectionView.indicatorStyle = theme.indicatorStyle
        }
        
        loadData()
    }

    func loadData() {
        let objectID = box.objectID
        LoadingHUDManager.default.show()
        context.perform { [weak self] in
            let box = self?.context.object(with: objectID) as? Box
            let charas = box?.charas?.array as? [Chara] ?? []
            let consumes: [Craft.Consume] = charas.flatMap { (chara) -> [Craft.Consume] in
                var array = [Craft.Consume]()
                if let promotions = chara.card?.promotions, promotions.count >= chara.rank {
                    let currentPromotion = promotions[Int(chara.rank - 1)]
                    let higherPromotions = promotions[Int(chara.rank)..<promotions.count]
                    
                    array += currentPromotion.equipmentsInSlot.enumerated().flatMap { (offset, element) -> [Craft.Consume] in
                        if chara.slots[safe: offset] ?? false {
                            return []
                        } else {
                            return element?.recursiveConsumes ?? []
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
                self?.collectionView.reloadData()
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return consumes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CraftSummaryCollectionViewCell.description(), for: indexPath) as! CraftSummaryCollectionViewCell
        let consume = consumes[indexPath.item]
        cell.configure(for: consume)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let consume = consumes[indexPath.item]
        if let equipment = consume.equipment {
            DropSummaryTableViewController.configureAsync(equipment: equipment) { [weak self] (vc) in
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
