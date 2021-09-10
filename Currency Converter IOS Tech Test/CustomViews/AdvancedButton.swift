//
//  AdvancedButton.swift
//  Currency Converter IOS Tech Test
//
//  Created by Soheil Mohammadi on 9/9/21.
//

import Foundation
import UIKit

@IBDesignable public class AdvancedButton: UIButton {
    
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
}
