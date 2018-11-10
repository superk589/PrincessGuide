//
//  FixedTabBar.swift
//  PrincessGuide
//
//  Created by zzk on 2018/11/10.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class FixedTabBar: UITabBar {
    
    var itemFrames = [CGRect]()
    var tabBarItems = [UIView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrientationChange(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrientationChange(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc private func handleOrientationChange(_ notification: Notification) {
        itemFrames.removeAll()
        tabBarItems.removeAll()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if itemFrames.isEmpty, let UITabBarButtonClass = NSClassFromString("UITabBarButton") as? NSObject.Type {
            tabBarItems = subviews.filter({$0.isKind(of: UITabBarButtonClass)})
            tabBarItems.forEach({itemFrames.append($0.frame)})
        }
        
        if !itemFrames.isEmpty, !tabBarItems.isEmpty, itemFrames.count == items?.count {
            tabBarItems.enumerated().forEach({$0.element.frame = itemFrames[$0.offset]})
        }
    }
}
