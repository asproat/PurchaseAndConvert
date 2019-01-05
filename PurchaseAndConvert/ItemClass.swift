//
//  ItemClass.swift
//  PurchaseAndConvert
//
//  Created by Alan Sproat on 1/5/19.
//  Copyright © 2019 Gary Sproat. All rights reserved.
//

import Foundation

class Item
{
    var itemName : String!
    var itemPrice : Float!
    var itemUnit : String!
    var itemCount : Int = 0
    
    init(name: String, price: Float, unit: String)
    {
        itemName = name
        itemPrice = price
        itemUnit = unit
    }
}
