//
//  NetworkMonitor.swift
//  PruebaTecnicaIzzy
//
//  Created by Charls Salazar on 25/02/26.
//

import Network

class NetworkMonitor: NSObject {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    private(set) var isConnected: Bool = true
    
    var onReconnect: (() -> Void)?
    
    override init() {
        super.init()
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            let previousStatus = self.isConnected
            self.isConnected = path.status == .satisfied
            
            if !previousStatus && self.isConnected {
                DispatchQueue.main.async {
                    self.onReconnect?()
                }
            }
        }
        monitor.start(queue: queue)
    }
}
