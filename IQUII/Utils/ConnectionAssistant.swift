//
//  ConnectionHelper.swift
//  IQUII
//
//  Created by Marco Pilloni on 17/08/21.
//  Copyright © 2021 Marco Pilloni. All rights reserved.
//

import Foundation
import Network


final class ConnectionAssistant  {
    
    static let current = ConnectionAssistant()
    
    private lazy var monitor: NWPathMonitor = {
       let monitor = NWPathMonitor()
        return monitor
    }()
    
    func isConnectionAvailable(completionHandler: @escaping(Bool) -> Void) {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("satisfied")
                completionHandler(true)
            } else {
                print("non satisfied")
                completionHandler(false)
            }
        }
        
    }
    
}
