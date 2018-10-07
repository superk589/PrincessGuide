//
//  RefreshHeader.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/27.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import MJRefresh

class RefreshHeader: MJRefreshHeader {
    
    let loadingView = UIActivityIndicatorView(style: .gray)
    let arrowImage = UIImageView()
    
    override var state: MJRefreshState {
        didSet {
            switch state {
            case .idle:
                loadingView.isHidden = true
                arrowImage.isHidden = false
                loadingView.stopAnimating()
            case .pulling:
                loadingView.isHidden = false
                arrowImage.isHidden = true
                loadingView.startAnimating()
            case .refreshing:
                loadingView.isHidden = false
                arrowImage.isHidden = true
                loadingView.startAnimating()
            default:
                break
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        frame.size.height = 50
        addSubview(loadingView)
        arrowImage.image = #imageLiteral(resourceName: "arrow-downward").withRenderingMode(.alwaysTemplate)
        addSubview(arrowImage)
    }
    
//    override func willMove(toSuperview newSuperview: UIView?) {
//        super.willMove(toSuperview: newSuperview)
//        if let scrollView = newSuperview as? UIScrollView {
//            frame.origin.x = -scrollView.contentInset.left
//        }
//    }
    
    override func placeSubviews(){
        super.placeSubviews()
        loadingView.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        arrowImage.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        arrowImage.center = loadingView.center
    }
    
}
