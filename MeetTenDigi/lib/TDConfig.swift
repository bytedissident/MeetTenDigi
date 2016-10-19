//
//  TDConfig.swift
//  MeetTenDigi
//
//  Created by derek lee bronston on 10/19/16.
//  Copyright © 2016 Bytedissident. All rights reserved.
//

import UIKit

class TDConfig:NSObject {
    
    var baseURL:String = ""
    var apiKey:String = ""
    
    
    func conf(){
        //print("conf")
        let path = Bundle.main.path(forResource: "td_config", ofType: "plist")
        if let p = path {
            ///print("path")
            let dict = NSDictionary(contentsOfFile: p)
            //SET DATA
            if let td = dict {
                
                if let ak = td["api_key"] {
                    self.apiKey = ak as! String
                }
                
                if let au = td["api_base_url"] {
                    self.baseURL = au as! String
                }
               
            }
        }
    }
}
