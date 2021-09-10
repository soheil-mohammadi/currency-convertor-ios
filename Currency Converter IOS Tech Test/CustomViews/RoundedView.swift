//
//  RoundedView.swift
//  Currency Converter IOS Tech Test
//
//  Created by Soheil Mohammadi on 9/10/21.
//

import Foundation
import UIKit

@IBDesignable public class RoundedView: UIView {

    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    
    
}
