//
//  SettingViewController.swift
//  StockSwitch
//
//  Created by riri on 2016/03/22.
//  Copyright © 2016年 mizuho. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController{
    
    @IBOutlet weak var textBoxAlertDate: UITextField!
    @IBOutlet weak var textBoxExpiryDate: UITextField!
    @IBOutlet weak var textBoxFallPercentage: UITextField!

    @IBOutlet var ConnectBLEName   :UILabel!
    @IBOutlet var BLEBatLv   :UILabel!
    
    var delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textBoxAlertDate.text = String(SettingsData.alertDate)
        textBoxExpiryDate.text = String(SettingsData.expiryDate)
        textBoxFallPercentage.text = String(SettingsData.fallPercentage)

        SetBLEInfoTxt()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func setButtonClicked(sender: UIButton) {
        let alertDate : Int? = Int(textBoxAlertDate.text!)
        if (alertDate != nil){
            SettingsData.alertDate = (alertDate)!
        }

        let expiryDate : Int? = Int(textBoxExpiryDate.text!)
        if (expiryDate != nil){
            SettingsData.expiryDate = (expiryDate)!
        }
        
        let fallPercentage : Int? = Int(textBoxFallPercentage.text!)
        if (fallPercentage != nil){
            SettingsData.fallPercentage = (fallPercentage)!
        }
    }
    
    func SetBLEInfoTxt(){
        ConnectBLEName.text = self.delegate.blename
        BLEBatLv.text = self.delegate.blebat
    }
    
/*
    func receivedAdvertisement(peripheral: CBPeripheral!, advertisement data: [NSObject : AnyObject]!) {
        if(peripheral == self.peripheral){
            let batteryLv: Float = Float((data["remainingPercentage"] as! Float))
            BLEBatLv.text = String(batteryLv)
        }
    }
*/

}
