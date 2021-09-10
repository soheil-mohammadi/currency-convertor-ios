//
//  ViewController.swift
//  Currency Converter IOS Tech Test
//
//  Created by Soheil Mohammadi on 9/9/21.
//

import UIKit
import RxSwift


class ViewController: UIViewController {

    var balancesItem:[Exchange] = []
    
    let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var amountToSellTextField: UITextField!
    
    @IBOutlet weak var sellCurrencyType: UIButton!
    @IBOutlet weak var recieveCurrencyType: UIButton!
    
    @IBOutlet weak var amountToRecieve: UILabel!
    @IBOutlet weak var prgLoaderAmountToRecieve: UIActivityIndicatorView!
    @IBOutlet weak var myBalancesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerBalanceNib()
        registerUserBalances()
        
        registerOnSellAmountChanged()
        registerOnRecieveAmountChanged ()
        registerMsgUI()
        
        amountToSellTextField.addTarget(self, action: #selector(onSellAmountChanged(textField:)), for: .editingChanged)

    }

    
    @objc final private func onSellAmountChanged (textField: UITextField) {
        calculateRecieveAmount ()
    }
    
    
    func calculateRecieveAmount () {
        prgLoaderAmountToRecieve.isHidden = false
        amountToRecieve.isHidden = true
        
        amountToRecieve.text = ""
        
        viewModel.fromToCurrency(fromAmount: amountToSellTextField.text!  , fromCurrency: Currency(rawValue: sellCurrencyType.title(for: .normal)!)!, toCurrency: Currency(rawValue: recieveCurrencyType.title(for: .normal)!)!)
    }
    
    func registerBalanceNib() {
        let nib = UINib(nibName: BalanceCell.nibName, bundle: nil)
        myBalancesCollectionView.register(nib, forCellWithReuseIdentifier: BalanceCell.reuseIdentifier)
        if let flowLayout = self.myBalancesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
    }
    
    func registerMsgUI () {
        viewModel.alertMsg.asObservable().subscribe(
        
            onNext: {
                
                if let msg = $0 {
                    let alert =  UIAlertController(title: msg.title, message: msg.msg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            
        ).disposed(by: disposeBag)
    }
    
    
    func registerOnRecieveAmountChanged () {
        
        viewModel.amountToRecieve.asObservable().subscribe(
            
            onNext: {
                
                self.amountToRecieve.text = "+" +  $0.toStringWith2Decimal()
                self.amountToRecieve.isHidden = false
                self.prgLoaderAmountToRecieve.isHidden = true
                
            }
            
        ).disposed(by: disposeBag)
        
    }
    
    func registerOnSellAmountChanged () {
        
        viewModel.amountToSend.asObservable().subscribe(
            
            onNext: {
                
                self.amountToSellTextField.text = $0.toStringWith2Decimal()
                
            }
            
        ).disposed(by: disposeBag)
        
    }
    
    func registerUserBalances () {
        viewModel.userBalances.asObservable().subscribe(
            
            onNext: {
                
                if let userBalances = $0 {
                    self.balancesItem = userBalances
                    self.myBalancesCollectionView.reloadData()
                }
            }
            
        ).disposed(by: disposeBag)
    }
    
    
    @IBAction func onSubmitTapped(_ sender: Any) {
        amountToSellTextField.resignFirstResponder()
        viewModel.sumbitToConvert(sell: Exchange(amount: self.amountToSellTextField.text! , currency: Currency(rawValue: sellCurrencyType.title(for: .normal)!)!.rawValue),
                                  recieve: Exchange(amount: self.amountToRecieve.text! , currency: Currency(rawValue: recieveCurrencyType.title(for: .normal)!)!.rawValue))
        
    }
    
        

    @IBAction func onCurrencyTypeTapped(_ sender: UIButton) {
        
        let pickerController = self.storyboard?.instantiateViewController(withIdentifier: "pickerControllerID") as! CurrencyPickerController
        
        pickerController.currencyPicked = self
        pickerController.currencies = balancesItem
        
        if sender.tag == 1 {
            pickerController.isForSell = true
            pickerController.customTitle = Commons.shared.getLocalized(key: "select_currency_to_sell")
        }else {
            pickerController.isForSell = false
            pickerController.customTitle = Commons.shared.getLocalized(key: "select_currency_to_recieve")
        }
     
        
        self.present(pickerController, animated: true, completion: nil)

    }
    
    
}

extension ViewController : UICollectionViewDelegate  , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return balancesItem.count
       }

    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BalanceCell.reuseIdentifier,
                                                            for: indexPath) as? BalanceCell {
               let balance = balancesItem[indexPath.row]
               cell.setLabel(balance: balance)
               return cell
           }
        
           return UICollectionViewCell()
       }
    
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 30)
                        
    }
    
  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
      
    }
    
    
}


extension ViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty { return true }
            guard let oldText = textField.text, let rng = Range(range, in: oldText) else {
                return true
            }
            let newText = oldText.replacingCharacters(in: rng, with: string)

            let isNumeric = newText.isEmpty || (Double(newText) != nil)

            let formatter = NumberFormatter()
            formatter.locale = .current
            let decimalPoint = formatter.decimalSeparator ?? "."
            let numberOfDots = newText.components(separatedBy: decimalPoint).count - 1

            let numberOfDecimalDigits: Int
            if let dotIndex = newText.firstIndex(of: ".") {
                numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }
            if newText.count == 1 && !isNumeric {  
                return CharacterSet(charactersIn: "+-" + decimalPoint).isSuperset(of: CharacterSet(charactersIn: string))
            }
            return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
        
        }

    
}


extension ViewController : CurrencyPicked {
    
    func pickedCurrency(currency: String , isForSell : Bool) {

        if isForSell {
            self.sellCurrencyType.setTitle(currency, for: .normal)
        }else {
            self.recieveCurrencyType.setTitle(currency, for: .normal)
        }
        
        calculateRecieveAmount ()

    }
    
    
}
