//
//  main.swift
//  VaporWaveService
//
//  Created by Leo Dion on 12/23/23.
//

import VaporWaveServer
import VaporWaveModels
import XPC

protocol Operation : Codable {
  associatedtype Input : Codable
  associatedtype Output : Codable
  var input : CalculationRequest { get }
  func fromHandler(_ operationHandler: OperationHandler) async throws -> Output
}

struct Calculation : Operation {
  typealias Input = CalculationRequest
  
  typealias Output = CalculationResponse
  
  let input: CalculationRequest
  
  func fromHandler(_ operationHandler: OperationHandler) async throws -> CalculationResponse {
    return .init(result: self.input.firstNumber + self.input.secondNumber)
  }
}
public class OperationHandler {
  func perform<OperationType : Operation>(_ operation : OperationType) async throws -> OperationType.Output {
    return try await operation.fromHandler(self)
  }
}

@available(macOS 14.0, *)
public class Service {
  let operationHandler = OperationHandler()
  var listener : XPCListener!
  var server : Server!
  convenience init (service : String)  throws {
    self.init()
    let listener = try XPCListener(
      service: service,
      incomingSessionHandler: self.incomingSessionHandler
    )
    
    self.listener = listener
    Task {
      let server = try await Entrypoint.start(forService: service)
      self.server =  server
    }
  }
  func incomingSessionHandler (_ request : XPCListener.IncomingSessionRequest)  -> XPCListener.IncomingSessionRequest.Decision {
    request.accept(incomingMessageHandler: self.performTask(with:))
  }
  public static func launch (service : String) throws -> Never {
    
    _ = try Service(service: service)

      dispatchMain()
  }
  func performTask(with message: XPCReceivedMessage) -> Encodable? {
      do {
          // Decode the message from the received message.
          let request = try message.decode(as: CalculationRequest.self)

          // Return an encodable response that will get sent back to the client.
          return CalculationResponse(result: request.firstNumber + request.secondNumber)
      } catch {
          print("Failed to decode received message, error: \(error)")
          return nil
      }
  }
}
