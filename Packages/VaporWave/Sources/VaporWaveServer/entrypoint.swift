import Vapor
import Logging

public protocol Server : AnyObject {
  
}

@available(macOS 14.0, *)
extension Application : Server {
   var xpcConfiguration: XPCConfiguration? {
       get {
           self.storage[XPCConfigurationKey.self]
       }
       set {
           self.storage[XPCConfigurationKey.self] = newValue
       }
   }
   
  var xpcSession : XPCSession? {
    
        get {
            self.storage[XPCSessionKey.self]
        }
        set {
            self.storage[XPCSessionKey.self] = newValue
        }
  }
}

struct XPCConfiguration {
  var service : String
}

@available(macOS 14.0, *)
struct XPCSessionKey : StorageKey {
  typealias Value = XPCSession
}
struct XPCConfigurationKey : StorageKey {
  typealias Value = XPCConfiguration
}

@available(macOS 14.0, *)
struct XPCLifecycleHandler : LifecycleHandler {
  func didBoot(_ application: Application) throws {
    dump(application.xpcConfiguration)
    application.xpcSession = try (application.xpcConfiguration?.service).map({
      try XPCSession(xpcService: $0)
    })
  }
}
public enum Entrypoint {
  @available(macOS 14.0, *)
   static func start(forService service: String) async throws -> Server {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)
        
        let app = Application(env)
    app.lifecycle.use(XPCLifecycleHandler())
    app.xpcConfiguration = .init(service: service)
//      do {
//        session = try XPCSession(xpcService: "com.brightdigit.VaporWaveService")
//      } catch {
//        print(error)
//      }
      
        defer { app.shutdown() }
        
        do {
            try await configure(app)
        } catch {
            app.logger.report(error: error)
            throw error
        }
        try await app.execute()
      
      return app
    }
}
