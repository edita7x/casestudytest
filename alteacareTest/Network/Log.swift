//
//  Log.swift
//  alteacareTest
//
//  Created by Edit sanrio Putra on 26/10/22.
//

import Foundation

class Log {
    
    static func debug(_ data: Any) {
        #if DEBUG
            debugPrint(data)
        #endif
    }
}
