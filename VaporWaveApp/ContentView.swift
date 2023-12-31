//
//  ContentView.swift
//  VaporWave
//
//  Created by Leo Dion on 12/23/23.
//

import SwiftUI
import VaporWaveModels

@Observable
class Service {
  var session : XPCSession?
  var server : XPCSession?
  var firstNumber : Int?
  var secondNumber : Int?
  private(set) var resultNumber : Int?
  
  var isReady : Bool {
    return session != nil && firstNumber != nil && secondNumber != nil
  }
  func initialize () {
    do {
      session = try XPCSession(xpcService: "com.brightdigit.VaporWaveXPC")

    } catch {
      print(error)
    }
  }
  func setup () {
    self.firstNumber = .random(in: 10...100)
    self.secondNumber = .random(in: 10...100)
    self.resultNumber = nil
  }
  func run () {
    guard let session else {
      return
    }
    guard let firstNumber, let secondNumber else {
      return
    }
    let request = CalculationRequest(firstNumber: firstNumber, secondNumber: secondNumber)
    
    Task {
      do {
        let response : CalculationResponse =  try await session.sendMessage(request)

        self.resultNumber = response.result
          
        
      } catch {
        print(error)
      }
    }
  }
}

struct ContentView: View {
  var service = Service()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
          Text(self.service.firstNumber?.description ?? "()")
          Text(self.service.secondNumber?.description ?? "()")
          Button("Setup") {
            self.service.setup()
          }
          Text(self.service.resultNumber?.description ?? "()")
          Button("Go") {
            self.service.run()
          }.disabled(!self.service.isReady)
        }
        .padding()
        .onAppear{
          self.service.initialize()
        }
    }
}

#Preview {
    ContentView()
}
