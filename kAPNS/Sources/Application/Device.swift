//
//  Device.swift
//  Application
//
//  Created by Chris Woodard on 7/3/18.
//

import Foundation

struct Device : Codable {
    let deviceToken:String
    let deviceName:String
    let deviceType:String
    let deviceOS:String
    let appId:String
    init(jsonDict:[String:Any]) {
        self.deviceType = jsonDict["deviceType"] as? String ?? ""
        self.deviceOS = jsonDict["deviceOS"] as? String ?? ""
        self.deviceName = jsonDict["deviceName"] as? String ?? ""
        self.deviceToken = jsonDict["deviceToken"] as? String ?? ""
        self.appId = jsonDict["appId"] as? String ?? ""
    }
}
