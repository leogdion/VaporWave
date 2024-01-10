import Vapor
import Logging

import OpenAPIRuntime
import OpenAPIVapor

struct Handler: APIProtocol  {
  func getMachineById(_ input: Operations.getMachineById.Input) async throws -> Operations.getMachineById.Output {
    // Service.shared.getMachineById(input.path.machineId)
    return .ok(.init(body: .json(.init(name: "test", photoUrls: []))))
  }
  
  
}
public protocol Server : AnyObject {
  
}

@available(macOS 14.0, *)
extension Application : Server {
}

public enum Entrypoint {
  @available(macOS 14.0, *)
   public static func start(forService service: String) async throws -> Server {
     // Create your Vapor application.
     let app = Vapor.Application()


     // Create a VaporTransport using your application.
     let transport = VaporTransport(routesBuilder: app)


     // Create an instance of your handler type that conforms the generated protocol
     // defininig your service API.
     let handler = Handler()


     // Call the generated function on your implementation to add its request
     // handlers to the app.
     try handler.registerHandlers(on: transport, serverURL: Servers.server1())

     
     try await app.execute()
     
     return app
    }
}
