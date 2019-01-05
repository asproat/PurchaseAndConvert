//
//  ItemTableViewCell.swift
//  PurchaseAndConvert
//
//  Created by Alan Sproat on 1/5/19.
//  Copyright © 2019 Gary Sproat. All rights reserved.
//

import UIKit

protocol itemCellDelegate: class {
    func changeQuantity(_ newQuantity: Int)
}
class ItemTableViewCell: UITableViewCell {

    weak var delegate: itemCellDelegate?

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemUnit: UILabel!
    @IBOutlet weak var itemQuantity: UILabel!
    
    var cellItem : Item?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func stepperChange(_ sender: UIStepper) {
        cellItem?.itemCount = Int(sender.value)
        itemQuantity.text = "\(Int(sender.value))"
        delegate?.changeQuantity(Int(sender.value))
    }

}
