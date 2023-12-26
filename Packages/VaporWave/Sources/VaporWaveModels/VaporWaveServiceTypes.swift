//
//  VaporWaveServiceTypes.swift
//  VaporWaveService
//
//  Created by Leo Dion on 12/23/23.
//

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
