//
//  MainTableViewCell.swift
//  StockSwitch
//
//  Created by Yoko Yamanouchi on 2016/03/16.
//  Copyright © 2016年 mizuho. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var _date: UILabel!
    @IBOutlet weak var _title: UILabel!
    @IBOutlet weak var _status: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
