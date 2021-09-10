//
//  CurrencyPickerController.swift
//  Currency Converter IOS Tech Test
//
//  Created by Soheil Mohammadi on 9/10/21.
//

import UIKit

protocol CurrencyPicked {
    func pickedCurrency(currency : String , isForSell : Bool)
}

class CurrencyPickerController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var currencies :[Exchange] = []
    var customTitle : String = ""
    var isForSell : Bool = false
    var currencyPicked : CurrencyPicked?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = customTitle
    }
    
    
    @IBAction func onSelectBtnTapped(_ sender: Any) {
        currencyPicked?.pickedCurrency(currency: currencies[pickerView.selectedRow(inComponent: 0)].currency , isForSell: isForSell)
        dismiss(animated: true, completion: nil)

    }
    
}


extension CurrencyPickerController : UIPickerViewDelegate , UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row].currency
    }
    
    
}
