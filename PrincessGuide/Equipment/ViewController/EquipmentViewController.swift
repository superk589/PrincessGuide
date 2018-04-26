//
//  EquipmentViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class EquipmentViewController: UIViewController {
    
    var equipments = [Equipment]()
    
    private var collectionView: UICollectionView!
    
    private var layout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = NSLocalizedString("Equipments", comment: "")

        layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        layout.itemSize = CGSize(width: 64, height: 64)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(EquipmentCollectionViewCell.self, forCellWithReuseIdentifier: EquipmentCollectionViewCell.description())
        
        loadData()

    }
    
    private func loadData() {
        LoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Master.shared.getEquipments(callback: { (equipments) in
                DispatchQueue.main.async {
                    LoadingHUDManager.default.hide()
                    self?.equipments = equipments.filter { $0.craftFlg == 0 }.sorted { $0.promotionLevel > $1.promotionLevel }
                    self?.collectionView.reloadData()
                }
            })
        }
    }
    
}

extension EquipmentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return equipments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let equipment = equipments[indexPath.item]
        LoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Master.shared.getQuests(containsEquipment: equipment.equipmentId) { quests in
                DispatchQueue.main.async {
                    let vc = QuestTableViewController()
                    vc.navigationItem.title = equipment.equipmentName
                    vc.quests = quests.sorted { $0.allRewards.first { $0.rewardID == equipment.equipmentId }!.odds > $1.allRewards.first { $0.rewardID == equipment.equipmentId }!.odds }
                    vc.hidesBottomBarWhenPushed = true
                    vc.focusedItemID = equipment.equipmentId
                    LoadingHUDManager.default.hide()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EquipmentCollectionViewCell.description(), for: indexPath) as! EquipmentCollectionViewCell
        cell.configure(for: equipments[indexPath.row])
        return cell
    }
}
