//
//  TDRest.swift
//  MeetTenDigi
//
//  Created by derek lee bronston on 10/18/16.
//  Copyright © 2016 Bytedissident. All rights reserved.
//

import UIKit
import Alamofire


class TDRest: NSObject {
    
    func GET(url:String,complete:@escaping (_ res:[String:AnyObject])->Void,fail:@escaping ()->Void){
        
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil {
            
            Alamofire.request(url).responseJSON { response in
                if let JSON = response.result.value {
                    complete(JSON as! [String : AnyObject])
                }else{
                    fail()
                }
            }
        }else{
            fail()
        }
    }
}
