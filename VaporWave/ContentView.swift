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
  var firstNumber : Int?
  var secondNumber : Int?
  private(set) var resultNumber : Int?
  
  var isReady : Bool {
    return session != nil && firstNumber != nil && secondNumber != nil
  }
  func initialize () {
    do {
      session = try XPCSession(xpcService: "com.brightdigit.VaporWaveService")
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
    
    do {
      try session.send(request) { result in
        guard let reply = try? result.get() else {
          return
        }
        
        guard let response : CalculationResponse =
                try? reply.decode() else {
          return
        }
        
        self.resultNumber = response.result
      }
    } catch {
      print(error)
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
