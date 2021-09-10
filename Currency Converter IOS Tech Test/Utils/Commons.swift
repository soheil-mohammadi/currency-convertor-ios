//
//  Commons.swift
//  Currency Converter IOS Tech Test
//
//  Created by Soheil Mohammadi on 9/9/21.
//

import Foundation

class Commons {
    
    static let shared = Commons ()
    
    func getLocalized (key : String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    
    func getLocalized (key : String , arguments : [CVarArg]) -> String {
        return String(format: getLocalized(key: key), arguments: arguments)
    }


}
