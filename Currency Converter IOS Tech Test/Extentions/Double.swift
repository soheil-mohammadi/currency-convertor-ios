//
//  Double.swift
//  Currency Converter IOS Tech Test
//
//  Created by Soheil Mohammadi on 9/9/21.
//

import Foundation

extension Double {
    
    func toStringWith2Decimal () -> String {
        return String(format: "%.2f", self)
    }
}
