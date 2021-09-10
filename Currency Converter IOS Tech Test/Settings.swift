//
//  Settings.swift
//  Currency Converter IOS Tech Test
//
//  Created by Soheil Mohammadi on 9/9/21.
//

import Foundation

class Settings {
    
    static let shared = Settings()

    let apiBaseUrl = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String ?? ""

}
