//
//  PrincessGuideTests.swift
//  PrincessGuideTests
//
//  Created by zzk on 2018/5/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import XCTest
@testable import PrincessGuide

class PrincessGuideTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPropertyCaculation() {
        var p1 = Property.zero
        p1 += Property.Item(key: .atk, value: 5)
        XCTAssert(p1.atk == 5)
        p1 *= 5
        XCTAssert(p1.atk == 25)
        var p2 = Property.zero
        p2 += Property.Item(key: .atk, value: 40)
        let p3 = p1 + p2
        XCTAssert(p3.atk == 65)
    }
    
    func testSkillActionFormat() {
        let cards = DispatchSemaphore.sync { (closure) in
            Master.shared.getCards(callback: closure)
        }
        let details = cards?.flatMap {
            $0.mainSkills.flatMap {
                $0.actions.map {
                    $0.parameter.localizedDetail(of: Constant.presetMaxPlayerLevel)
                }
            }
        }
        details?.forEach {
            XCTAssert($0 != "")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
