//
//  SettingViewController.swift
//  StockSwitch
//
//  Created by riri on 2016/03/22.
//  Copyright © 2016年 mizuho. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var textBoxAlertDate: UITextField!
    @IBOutlet weak var textBoxExpiryDate: UITextField!
    @IBOutlet weak var textBoxFallPercentage: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setButtonClicked(sender: UIButton) {
    
    }
    
}
