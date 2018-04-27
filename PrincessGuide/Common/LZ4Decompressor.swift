//
//  LZ4Decompressor.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/27.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation
import lz4

class LZ4Decompressor {
    static func decompress(_ data: Data) -> Data {
        var destSize = 0
        (data as NSData).getBytes(&destSize, range: NSRange(location: 4, length: 4))
        
        let newdata = data.subdata(in: 16..<data.count)
        
        let source = (newdata as NSData).bytes.bindMemory(to: Int8.self, capacity: newdata.count)
        let dest = UnsafeMutablePointer<Int8>.allocate(capacity: destSize)
        defer {
            dest.deallocate()
        }
        LZ4_decompress_fast(source, dest, Int32(destSize))
        
        let decompressedData = Data(bytes: dest, count: destSize)
        return decompressedData
    }
}
