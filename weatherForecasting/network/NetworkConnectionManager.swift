//
//  NetworkConnectionManager.swift
//  weatherForecasting
//
//  Created by Niranjan Kumar on 15/07/25.
//

import Foundation
import UIKit
import Network


class NetworkConnectionManager {

    static let shared = NetworkConnectionManager()
    
    private let monitor = NWPathMonitor()
       private let queue = DispatchQueue(label: "Monitor")
       var isConnected: Bool = false

       private init() {
           monitor.pathUpdateHandler = { path in
               if path.status == .satisfied {
                   self.isConnected = true
                   print("Connected")
               } else {
                   self.isConnected = false
                   print("Not Connected")
               }
               // You can also check for specific interface types like Wi-Fi or cellular
               // if path.usesInterfaceType(.wifi) { ... }
           }
           monitor.start(queue: queue)
       }

       func stopMonitoring() {
           monitor.cancel()
       }
    
}
