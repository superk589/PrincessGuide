//
//  UnityFSUnpacker.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/2.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation
import lz4

extension Binary {
    
    public mutating func nextByte() -> UInt8? {
        return next(bytes: 1)?.first
    }
    
    public mutating func nextString(encoding: String.Encoding = .utf8) -> String? {
        var stringBuffer = [UInt8]()
        while let byte = self.nextByte(), byte != 0x00 {
            stringBuffer.append(byte)
        }
        return String(bytes: stringBuffer, encoding: encoding)
    }
    
    public mutating func nextValue<T>(_: T.Type, isBigEndian: Bool = true) -> T? {
        let size = MemoryLayout<T>.size
        if let bytes = self.next(bytes: size) {
            return NSData(bytes: isBigEndian ? bytes.reversed() : bytes, length: size).bytes.bindMemory(to: T.self, capacity: size).pointee
        } else {
            return nil
        }
    }
}

enum UnityFSError: Error {
    case invalidData
    case unsupportedFormat
}

enum CompressionType {
    case none, LZMA, LZ4, LZ4HC, LZHAM
    
    init(flags: Int32) {
        switch flags & 0x3f {
        case 1:
            self = .LZMA
        case 2:
            self = .LZ4
        case 3:
            self = .LZ4HC
        case 4:
            self = .LZHAM
        default:
            self = .none
        }
    }
}

func extractBundle(data: Data) throws -> [(fileName: String, data: Data)] {
    var bundle = Binary(data: data)
    
    guard let header = bundle.nextString(),
        let format = bundle.nextValue(Int32.self),
        let versionPlayer = bundle.nextString(),
        let versionEngine = bundle.nextString() else {
            throw UnityFSError.invalidData
    }
    print(header, format, versionPlayer, versionEngine)
    
    if format != 6 {
        throw UnityFSError.unsupportedFormat
    }
    
    bundle.readingOffset += 64
    
    guard let compressedSize = bundle.nextValue(Int32.self),
        let uncompressedSize = bundle.nextValue(Int32.self),
        let flags = bundle.nextValue(Int32.self) else {
            throw UnityFSError.invalidData
    }
    
    let blocksInfoData: Data
    if flags & 128 != 0 {
        throw UnityFSError.invalidData
    } else {
        guard let bytes = bundle.next(bytes: Int(compressedSize)) else {
            throw UnityFSError.invalidData
        }
        blocksInfoData = Data(bytes)
    }
    
    func decompress(data: Data, flags: Int32, uncompressedSize: Int32) throws -> Data {
        let uncompressedData: Data
        switch CompressionType(flags: flags) {
        case .none:
            uncompressedData = blocksInfoData
        case .LZMA, .LZHAM:
            throw UnityFSError.unsupportedFormat
        case .LZ4, .LZ4HC:
            let dest = UnsafeMutablePointer<Int8>.allocate(capacity: Int(uncompressedSize))
            let source = (data as NSData).bytes.bindMemory(to: Int8.self, capacity: data.count)
            LZ4_decompress_fast(source, dest, uncompressedSize)
            uncompressedData = Data(bytes: dest, count: Int(uncompressedSize))
            dest.deallocate()
        }
        return uncompressedData
    }
    
    let uncompressedData = try decompress(data: blocksInfoData, flags: flags, uncompressedSize: uncompressedSize)
    
    var blocksInfo = Binary(data: uncompressedData)
    
    blocksInfo.readingOffset += 16 * 8
    
    guard let blockCount = blocksInfo.nextValue(Int32.self) else {
        throw UnityFSError.invalidData
    }
    
    var assetsData = Data()
    for _ in 0..<blockCount {
        guard let uncompressedSize = blocksInfo.nextValue(Int32.self),
            let compressedSize = blocksInfo.nextValue(Int32.self),
            let flags = blocksInfo.nextValue(Int16.self),
            let bytes = bundle.next(bytes: Int(compressedSize)) else {
                throw UnityFSError.invalidData
        }
        let data = try decompress(data: Data(bytes), flags: Int32(flags), uncompressedSize: uncompressedSize)
        assetsData.append(data)
    }
    
    guard let entryInfoCount = blocksInfo.nextValue(Int32.self) else { throw UnityFSError.invalidData }
    
    var results = [(String, Data)]()
    for _ in 0..<entryInfoCount {
        guard let entryInfoOffset = blocksInfo.nextValue(Int64.self),
            let entryInfoSize = blocksInfo.nextValue(Int64.self) else { throw UnityFSError.invalidData }
        blocksInfo.readingOffset += 32
        guard let fileName = blocksInfo.nextString() else { throw UnityFSError.invalidData }
        let data = Data(assetsData[entryInfoOffset..<entryInfoSize])
        results.append((fileName, data))
    }
    
    return results
}

func extractAsset(data: Data) throws -> Data {
    
    var binary = Binary(data: data)
    guard let tableSize = binary.nextValue(Int32.self),
        let dataEnd = binary.nextValue(Int32.self),
        let fileGen = binary.nextValue(Int32.self),
        let dataOffset = binary.nextValue(Int32.self)
    else {
        throw UnityFSError.invalidData
    }
    print(tableSize, dataEnd, fileGen, dataOffset)
    let offset = Int(dataOffset) + 16
    let assetData = Data(data[offset..<Int(dataEnd)])
    return assetData
}
