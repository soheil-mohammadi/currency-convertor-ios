//
//  Exchange.swift
//  Currency Converter IOS Tech Test
//
//  Created by Soheil Mohammadi on 9/9/21.
//

import Foundation


struct Exchange : Codable {
    
    var amount : String
    var currency : String
    var amountToDouble : Double {
        get {
            return Double(amount) ?? 0
        }
    }
    
    var type : Currency {
        get {
            return Currency(rawValue: currency)!

        }
    }
    
    
}
