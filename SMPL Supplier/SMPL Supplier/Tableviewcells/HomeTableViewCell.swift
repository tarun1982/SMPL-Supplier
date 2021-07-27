//
//  HomeTableViewCell.swift
//  SMPL Supplier
//
//  Created by Family on 05/11/20.
//  Copyright © 2020 Family. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var items: UILabel!
    @IBOutlet weak var qty: UITextField!
    @IBOutlet weak var rates: UILabel!
    @IBOutlet weak var amounts: UILabel!
    @IBOutlet weak var butt: UIButton!
    @IBOutlet weak var qtlbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
