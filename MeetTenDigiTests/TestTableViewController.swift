//
//  TestTableViewController.swift
//  MeetTenDigi
//
//  Created by derek lee bronston on 10/18/16.
//  Copyright © 2016 Bytedissident. All rights reserved.
//

import XCTest
@testable import MeetTenDigi

class TestTableViewController: XCTestCase {
    
    var sut:TableViewController!
    override func setUp() {
        super.setUp()
        self.sut = TableViewController()
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.sut = storyboard.instantiateViewController(withIdentifier: "Home") as! TableViewController
        self.sut.loadView()
        self.sut.viewDidLoad()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testModel(){
        XCTAssertNotNil(self.sut.model)
    }
    
    func testAc(){
        XCTAssertNotNil(self.sut.ac())
    }
    
    func testRefresh(){
        XCTAssertNotNil(self.sut.refresh)
        let actions = self.sut.refresh.actions(forTarget: self.sut, forControlEvent: .valueChanged)
        if let a = actions {
            XCTAssertEqual(a[0] as String,"refreshEvents","!!")
        }else{
            XCTFail()
        }
    }
    
}
