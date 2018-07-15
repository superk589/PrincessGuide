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
import StoreKit
import Gestalt

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
        SKPaymentQueue.default().add(self)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        request?.delegate = nil
        request?.cancel()
        SKPaymentQueue.default().remove(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    private var request: SKProductsRequest?
    func requestData() {
        request = SKProductsRequest(productIdentifiers: Constant.iAPProductIDs)
        request?.delegate = self
        request?.start()
    }
    
    @objc private func restore(_ item: UIBarButtonItem) {
        LoadingHUDManager.default.show()
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    private func didUpgradeToProEdition() {
        let alert = UIAlertController(title: NSLocalizedString("Attention", comment: ""), message: NSLocalizedString("Upgrade is done. Thank you for your purchase and supporting for our development.", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: { [weak self] (action) in
            alert.dismiss(animated: true, completion: nil)
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
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
    
}

// MARK: ProductTableViewCellDelegate

extension BuyProEditionViewController: ProductTableViewCellDelegate {
    func productTableViewCell(_ productTableViewCell: ProductTableViewCell, didSelect product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            LoadingHUDManager.default.show()
            SKPaymentQueue.default().add(SKPayment(product: product))
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Attention", comment: ""), message: NSLocalizedString("Your device does not allow in-app purchasing.", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
}


// MARK: StoreKitDelegate

extension BuyProEditionViewController: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            DispatchQueue.main.async { [weak self] in
                self?.rows[2].data = .button(product)
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: StoreKitTransactionObserver

extension BuyProEditionViewController: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                completeTransaction(transaction)
                finishTransaction(transaction)
            case .failed:
                failedTransaction(transaction)
                finishTransaction(transaction)
            case .restored:
                restoreTransaction(transaction)
                finishTransaction(transaction)
            case .deferred:
                finishTransaction(transaction)
            case .purchasing:
                break
            }
        }
    }
    
    func completeTransaction(_ transaction: SKPaymentTransaction) {
        Defaults.proEdition = true
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: .proEditionPurchased, object: nil)
        didUpgradeToProEdition()
    }
    
    func failedTransaction(_ transaction: SKPaymentTransaction) {
        if let error = transaction.error {
            print(error)
        }
    }
    
    func restoreTransaction(_ transaction: SKPaymentTransaction) {
        Defaults.proEdition = true
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: .proEditionPurchased, object: nil)
        didUpgradeToProEdition()
    }
    
    func finishTransaction(_ transaction: SKPaymentTransaction) {
        LoadingHUDManager.default.hide()
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        LoadingHUDManager.default.hide()
        var restored = false
        label: for transaction in queue.transactions {
            for id in Constant.iAPProductIDs {
                if transaction.payment.productIdentifier == id {
                    restored = true
                    break label
                }
            }
        }
        if !restored {
            let alert = UIAlertController(title: NSLocalizedString("Restore Failed", comment: ""), message: NSLocalizedString("You have not bought this product yet.", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        LoadingHUDManager.default.hide()
    }
}
