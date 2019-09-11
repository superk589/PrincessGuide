//
//  UIActivityViewController+Helper.swift
//  PrincessGuide
//
//  Created by zzk on 8/10/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import UIKit

extension UIActivityViewController {
    
    static func show(images: [UIImage], pointTo barButtonItem: UIBarButtonItem, in viewController: UIViewController?) {
        let activityVC = UIActivityViewController(activityItems: images, applicationActivities: nil)
        activityVC.popoverPresentationController?.barButtonItem = barButtonItem
        (viewController ?? UIApplication.shared.currentWindow?.rootViewController)?.present(activityVC, animated: true, completion: nil)
    }
    
    static func show(images: [UIImage], pointTo view: UIView, rect: CGRect?, in viewController: UIViewController?) {
        let activityVC = UIActivityViewController(activityItems: images, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = view
        activityVC.popoverPresentationController?.sourceRect = rect ?? .zero
        (viewController ?? UIApplication.shared.currentWindow?.rootViewController)?.present(activityVC, animated: true, completion: nil)
    }
    
}
