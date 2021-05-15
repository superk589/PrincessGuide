//
//  ProductTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/14.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import StoreKit

protocol ProductTableViewCellDelegate: AnyObject {
    func productTableViewCell(_ productTableViewCell: ProductTableViewCell, didSelect product: SKProduct)
}

class ProductTableViewCell: UITableViewCell {

    let indicator = UIActivityIndicatorView(style: .medium)
    
    let button = UIButton()
    
    weak var delegate: ProductTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        indicator.startAnimating()
        
        contentView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
            make.bottom.equalTo(-20)
        }
        
        selectionStyle = .none
        
        button.setTitleColor(Theme.dynamic.color.tint, for: .normal)
        button.setTitleColor(Theme.dynamic.color.title, for: .highlighted)
        indicator.color = Theme.dynamic.color.indicator
    }
    
    private var product: SKProduct?
    
    func configure(for product: SKProduct?) {
        if let product = product {
            isLoading = false
            self.product = product
            button.addTarget(self, action: #selector(purchase(_:)), for: .touchUpInside)
            button.setTitle("\(product.localizedTitle) \(product.priceLocale.currencySymbol ?? "")\(product.price.stringValue)", for: .normal)
        }
    }
    
    @objc private func purchase(_ sender: UIButton) {
        if let product = product {
            delegate?.productTableViewCell(self, didSelect: product)
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                indicator.startAnimating()
                button.isHidden = true
            } else {
                indicator.stopAnimating()
                button.isHidden = false
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
