//
//  ViewTableViewCell.swift
//  SMPL Supplier
//
//  Created by Family on 11/11/20.
//  Copyright © 2020 Family. All rights reserved.
//

import UIKit

class ViewTableViewCell: UITableViewCell {

    @IBOutlet weak var inovicenum: UILabel!
    @IBOutlet weak var totalqty: UILabel!
    @IBOutlet weak var Totalamount: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var downloadBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
