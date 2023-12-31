//
//  VaporWaveServiceTypes.swift
//  VaporWaveService
//
//  Created by Leo Dion on 12/23/23.
//

import XPC

@available(macOS 14.0, *)
extension XPCSession {
  public func sendMessage<Message, Reply>(_ message: Message) async throws -> Reply where Message : Encodable, Reply : Decodable {
    try await withCheckedThrowingContinuation { contuation in
      do {
        try self.send(message) { result in
          contuation.resume(with: result)
        }
      } catch {
        contuation.resume(throwing: error)
      }
      
    }
  }
}

// A sample codable type that contains two numbers to be added together.
public struct CalculationRequest: Codable {
  public init(firstNumber: Int, secondNumber: Int) {
    self.firstNumber = firstNumber
    self.secondNumber = secondNumber
  }
  
    public let firstNumber: Int
  public let secondNumber: Int
}

// A sample codable type that contains the result of a calculation.
public struct CalculationResponse: Codable {
  public init(result: Int) {
    self.result = result
  }
  
  public let result: Int
}
