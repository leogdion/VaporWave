//
//  VaporWaveServiceTypes.swift
//  VaporWaveService
//
//  Created by Leo Dion on 12/23/23.
//

// A sample codable type that contains two numbers to be added together.
struct CalculationRequest: Codable {
    let firstNumber: Int
    let secondNumber: Int
}

// A sample codable type that contains the result of a calculation.
struct CalculationResponse: Codable {
    let result: Int
}
