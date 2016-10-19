//
//  TDEventsModel.swift
//  MeetTenDigi
//
//  Created by derek lee bronston on 10/18/16.
//  Copyright © 2016 Bytedissident. All rights reserved.
//

import UIKit

class Event{

    var name:String?
    var StartTime:String?
    var EventURL:String?
}

class TDEventsModel: NSObject {
    
    lazy var tdLoc = TDLocation()
    var events = [Event]()
    let baseURL = "https://api.meetup.com/2/"
    var isLoading = false
    
    dynamic var eventChange = 0.0

    override init(){
        super.init()
        let options = NSKeyValueObservingOptions([.new, .old])
        tdLoc.addObserver(self, forKeyPath: "locationUpdated", options:options, context: nil)
        tdLoc.addObserver(self, forKeyPath: "locationUpdateFailed", options:options, context: nil)
    }
    
    func listEvents(){
        
        //START GPS, WAIT FOR LAT / LONG TO PROCESS CALL TO API
        tdLoc.startGPS()
    }
    
    func processEvents(){

        //SET STATE
        self.isLoading = true
        
        //CREATE URL
        let url = self.returnURL()
        
        //REQUEST DATA
        let tdRest = TDRest()
        tdRest.GET(url:url,complete: {[weak self] (data) in
            
            if let strongSelf = self {
                
                //SUCCESS: Parse data
                if let array = data["results"] as? Array<Dictionary<String,AnyObject>>{
                    for dict in array {
                        let event = Event()
                        event.name = dict["group"]?["name"] as? String
                        
                        if dict["time"] != nil {
                            let timestamp = (dict["time"] as? Double)! / 1000.0
                            let date = NSDate(timeIntervalSince1970: timestamp)
                            let dayTimePeriodFormatter = DateFormatter()
                            dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
                            let dateString = dayTimePeriodFormatter.string(from: date as Date)
                            event.StartTime = dateString
                        }

                        event.EventURL = dict["event_url"] as? String
                        
                        strongSelf.events.append(event)
                    }
                    //UPDATE KVO
                    strongSelf.eventChange = NSDate.timeIntervalSinceReferenceDate
                    
                    //RESET STATE
                    strongSelf.isLoading = false
                }else{
                    
                    //RESET STATE
                    strongSelf.isLoading = false
                    strongSelf.eventChange = NSDate.timeIntervalSinceReferenceDate
                }
            }
        }) {[weak self] in
            
            //FAIL
            if let strongSelf = self {
                
                //RESET STATE
                strongSelf.isLoading = false
                strongSelf.eventChange = NSDate.timeIntervalSinceReferenceDate
            }
        }
    }
    
    func returnURL()->String{
        
        var url = baseURL
        url += "open_events?key=704a57575b10517ac744f3557724418"
        url += "&topic=technology&sign=true"
        url += "&lat=\(self.tdLoc.latitude)"
        url += "&lon=\(self.tdLoc.longitude)"
        
        return url
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
       
        if keyPath == "locationUpdated" && !isLoading{
            //process event feed with updated lat / long
            self.processEvents()
        }else if keyPath == "locationUpdateFailed" {
            self.isLoading = false // just to be safe
            self.eventChange = NSDate.timeIntervalSinceReferenceDate
        }
    }
}
