//
//  ViewController.swift
//  PurchaseAndConvert
//
//  Created by Alan Sproat on 1/5/19.
//  Copyright © 2019 Gary Sproat. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, itemCellDelegate {

    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var tableVIew: UITableView!
    
    var totalPrice : Float = 0.0
    
    var items : [Item]?
    var cf : NumberFormatter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cf = NumberFormatter()
        cf?.numberStyle = .currency
        
        setData()
        tableVIew.delegate = self
        tableVIew.dataSource = self
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        
        let thisItem = items?[indexPath.row]
        cell.cellItem = thisItem
        cell.itemName.text = thisItem?.itemName
        cell.itemUnit.text = thisItem?.itemUnit
        cell.itemPrice.text = cf?.string(from: thisItem?.itemPrice as! NSNumber)
        cell.itemQuantity.text = "\(thisItem?.itemCount ?? 0)"
        cell.delegate = self
        return cell
    }
    
    func changeQuantity(_ newQuantity: Int) {
        totalPrice = 0.0
        for thisItem in items!
        {
            totalPrice += Float(thisItem.itemCount) * thisItem.itemPrice
        }
        totalLabel.text = "Total \(cf?.string(from:  NSNumber(value: totalPrice)) ?? "$0.00") USD"
    }
    

    
    func setData()
    {
        // initial data setup
        items = [Item(name: "Peas", price: 0.9, unit: "Bag"),
                 Item(name: "Eggs", price: 2.10, unit: "Dozen"),
                 Item(name: "Milk", price: 1.30, unit: "Bottle"),
                 Item(name: "Beans", price: 0.73, unit: "Can")]
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "currencySegue"
        {
            if let destinationVC = segue.destination as? CurrencyViewController {
                destinationVC.totalUSD = totalPrice
            }
        }
    }
    
}


