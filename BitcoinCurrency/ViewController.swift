//
//  ViewController.swift
//  BitcoinCurrency
//
//  Created by user192921 on 5/18/21.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  
    
    

    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var coinType: UIPickerView!
    //MARK:- Outlets
    
    //MARK:- Variables and constants
    
    let apiKey = "ZTRiMmE0NmVmYWJiNGZjOGE0MjE3ZDQ2YjVkOWI1NjQ"
    
    let currencies = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let baseUrl = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCAUD"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
        fetchData(url: baseUrl)
        coinType.delegate = self
        coinType.dataSource = self
    }
    func numberOfComponents (in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView (_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        // retorno o numero de moedas para fazer a conversao.
        return currencies.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row:Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
 
    
        var url = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC\(currencies[row])"
        
        fetchData(url: url)
        
    }

    func fetchData (url:String){
         let url = URL(string: url)!
   
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField : "x-ba-key")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                let dataString = String(data: data, encoding: .utf8)
                self.parseJSON(json: data)
            }
            else {
                print("error")
            }
        }
        task.resume()
    }
  
    
        func parseJSON(json: Data) {
            do {
             
            if let json = try JSONSerialization.jsonObject(with: json, options: .mutableContainers) as? [String: Any] {
                print(json)
                if let askValue = json["ask"] as? NSNumber{
                    print(askValue)
             let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    formatter.maximumFractionDigits = 2
                    formatter.decimalSeparator = ","
                    formatter.groupingSeparator = "."
                    let formatterValue = formatter.string(from: askValue)
                
                    let askvalueString = formatterValue
                    DispatchQueue.main.async {

                        self.Price.text = askvalueString
                    }
                    print("success")
                    
                } else {
                    
                    print("error")
                }
            }
                
        } catch {

            print("error parsing json: \(error)")
        }

        }
 
}


        
   
    

