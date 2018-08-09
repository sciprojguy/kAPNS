import Foundation
import Kitura
import CloudEnvironment
import LoggerAPI

let myCertFile = "/root/kAPNS/Resources/cert.pem"
let myKeyFile = "/root/kAPNS/Resources/key.pem"

let mySSLConfig =  SSLConfig(withCACertificateDirectory: nil,
                             usingCertificateFile: myCertFile, 
			     withKeyFile: myKeyFile,
                             usingSelfSignedCerts: true)

public class App {

    let router = Router()
    
    public init() throws {
    }

    func postInit() throws {
        // Endpoints
        initializeRoutes(app: self)
    }

    public func run() throws {
        try postInit()
	Log.info("about to start server")
        Kitura.addHTTPServer(onPort: 4343, with: router, withSSL: mySSLConfig)
        Kitura.run()
    }
}
