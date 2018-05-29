//
//  EquipmentViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class EquipmentViewController: UIViewController, DataChecking {
    
    var equipments = [Equipment]()
    
    let refresher = RefreshHeader()
    
    let backgroundImageView = UIImageView()
    
    private var collectionView: UICollectionView!
    
    private var layout: UICollectionViewFlowLayout!
    
    let equipmentType: EquipmentType
    
    init(equipmentType: EquipmentType) {
        self.equipmentType = equipmentType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateEnd(_:)), name: .updateConsoleVariblesEnd, object: nil)

        navigationItem.title = NSLocalizedString("Equipments", comment: "")
        
        layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        layout.itemSize = CGSize(width: 64, height: 64)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
//        collectionView.contentInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(EquipmentCollectionViewCell.self, forCellWithReuseIdentifier: EquipmentCollectionViewCell.description())
        
        collectionView.mj_header = refresher
        // fix a layout issue of mjrefresh
        // refresher.bounds.origin.y = collectionView.contentInset.top
        refresher.refreshingBlock = { [weak self] in self?.check() }
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            let navigationBar = themeable.navigationController?.navigationBar
            navigationBar?.tintColor = theme.color.tint
            navigationBar?.barStyle = theme.barStyle
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.refresher.arrowImage.tintColor = theme.color.indicator
            themeable.refresher.loadingView.color = theme.color.indicator
            themeable.collectionView.indicatorStyle = theme.indicatorStyle
        }
        
        loadData()

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleUpdateEnd(_ notification: Notification) {
        loadData()
    }
    
    private func loadData() {
        LoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Master.shared.getEquipments(equipmentType: self?.equipmentType, callback: { (equipments) in
                DispatchQueue.main.async {
                    LoadingHUDManager.default.hide()
                    self?.equipments = equipments.sorted { ($0.promotionLevel, $0.salePrice, $0.equipmentId) > ($1.promotionLevel, $1.salePrice, $1.equipmentId) }
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
        if equipment.craftFlg == 0 {
            DropSummaryTableViewController.configureAsync(equipment: equipment, callback: { [weak self] (vc) in
                self?.navigationController?.pushViewController(vc, animated: true)
            })
        } else {
            let vc = CraftTableViewController()
            vc.navigationItem.title = equipment.equipmentName
            vc.equipment = equipment
            vc.hidesBottomBarWhenPushed = true
            LoadingHUDManager.default.hide()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EquipmentCollectionViewCell.description(), for: indexPath) as! EquipmentCollectionViewCell
        cell.configure(for: equipments[indexPath.row])
        return cell
    }
}
