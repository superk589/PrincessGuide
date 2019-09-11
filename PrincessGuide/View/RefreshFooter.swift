//
//  RefreshFooter.swift
//  PrincessGuide
//
//  Created by zzk on 2018/8/27.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import MJRefresh

class RefreshFooter: MJRefreshAutoFooter {
    
    var loadingView = UIActivityIndicatorView(style: .medium)
    var stateLabel = UILabel()
    
    var centerOffset: CGFloat = 0
    
    private let noMoreString = NSLocalizedString("No more data", comment: "")
    
    override var state: MJRefreshState {
        didSet {
            switch state {
            case .idle:
                stateLabel.text = nil
                loadingView.isHidden = true
                loadingView.stopAnimating()
            case .refreshing:
                stateLabel.text = nil
                loadingView.isHidden = false
                loadingView.startAnimating()
            case .noMoreData:
                stateLabel.text = noMoreString
                loadingView.isHidden = true
                loadingView.stopAnimating()
            default:
                break
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        
        frame.size.height = 50
        
        addSubview(loadingView)
        
        stateLabel.frame = CGRect(x: 0, y: 0, width: 300, height: 40)
        stateLabel.textAlignment = .center
        stateLabel.font = UIFont.systemFont(ofSize: 16)
//        stateLabel.textColor = .gray
        addSubview(stateLabel)
        
        ignoredScrollViewContentInsetBottom = 300
        
        stateLabel.textColor = Theme.dynamic.color.indicator
        loadingView.color = Theme.dynamic.color.indicator
    }
    
    override func placeSubviews(){
        super.placeSubviews()
        loadingView.center = CGPoint(x: frame.width / 2, y: frame.height / 2 + centerOffset)
        stateLabel.center = CGPoint(x: frame.width / 2, y: frame.height / 2  + centerOffset)
    }
    
}
