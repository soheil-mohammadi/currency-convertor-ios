//
//  HomeViewModel.swift
//  Currency Converter IOS Tech Test
//
//  Created by Soheil Mohammadi on 9/9/21.
//

import Foundation
import RxSwift
import Alamofire
import RxCocoa

class HomeViewModel {
    
    let userBalances = BehaviorRelay<[Exchange]?>(value: nil)
    let amountToRecieve = BehaviorRelay<Double>(value: 0)
    let amountToSend = BehaviorRelay<Double>(value: 0)
    let alertMsg = BehaviorRelay<CurrencyConvertorMsg?>(value: nil)
    
    var conversionsCount : Int = 0

    init() {
        prepareBalances ()
    }
    
    private func prepareBalances () {
        
        //Provided Static Initilization User Balances .... It can be replace by fetching from api endpoint ...
        
        var balancesItem:[Exchange] = []

        balancesItem.append(Exchange(amount: "1000.00", currency: Currency.EUR.rawValue))
        balancesItem.append(Exchange(amount: "0.0", currency: Currency.USD.rawValue ))
        balancesItem.append(Exchange(amount: "0.0", currency: Currency.JPY.rawValue))

        userBalances.accept(balancesItem)
    }
    
    func fromToCurrency (fromAmount : String ,  fromCurrency : Currency , toCurrency : Currency ) {
        
        if fromAmount == "" || fromAmount == "0"  {
            self.amountToRecieve.accept(0)
            return
        }
        
        if fromCurrency.rawValue == toCurrency.rawValue {
            self.amountToRecieve.accept(0)
            return
        }
        
        fromToCurrency(fromAmount: Double(fromAmount) ?? 0, fromCurrency: fromCurrency, toCurrency: toCurrency) { (exchange) in

            self.amountToRecieve.accept(exchange.amountToDouble)
                       
        }
    }
    
    
    private func fromToCurrency (fromAmount : Double ,  fromCurrency : Currency , toCurrency : Currency ,
                         completion : @escaping (_ exchange : Exchange) -> Void ) {
        
        AF.request(Settings.shared.apiBaseUrl + "exchange/" + String(fromAmount) +  "-" + fromCurrency.rawValue + "/" + toCurrency.rawValue + "/latest" ,method: .get ,encoding: URLEncoding.httpBody ).responseJSON(){ response in

            switch response.result{
               
               case .success(let data):
                            
                // print(data)
                
                   do {
                    let exchange = try JSONDecoder().decode(Exchange.self, from:  response.data! )
                    completion(exchange)
                    }
                   catch {print(error)}
                        
                   
                 
               case .failure(let err):
                   print(err.localizedDescription)
               }
           }
    }
    
    
    func sumbitToConvert (sell : Exchange , recieve : Exchange ) {
        
        if recieve.amount == "" {
            return
        }
        
        if sell.currency == recieve.currency {
            self.alertMsg.accept(CurrencyConvertorMsg(title: Commons.shared.getLocalized(key: "error"), msg: Commons.shared.getLocalized(key: "currency_sell_recieve_same_error")))
            return
        }
                
        if sell.amountToDouble == 0  {
            self.amountToSend.accept(0)
            self.alertMsg.accept(CurrencyConvertorMsg(title: Commons.shared.getLocalized(key: "error"), msg: Commons.shared.getLocalized(key: "amount_for_sell_zero_error")))
            return
        }
        
        if var allBalances = self.userBalances.value {
            
            if let userCurrentTrade = userBalances.value?.enumerated().first(where: { (exchange) -> Bool in
                return  exchange.element.type == sell.type
            }) {
                
                if userCurrentTrade.element.amountToDouble >= sell.amountToDouble + (conversionsCount < 5 ? 0 : 0.7) {
                    
                    allBalances[userCurrentTrade.offset] = Exchange(amount: String(Double(userCurrentTrade.element.amountToDouble - sell.amountToDouble - (conversionsCount < 5 ? 0 : 0.7)))  , currency: sell.currency)
                    
                    if let currencyToRecieve = userBalances.value?.enumerated().first(where: { (exchange) -> Bool in
                        return  exchange.element.type == recieve.type
                    }) {
                        
                        allBalances[currencyToRecieve.offset] = Exchange(amount: String(Double(currencyToRecieve.element.amountToDouble + recieve.amountToDouble)) , currency: recieve.currency)
                        
                    }
                 
                    self.userBalances.accept(allBalances)
                    
                    if conversionsCount < 5 {
                        self.alertMsg.accept(CurrencyConvertorMsg(title: Commons.shared.getLocalized(key: "currency_converted"), msg: Commons.shared.getLocalized(key: "currency_converted_desc_info" , arguments: [sell.amountToDouble , sell.currency , recieve.amountToDouble , recieve.currency])))
                        
                    }else {
                        self.alertMsg.accept(CurrencyConvertorMsg(title: Commons.shared.getLocalized(key: "currency_converted"), msg: Commons.shared.getLocalized(key: "currency_converted_with_commission_desc_info" , arguments: [sell.amountToDouble , sell.currency , recieve.amountToDouble , recieve.currency  , sell.currency])))
                    }

                    self.amountToRecieve.accept(0)
                    self.amountToSend.accept(0)

                    conversionsCount += 1

                    
                }else {
                    self.alertMsg.accept(CurrencyConvertorMsg(title: Commons.shared.getLocalized(key: "error"), msg: Commons.shared.getLocalized(key: "sell_amount_not_enough" , arguments: [sell.currency])))
                }
                
            }
            
            
        }
       
    }
    

    
}
