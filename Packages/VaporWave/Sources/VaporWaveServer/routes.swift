import Vapor
import VaporWaveModels

extension CalculationResponse : Content {
  
}

extension CalculationRequest : Content {
  
}

@available(macOS 14.0, *)
func routes(_ app: Application) throws {
  app.post { req async throws -> CalculationResponse in
      let request = try req.content.decode(CalculationRequest.self)
//      guard let session = app.xpcSession else {
//        fatalError()
//      }
      //return try await session.send(request)
    return CalculationResponse(result: request.firstNumber + request.secondNumber)
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
}
