//
//  main.swift
//  VaporWaveServerApp
//
//  Created by Leo Dion on 12/27/23.
//

import VaporWaveServer

try await Service.launch(
   "com.brightdigit.VaporWaveServer",
  forService: "com.brightdigit.VaporWaveService"
)
