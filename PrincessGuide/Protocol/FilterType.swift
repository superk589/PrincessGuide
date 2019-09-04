//
//  FilterType.swift
//  PrincessGuide
//
//  Created by zzk on 9/4/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation

protocol FilterType {
    
    associatedtype Element
    
    func filter<S>(_ s: S) -> [Element] where S: Sequence, S.Element == Element
}

extension Sequence {
    
    func filtered<F: FilterType>(by f: F) -> [Element] where F.Element == Element {
        return f.filter(self)
    }
    
}
