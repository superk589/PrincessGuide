//
//  BuyProEditionViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/14.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import SnapKit
import Eureka
import Gestalt
import StoreKit
import SwiftyStoreKit

extension Notification.Name {
    
    static let proEditionPurchased = Notification.Name(rawValue: "pro_edition_purchased")
}

class BuyProEditionViewController: UITableViewController {
    
    struct FAQ {
        var question: String
        var answer: String
    }

    let faqs = [
        FAQ(question: NSLocalizedString("What's the features of Pro Edition?", comment: ""),
            answer: NSLocalizedString("By now, chara management, box management and team management are only available in pro edition. If we add new features to pro edition in the future, you will gain those features automatically without paying for it again.", comment: "")),
        FAQ(question: NSLocalizedString("How to restore purchasing on a new device?", comment: ""),
            answer: NSLocalizedString("Make sure you have signed-in using the same Apple ID on the new device, then click the restore button on this page.", comment: ""))
    ]
    
    struct Row {
        enum Model {
            case faq(FAQ)
            case button(SKProduct?)
        }
        var type: UITableViewCell.Type
        var data: Model
    }
    
    var rows = [Row]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        rows += faqs.map {
            Row(type: FAQTableViewCell.self, data: .faq($0))
        }
        rows.append(Row(type: ProductTableViewCell.self, data: .button(nil)))
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUpgradeToProEdition(_:)), name: .proEditionPurchased, object: nil)
        
        prepareUI()
        requestData()
        // Do any additional setup after loading the view.
    }
    
    let backgroundImageView = UIImageView()

    func prepareUI() {
        
        navigationItem.title = NSLocalizedString("Pro Edition", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Restore", comment: ""), style: .plain, target: self, action: #selector(restore(_:)))
        
        tableView.backgroundView = backgroundImageView
        tableView.cellLayoutMarginsFollowReadableWidth = true
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.tableView.indicatorStyle = theme.indicatorStyle
            themeable.tableView.backgroundColor = theme.color.background
            themeable.view.tintColor = theme.color.tint
        }
        
        tableView.register(FAQTableViewCell.self, forCellReuseIdentifier: FAQTableViewCell.description())
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.description())
        
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func requestData() {
        SwiftyStoreKit.retrieveProductsInfo(Constant.iAPProductIDs) { [weak self] result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
                self?.rows[2].data = .button(product)
                self?.tableView.reloadData()
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else if let error = result.error {
                print(error)
                // self?.alert(content: error.localizedDescription)
            }
        }
    }
    
    @objc private func restore(_ item: UIBarButtonItem) {
        LoadingHUDManager.default.show()
        SwiftyStoreKit.restorePurchases(atomically: true) { [weak self] results in
            LoadingHUDManager.default.hide()
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                for purchase in results.restoredPurchases {
                    if Constant.iAPProductIDs.contains(purchase.productId) {
                        Defaults.proEdition = true
                        NotificationCenter.default.post(name: .proEditionPurchased, object: nil)
                        break
                    }
                }
                
            }
            else {
                print("Nothing to Restore")
                self?.alert(content: NSLocalizedString("You have not bought this product yet.", comment: ""))
            }
        }
    }
    
    @objc private func didUpgradeToProEdition(_ notification: Notification) {
        navigationController?.popViewController(animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.type.description(), for: indexPath)
        switch row.data {
        case .faq(let faq):
            (cell as? FAQTableViewCell)?.configure(question: faq.question, answer: faq.answer)
        case .button(let product):
            (cell as? ProductTableViewCell)?.configure(for: product)
            (cell as? ProductTableViewCell)?.delegate = self
        }
        return cell
    }
    
    private func alert(content: String) {
        let alert = UIAlertController(title: NSLocalizedString("Attention", comment: ""), message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: ProductTableViewCellDelegate

extension BuyProEditionViewController: ProductTableViewCellDelegate {
    func productTableViewCell(_ productTableViewCell: ProductTableViewCell, didSelect product: SKProduct) {
        LoadingHUDManager.default.show()
        SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: true) { result in
            LoadingHUDManager.default.hide()
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                if Constant.iAPProductIDs.contains(purchase.productId) {
                    Defaults.proEdition = true
                    NotificationCenter.default.post(name: .proEditionPurchased, object: nil)
                }
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                }
                // self?.alert(content: error.localizedDescription)
            }
        }
    }
}
