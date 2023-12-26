import Vapor
import Logging

public protocol Server : AnyObject {
  
}

public extension Application : Server {
  
}
public enum Entrypoint {
    public static func start() async throws -> Server {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)
        
        let app = Application(env)
      
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
