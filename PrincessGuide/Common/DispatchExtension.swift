//
//  DispatchExtension.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/20.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

extension DispatchSemaphore {
    
    static func sync<T>(_ closure: (@escaping (T?) -> Void) -> Void) -> T? {
        let semaphore = DispatchSemaphore(value: 0)
        var result: T?
        
        closure { t in
            result = t
            semaphore.signal()
        }
        
        semaphore.wait()
        return result
    }
}
