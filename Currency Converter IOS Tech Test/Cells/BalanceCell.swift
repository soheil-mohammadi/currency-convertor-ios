//
//  BalanceCell.swift
//  Currency Converter IOS Tech Test
//
//  Created by Soheil Mohammadi on 9/9/21.
//

import UIKit

class BalanceCell: UICollectionViewCell {

   class var reuseIdentifier: String {
        return "balanceCellIdentifier"
    }

    class var nibName: String {
        return "BalanceCell"
    }
    
    @IBOutlet weak var labelItem: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setLabel(balance : Exchange) {
        labelItem.text = balance.amountToDouble.toStringWith2Decimal() + " " + balance.currency
    }

}




