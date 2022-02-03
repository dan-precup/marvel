//
//  Log.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import Foundation

struct Log {
    
    private static let prefix = "MVL-"
    
    static func error(_ message: String, _ error: Error? = nil) {
        #if DEBUG
        if let error = error {
            print(prefix+"ERROR: ", "\(message): ", error)
        } else {
            print(prefix+"ERROR: ", message)
        }
        #endif
    }
    
    static func info(_ message: String) {
        #if DEBUG
        print(prefix+"INFO: ", message)
        #endif

    }
    
    static func info(_ message: String...) {
        #if DEBUG
        print(prefix+"INFO: ", message)
        #endif
    }
    
    static func success(_ message: String...) {
        #if DEBUG
        print(prefix+"INFO SUCCESS: ", message)
        #endif
    }
}
