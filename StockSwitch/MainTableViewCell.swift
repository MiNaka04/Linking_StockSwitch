//
//  MainTableViewCell.swift
//  StockSwitch
//
//  Created by Yoko Yamanouchi on 2016/03/16.
//  Copyright © 2016年 mizuho. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell{

    @IBOutlet weak var _date: UILabel!
    @IBOutlet weak var _title: UILabel!
    @IBOutlet weak var _status:
    
    UIProgressView!
    @IBOutlet weak var _value: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(Date : String, Title: String, Status: Int) {
        self._date.text = Date
        self._title.text = Title
        self._value.text = String(Status)
        self._status.progress = Float(Status)/100
    }
    
    
    

}
