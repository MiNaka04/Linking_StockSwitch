//
//  ViewController.swift
//  StockSwitch
//
//  Created by mizuho on 2016/03/14.
//  Copyright © 2016年 mizuho. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BLEConnecterDelegate{
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var connectButton :UIButton!
    @IBOutlet var changeLedSettingButton :UIButton!
    @IBOutlet var lightningButton :UIButton!
    var connecter: BLEConnecter?
    var peripheral: CBPeripheral?
    var device: BLEDeviceSetting?
    var canDiscover = false
    var canConnect = false
    var canLightning = false
    var settingPatternNumber:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // インスタンス生成
        self.connecter = BLEConnecter.sharedInstance()
        // デリゲートの登録
        self.connecter?.addListener(self, deviceUUID: nil)
        // 接続ボタン非活性
        self.connectButton.enabled = false
        // LEDパターン変更ボタン非活性
        self.changeLedSettingButton.enabled = false
        // LED点灯ボタン非活性
        self.lightningButton.enabled = false
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        // デリゲートの削除        
        self.connecter?.removeListener(self, deviceUUID: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 検索ボタンタップ時の処理
    @IBAction func searchButtonTap(sender: AnyObject) {
        // BluetoothがONの場合
        if self.canDiscoverDevice() {
            // デバイス検索を開始する
            self.connecter?.scanDevice()
            // 発見したペリフェラル
        }
    }
    
    func canDiscoverDevice() -> Bool {
        return (self.connecter?.canDiscovery)!
    }
    // デバイス検索が成功した時に呼ばれるデリゲート
    
    //接続したいデバイスを選別(Tomoru[デバイス番号]に接続したいTomoruの名称を入力して比較)
    func didDiscoverPeripheral(peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        NSLog("検知したデバイス名:%@",peripheral.name!);
        
        // BLEDeviceSetting(デバイス情報が登録されているクラス)をセットする
        if(peripheral.name == "Linking Board32935"){
            self.device = self.connecter?.getDeviceByPeripheral(peripheral)
            // 発見したペリフェラル
            self.peripheral = peripheral
            // デバイスを発見したので接続ボタンを活性
            self.connectButton.enabled = true
        }
    }
    
    // 接続ボタンタップ時の処理
    @IBAction func connectButtonTap(sender: AnyObject) {
        // 発見したデバイスに接続する
        self.connecter?.connectDevice(self.peripheral)
    }
    
    func didDeviceInitialFinished(peripheral: CBPeripheral!) {
        self.canLightning = peripheral.identifier.UUIDString == self.peripheral?.identifier.UUIDString
        if self.canLightning {
            // LED点灯ボタンを活性
            self.lightningButton.enabled = true
            // LEDパターン変更ボタン活性
            self.changeLedSettingButton.enabled = true
        }
    }
    
    // LED点灯ボタンタップ時の処理
    
    @IBAction func lightningButtonTap(sender: AnyObject) {
        if self.device?.deviceId>0 {
            // LEDを点灯させる(現在設定されている設定値で点灯します)
            BLERequestController.sharedInstance().sendGeneralInformation(nil, text: nil, appName: nil, appNameLocal: nil, package: nil, notifyId: 0, notifyCategoryId: 0, ledSetting: true, vibrationSetting: false, led: nil, vibration: nil, deviceId: (self.device?.deviceId)!, deviceUId: nil, peripheral: self.peripheral, disconnect: false)
        }
    }
    
    @IBAction func changeLedSettingButtonTap(sender: AnyObject) {
        let alertController: UIAlertController = UIAlertController(title: "パターン変更", message: "カラーパターンを変更します", preferredStyle: .ActionSheet)
        
        var alet_title: NSString
        
        let countColorPattern: Int = Int((self.device?.settingInformationDataLED["patterns"] as! Int))
        
        for (var i: Int = 0; i < countColorPattern; i++) {
            
            if(i == 0){
                alet_title = "OFF"
            }else{
                alet_title = NSString(format: "%d", i)
            }

            let action: UIAlertAction = UIAlertAction(
                title: alet_title as String,
                style: .Default,
                handler:{
                    (action: UIAlertAction!) -> Void in
                        let num: Int = Int(action.title! as String)!
                        self.changeLEDSetting(num)
                })
            alertController.addAction(action)
        }
        
        let cancel: UIAlertAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: {(action: UIAlertAction!) -> Void in })
        
        alertController.addAction(cancel)
        self.presentViewController(alertController, animated: true, completion: { _ in })
    }

    
    //LEDのパターンを選択したパターンに変更する
    func changeLEDSetting(num: Int) {
        //設定値1はOFFの設定の為、設定値2をパターン1として実装。
        self.settingPatternNumber = num + 1
        //現在の設定値をコピーしパターンだけ変更

        let dic: NSMutableDictionary = NSMutableDictionary(dictionary: (self.device?.settingInformationDataLED)!)
        dic.setObject(self.settingPatternNumber, forKey: "settingPatternNumber")

        BLERequestController.sharedInstance().setSelectSettingInformationWithLED(dic.copy() as! [NSObject : AnyObject], vibration: nil, peripheral: self.peripheral, disconnect: false)
    }
    
    //LEDのパターン変更完了のデリゲート
    
    func sendSelectSettingInformationRespSuccessDelegate(peripheral: CBPeripheral!) {
        //設定の変更が反映されているかデバイス情報を取得
        BLERequestController.sharedInstance().getSettingInformationMessage(self.peripheral, disconnect: false)
    }

    func getSettingInformationRespSuccessDelegate(peripheral: CBPeripheral!) {
        //設定したパターンの値と一致していれば変更完了
        //NSLog("Access成功(%@)", peripheral.name!)
        
    //if (Int((self.device?.settingInformationDataLED.objectForKey("settingPatternNumber"))! as! String)! == Int(self.settingPatternNumber)) {
            let alertController = UIAlertController(title: "確認", message: "設定を変更しました", preferredStyle: .Alert)
            
            let confirm: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: {(action:UIAlertAction!) -> Void in print("OK")})
                
            alertController.addAction(confirm)
            self.presentViewController(alertController, animated: true, completion: { _ in })
        
        }
   // }
    
    /*
    繋がらない、メッセージが送信できていない場合は下記デリゲートを確認
    ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓
    */
    
    //接続に失敗した
    func didFailToConnectPeripheral(peripheral: CBPeripheral!, error: NSError!) {
        NSLog("接続に失敗しました(%@)", peripheral.name!)
    }

    //デバイスが切断された
    func didDisconnectPeripheral(peripheral: CBPeripheral!) {
        NSLog("%@が切断されました", peripheral.name!)
    }
    
    //書き込みが失敗した
    func didFailToWrite(peripheral: CBPeripheral!, error: NSError!) {
        NSLog("書き込みが失敗しました:(%@)", error)
    }
    
}
