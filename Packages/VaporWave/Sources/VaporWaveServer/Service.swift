//
//  main.swift
//  VaporWaveService
//
//  Created by Leo Dion on 12/23/23.
//

import VaporWaveModels
import XPC
import Vapor


@available(macOS 14.0, *)
public class Service {
  
  var listener : XPCListener!
  var server : Server!
  convenience init (service : String, forService connectingService: String) async throws {
    self.init()
    let listener = try XPCListener(
      service: service,
      incomingSessionHandler: self.incomingSessionHandler
    )
    async let server = try await Entrypoint.start(forService: connectingService)
    self.listener = listener
    self.server = try await server
  }
  func incomingSessionHandler (_ request : XPCListener.IncomingSessionRequest)  -> XPCListener.IncomingSessionRequest.Decision {
    
    request.accept(incomingMessageHandler: self.performTask(with:))
  }
  @discardableResult
  public static func launch (_ service : String, forService connectingService: String) async throws -> Service {
    let service = try await Service(service: service, forService: connectingService)
    defer {
      dispatchMain()
    }
    return service
  }
  func performTask(with message: XPCReceivedMessage) -> Encodable? {
    return nil
//      do {
//          // Decode the message from the received message.
//          let request = try message.decode(as: CalculationRequest.self)
//
//          // Return an encodable response that will get sent back to the client.
//          return CalculationResponse(result: request.firstNumber + request.secondNumber)
//      } catch {
//          print("Failed to decode received message, error: \(error)")
//          return nil
//      }
  }
}
//import VaporWaveServer
//import Vapor
//var app : Application!
//
//// Set up the listener and start listening for connections.
//startListener()
//
//// Create the listener that receives incoming session requests from clients.
//@available(macOS 14.0, *)
//func startListener() {
//    do {
//      
//        _ = try XPCListener(service: "com.brightdigit.VaporWaveService") { request in
//            // When a session request arrives, you must either accept or reject it.
//            // The listener invokes the closure you specify every time a
//            // message is received.
//            request.accept { message in
//                // Perform the work that the service offers.
//                return performTask(with: message)
//            }
//        }
//      
//      Task {
//        let app = try await Entrypoint.start()
//        
//      }
//
//        // Start the main dispatch queue to begin processing messages.
//        dispatchMain()
//      
//    } catch {
//        print("Failed to create listener, error: \(error)")
//    }
//}
//
//// The function that performs the work of the service.
//@available(macOS 14.0, *)
//func performTask(with message: XPCReceivedMessage) -> Encodable? {
//    do {
//        // Decode the message from the received message.
//        let request = try message.decode(as: CalculationRequest.self)
//
//        // Return an encodable response that will get sent back to the client.
//        return CalculationResponse(result: request.firstNumber + request.secondNumber)
//    } catch {
//        print("Failed to decode received message, error: \(error)")
//        return nil
//    }
//}

/*

 To use this service from an app or other process, use XPCSession to establish a connection to the service.
 
    do {
        session = try XPCSession(xpcService: "com.brightdigit.VaporWaveService")
    } catch {
        print("Failed to connect to listener, error: \(error)")
    }

 Once you have a connection to the service, create a Codable request and send it to the service.

    do {
        let request = CalculationRequest(firstNumber: 23, secondNumber: 19)
        let reply = try session.sendSync(request)
        let response = try reply.decode(as: CalculationResponse.self)

        DispatchQueue.main.async {
            print("Received response with result: \(response.result)")
        }
    } catch {
        print("Failed to send message or decode reply: \(error.localizedDescription)")
    }

 When you're done using the connection, cancel it by doing the following:
 
    session.cancel(reason: "Done with calculation")

 */
