//
//  TestTDConfig.swift
//  MeetTenDigi
//
//  Created by derek lee bronston on 10/19/16.
//  Copyright © 2016 Bytedissident. All rights reserved.
//

import XCTest
@testable import MeetTenDigi

class TestTDConfig: XCTestCase {
    
    var sut:TDConfig!
    override func setUp() {
        super.setUp()
        
        sut = TDConfig()
        
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConf(){
        sut.conf()
        XCTAssertEqual(sut.apiKey , "704a57575b10517ac744f3557724418")
        XCTAssertEqual(sut.baseURL , "https://api.meetup.com/2/")
    }
}
