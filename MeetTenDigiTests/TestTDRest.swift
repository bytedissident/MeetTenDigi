//
//  TestTDRest.swift
//  MeetTenDigi
//
//  Created by derek lee bronston on 10/18/16.
//  Copyright © 2016 Bytedissident. All rights reserved.
//

import XCTest
@testable import MeetTenDigi

class TestTDRest: XCTestCase {
    
    var sut:TDRest!
    override func setUp() {
        super.setUp()
        sut = TDRest()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
}
