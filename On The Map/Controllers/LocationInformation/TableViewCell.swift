//
//  TableViewCell.swift
//  On The Map
//
//  Created by Kim Lyndon on 11/2/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
 
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mediaURLLabel: UILabel!
    @IBOutlet weak var pinIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    }
