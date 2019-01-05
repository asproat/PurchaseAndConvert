//
//  CurrencyViewController.swift
//  PurchaseAndConvert
//
//  Created by Alan Sproat on 1/5/19.
//  Copyright © 2019 Gary Sproat. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var convertedTotal: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var currencies : [Currency]?
    var totalUSD : Float = 0.00
    
    let APIKey : String = "3322a128ce9574e8da21c690f981d76c"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        convertedTotal.text = "\(totalUSD) USD"
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        getCurrencies()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = "\(currencies?[indexPath.row].currencyName ?? "")"

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        // get conversion
        //http://apilayer.net/api/convert?from=EUR&to=GBP&amount=100
        let url = URL(string: "http://apilayer.net/api/live?source=USD&currencies=\(currencies![indexPath.row].currencyCode ?? "USD")&amount=\(totalUSD)&access_key=\(APIKey)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 5
        let dataTask = URLSession.shared.dataTask(with: request)
        {
            (data, response, error) in
            if let _ = error
            {
                let alert = UIAlertController(title: "Conversion Error", message: "Error Converting Total", preferredStyle: .alert )
                let action1 = UIAlertAction(title: "OK", style: .default)
                alert.addAction(action1)
                self.present(alert, animated: true, completion: nil)

            }
            else
            {
                if let usableData = data
                {
                    do
                    {
                        let jsonData = try JSONSerialization.jsonObject(with: usableData, options: .mutableContainers) as! [String: Any]
                        DispatchQueue.main.async
                            {
                                if jsonData["success"] as! Int == 1
                                {
                                    let converted = (jsonData["quotes"]! as! [String:Any])["USD" + self.currencies![indexPath.row].currencyCode]! as! NSNumber
                                    self.convertedTotal.text = "\(converted.floatValue * self.totalUSD) \(self.currencies?[indexPath.row].currencyCode ?? "")"
                                }
                                else
                                {
                                    self.convertedTotal.text = "Error in conversion"
                                }
                        }
                    }
                    catch
                    {
                        DispatchQueue.main.async
                            {
                        let alert = UIAlertController(title: "Conversion Error", message: "Error Converting Total", preferredStyle: .alert )
                                let action1 = UIAlertAction(title: "OK", style: .default)
                                alert.addAction(action1)

                                self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func getCurrencies()
    {
        currencies = [Currency]()
        let url = URL(string: "http://apilayer.net/api/list?access_key=\(APIKey)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 5
        let dataTask = URLSession.shared.dataTask(with: request)
        {
            (data, response, error) in
            if let _ = error
            {
                print("error = \(String(describing: error))")
                let alert = UIAlertController(title: "Currency Error", message: "Error Fetching Currencies", preferredStyle: .alert )
                let action1 = UIAlertAction(title: "OK", style: .default)
                alert.addAction(action1)

                self.present(alert, animated: true, completion: nil)

            }
            else
            {
                if let usableData = data
                {
                    do
                    {
                        let jsonData = try JSONSerialization.jsonObject(with: usableData, options: .mutableContainers) as! [String: Any]
                        for currency in jsonData["currencies"] as! [String:String]
                        {
                            self.currencies?.append(Currency(name: currency.value, code: currency.key))
                        }
                        self.currencies?.sort(by: { $0.currencyName < $1.currencyName } )
                        DispatchQueue.main.async
                            {
                                self.tableView.reloadData()
                        }
                    }
                    catch
                    {
                        DispatchQueue.main.async
                            {
                                let alert = UIAlertController(title: "Currency Fetch Error", message: "Error Fetching Currencies", preferredStyle: .alert )
                                let action1 = UIAlertAction(title: "OK", style: .default)
                                alert.addAction(action1)

                                self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        dataTask.resume()
    }

}
