//
//  CurrencyClass.swift
//  PurchaseAndConvert
//
//  Created by Alan Sproat on 1/5/19.
//  Copyright © 2019 Gary Sproat. All rights reserved.
//

import Foundation

struct Currency
{
    var currencyName: String!
    var currencyCode: String!
    
    init(name: String, code: String)
    {
        currencyName = name
        currencyCode = code
    }
}
