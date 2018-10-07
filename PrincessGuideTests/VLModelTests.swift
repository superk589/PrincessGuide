//
//  VLModelTests.swift
//  PrincessGuideTests
//
//  Created by zzk on 2018/8/18.
//  Copyright © 2018 zzk. All rights reserved.
//

import XCTest
@testable import PrincessGuide
import Alamofire

class VLModelTests: XCTestCase {
    
    var model: VersionLog!
    
    var model2: VersionLog!
    
    private func decodeModel(named name: String) -> VersionLog? {
        var model: VersionLog?
        let path = Bundle(for: type(of: self)).path(forResource: name, ofType: "json")
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path!))
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            model = try decoder.decode(VersionLog.self, from: jsonData)
        } catch(let error) {
            print(error)
        }
        return model
    }

    override func setUp() {
        model = decodeModel(named: "VLModel")
        model2 = decodeModel(named: "VLModel2")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testModel() {
        XCTAssert(model != nil)
        XCTAssert(model.page == 2)
        XCTAssert(model.pages == 3)
        XCTAssert(model.data.contains { $0.story != nil } )
        XCTAssert(model.data.contains { $0.event != nil } )
        XCTAssert(model.data.contains { $0.questArea != nil } )
        XCTAssert(model.data.contains { $0.story != nil } )
        XCTAssert(model.data.contains { $0.campaign != nil } )
        XCTAssert(model.data.contains { $0.clanBattle != nil } )
        XCTAssert(model.data.contains { $0.unit != nil } )
        XCTAssert(model.data.contains { $0.gacha != nil } )

        XCTAssert(model2 != nil)
        XCTAssert(model2.pages == 3)
        XCTAssert(model2.page == 1)
        XCTAssert(model2.data.contains { $0.dungeonArea != nil } )
        XCTAssert(model2.data.contains { $0.maxRank != nil } )
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
