import Foundation
import Glibc
import LoggerAPI
import Kitura
import SwiftyJSON
import KituraNet

let apiKey = "e7af8c793ce94e7078388dcbe85797749a76db01f33d6485b62db8413662b187"

var devices:[String:Device] = [:]

func initializeRoutes(app: App) {

    let fileUrl = URL(fileURLWithPath: "/root/kAPNS/devices.json")
    if let contents = try? String(contentsOf:fileUrl, encoding: .utf8) {
	let jd = JSONDecoder()
        if let data = contents.data(using: .utf8) {
	   if let dv = try? jd.decode([String:Device].self, from:data) {
		devices = dv
	   }
        }
    }
    else {
	print("NO CONTENTS YET")
    }
    
    app.router.all(middleware: BodyParser())
    
    app.router.get("/devices") { req, resp, next in
    
        guard let authKey = req.headers["Authorization"]
        else {
            try! resp.send(status: .forbidden).end()
            return
        }
        
        if authKey != apiKey {
            try! resp.send(status: .forbidden).end()
            return
        }
        
        Log.info("Getting devices: \(devices)")
        resp.send(json: devices)
    }
    
    app.router.post("/device") { req, resp, next in
        
        guard let authKey = req.headers["Authorization"]
        else {
            try! resp.send(status: .forbidden).end()
            return
        }
        
        if authKey != apiKey {
            try! resp.send(status: .forbidden).end()
            return
        }

        Log.info("CHECKING /device POST REQUEST \(req)")
        guard let body = req.body
        else {
            Log.warning("FAILED WITH NIL body")
            _ = resp.send(status: .badRequest)
            return
        }
        
        guard let json = body.asJSON
        else {
            Log.warning("FAILED WITH NON-JSON body")
            _ = resp.send(status: .badRequest)
            return
        }

        Log.info("Adding \(json)")
        let device = Device(jsonDict: json)
        devices[device.deviceToken] = device

        let encoder = JSONEncoder()
        let json2 = try encoder.encode(devices) 

	if let json2str = String(data: json2, encoding: .utf8 ) {
           Log.info("JSON: \(json2str)")
	   let fileUrl = URL(fileURLWithPath: "/root/kAPNS/devices.json")
	   _ = try! json2str.write(to: fileUrl, atomically: true, encoding: .utf8)
	}

        Log.info("Devices: \(devices)")
        _ = resp.send(status: .OK)
    }
    
    app.router.delete("/device") { req, resp, next in
    
        guard let authKey = req.headers["Authorization"]
        else {
            try! resp.send(status: .forbidden).end()
            return
        }
        
        if authKey != apiKey {
            try! resp.send(status: .forbidden).end()
            return
        }
        
        guard let body = req.body,
              let json = body.asJSON
        else {
            _ = resp.send(status: .badRequest)
            return
        }

        Log.info("Removing \(json)")
        let device = Device(jsonDict: json)
        devices.removeValue(forKey: device.deviceToken)

        let encoder = JSONEncoder()
        let json2 = try encoder.encode(devices) 
	    if let json2str = String(data: json2, encoding: .utf8 ) {
           Log.info("JSON: \(json2str)")
	   let fileUrl = URL(fileURLWithPath: "/root/kAPNS/devices.json")
	   _ = try! json2str.write(to: fileUrl, atomically: true, encoding: .utf8)
	}

        Log.info("Devices: \(devices)")
        _ = resp.send(status: .OK)
    }
    
}
