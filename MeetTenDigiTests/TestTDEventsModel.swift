//
//  TestTDEventsModel.swift
//  MeetTenDigi
//
//  Created by derek lee bronston on 10/18/16.
//  Copyright © 2016 Bytedissident. All rights reserved.
//

import XCTest
@testable import MeetTenDigi

class TestTDEventsModel: XCTestCase {
    
    var sut:TDEventsModel!
    override func setUp() {
        super.setUp()
        sut = TDEventsModel()
        XCTAssertEqual(sut.tdConfig.apiKey, "704a57575b10517ac744f3557724418")
        XCTAssertEqual(sut.tdConfig.baseURL, "https://api.meetup.com/2/")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testProcessEvents(){
        
        XCTAssertEqual(sut.eventFail, 0.0)
        sut.processEvents()
        //event will fail in TEST MODE
        XCTAssertNotEqual(sut.eventFail, 0.0)
    }
    
    func testReturnURL(){
        let url = sut.returnURL()
        XCTAssertEqual(url, "https://api.meetup.com/2/open_events?key=704a57575b10517ac744f3557724418&topic=technology&sign=true&lat=0.0&lon=0.0")
    }
    
    
    func testParseEvents(){
        
        //SUCCESS
        XCTAssertEqual(sut.eventChange, 0.0)
        let urlpath = Bundle.main.path(forResource: "events", ofType: "json")
        let data = NSData(contentsOfFile: urlpath!)
        do {
            let parsedData = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as! Dictionary<String, AnyObject>
            sut.parseEvents(data: parsedData)
            XCTAssertEqual(sut.events.count, 11)
            let e = sut.events[0]
            XCTAssertEqual(e.name, "NY Tech Meetup")
            XCTAssertEqual(e.EventURL, "http://www.meetup.com/ny-tech/events/229675656/")
            XCTAssertEqual(e.StartTime, "Nov 09 2016 07:00 PM")
            XCTAssertNotEqual(sut.eventChange, 0.0)
            XCTAssertFalse(sut.isLoading)
        }catch let error as NSError{
            print(error)
            XCTFail()
        }
        
        //FAIL
        XCTAssertEqual(sut.eventFail, 0.0)
        let dict = [String:AnyObject]()
        sut.parseEvents(data:dict)
        XCTAssertNotEqual(sut.eventFail, 0.0)
        XCTAssertFalse(sut.isLoading)
    }
}
