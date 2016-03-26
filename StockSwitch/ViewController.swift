//
//  ViewController.swift
//  StockSwitch
//
//  Created by mizuho on 2016/03/23.
//  Copyright © 2016年 mizuho. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BLEConnecterDelegate{
    
    var items: [(String,String,Int)]  = []
    var BLEDeviceName = "Linking Board32935"
//    var BLEDeviceName = "Linking 6x31 00005"
/*
   var items = [("03/10", "ホウレンソウ", 50)
        , ("03/15", "ホウレンソウ", 90)
        , ("03/20", "りんご", 10)
    ]
*/
    @IBOutlet weak var tableView: UITableView!
    
    //SettingsViewControllerの有効化
    var connecter: BLEConnecter?
    var peripheral: CBPeripheral?
    var device: BLEDeviceSetting?
    var canDiscover: Bool  = false
    var canConnect: Bool  = false
    var bAddDevice: Bool = false
    var cell: MainTableViewCell?
    let now = NSDate() // 現在日時の取得
    let dateFormatter = NSDateFormatter()
    
    var bSetCount: Bool = false
    
    var sw_judge_time = NSTimeInterval()
    var sw_timer = NSTimer()
    var sw_cnt : Int = 0
    
    var bLED : Bool = false
    var led_judge_time = NSTimeInterval()
    var led_timer = NSTimer()
    
    var StockDate: NSDate?
    var ZeroDate: NSDate?
    var resStockDate: NSDate?
    var resEmptyDate: NSDate?
    var bEmpty: Bool = false
    var bStock: Bool = false
    
    var delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") // ロケールの設定
        dateFormatter.dateFormat = "MM/dd" // 日付フォーマットの設定
        

        // ナビゲーションバーに表示するタイトル.
        self.title = "Stock Switch"
        // ナビゲーションバーを表示.
        self.navigationController?.navigationBarHidden = false
        // ナビゲーションバーの右側に編集ボタンを追加
        
        let EditButton:UIBarButtonItem = self.editButtonItem()
        let AddButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addCell:")
        let myRightButtons: NSArray = [EditButton,AddButton]
        self.navigationItem.setRightBarButtonItems(myRightButtons as? [UIBarButtonItem], animated: false)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.BLEInit();

    }
    
    //BLE初期設定
    func BLEInit(){
        // インスタンス生成
        self.connecter = BLEConnecter.sharedInstance()
        // デリゲートの登録
        self.connecter?.addListener(self, deviceUUID: nil)
        self.connecter?.addListener(self, deviceUUID: "8102")
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        //アプリが閉じるとき
        notificationCenter.addObserver(
            self,
            selector: "AppClose",
            name:UIApplicationWillTerminateNotification,
            object: nil)
    }
    
    //アプリ終了時の処理
    func AppClose(){
        //BLEのデリゲートを消す
        if((self.connecter?.isScanning()) != nil){
            self.connecter?.stopScan()
        }
        self.connecter?.removeListener(self, deviceUUID: "8102")
        self.connecter?.removeListener(self, deviceUUID: nil)

    }
    
    func numberOfSelections() -> Int{
        return 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        // TableViewを編集可能にする
        self.tableView.setEditing(editing, animated: true)
        
        // 編集中のときのみaddButtonをナビゲーションバーの左に表示する
        if editing {
        } else {
        }
        
    }
    /*
    addButtonが押された際呼び出される
    */
    
    func addCell(sender: AnyObject) {
        // Style Alert　Linking Device名を登録
        let alert: UIAlertController = UIAlertController(title:"Linking Connect",
            message: "Linking Device名を入力してください",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        
        let okAction: UIAlertAction = UIAlertAction(title: "完了",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                let textField = alert.textFields![0] 
                self.BLEDeviceName = textField.text!
                //Linkingを探す
                self.bAddDevice = true
                if self.canDiscoverDevice() {
                    // デバイス検索を開始する
                    self.connecter?.scanDevice()
                    // 発見したペリフェラル
                }
                
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル",
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction!) -> Void in
        })
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        // UIAlertControllerにtextFieldを追加
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
            textField.text = self.BLEDeviceName
        }
        self.presentViewController(alert, animated: true, completion: nil)
        
        // TableViewを再読み込み.
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView,canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // 先にデータを更新する
        if(!items.isEmpty){
            items.removeAtIndex(indexPath.row)
        }
        // それからテーブルの更新
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)],
            withRowAnimation: UITableViewRowAnimation.Fade)
        
        //BLEデバイスを外す
        if((self.connecter?.isScanning()) != nil){
            self.connecter?.stopScan()
        }
        self.connecter?.disconnectByDeviceUUID(self.peripheral?.identifier.UUIDString)
        
        
        //BLERequestController.sharedInstance().deleteDevices()
       
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        cell = tableView.dequeueReusableCellWithIdentifier("MAIN_CELL", forIndexPath: indexPath) as! MainTableViewCell
        
        // Cellに値を設定.
        if(!items.isEmpty){
            let item = items[indexPath.row]
            if(item.2 == 0){
                cell!.backgroundColor = UIColor(red: 255/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0);
            }else{
                cell!.backgroundColor = UIColor.whiteColor();
            }
            cell!.setCell(item.0, Title: item.1, Status: Int(item.2));
        }
        
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //BLE通信処理
    func canDiscoverDevice() -> Bool {
        return (self.connecter?.canDiscovery)!
    }
    
    // デバイス検索が成功した時に呼ばれるデリゲート
    //接続したいデバイスを選別(Tomoru[デバイス番号]に接続したいTomoruの名称を入力して比較)
    func didDiscoverPeripheral(peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        NSLog("検知したデバイス名:%@",peripheral.name!);
        
        // BLEDeviceSetting(デバイス情報が登録されているクラス)をセットする
        if(peripheral.name == BLEDeviceName){
            self.device = self.connecter?.getDeviceByPeripheral(peripheral)
            // 発見したペリフェラル
            self.peripheral = peripheral

            // デバイスを接続
            self.connecter?.connectDevice(self.peripheral)
        }
    }
    
    //BLE接続成功
    func didDeviceInitialFinished(peripheral: CBPeripheral!) {
        //        self.canLightning = peripheral.identifier.UUIDString == self.peripheral?.identifier.UUIDString
        
//        SettingView.BLEInfo.text = "BLE Connect"
//        SettingView.ConnectBLEName.text = peripheral.name!
        
        //成功通知
        let alert = UIAlertController(title: "Success", message: "Linking Device Connect.", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{
            (action:UIAlertAction!) -> Void in
            if self.bAddDevice{
                self.addCellArray()
            }
        })
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        self.delegate.blename = peripheral.name!

    }
    
    func addCellArray(){
        var FoodName:String?
        //担当名追加
        let alert: UIAlertController = UIAlertController(title:"Linking Connect",
            message: "記録する食品名を入力してください",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        
        let okAction: UIAlertAction = UIAlertAction(title: "完了",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                let textField = alert.textFields![0]
                FoodName = textField.text!  //食品名を保管
                self.items.append((self.dateFormatter.stringFromDate(self.now),FoodName!,100))
                // TableViewを再読み込み.
                self.tableView.reloadData()
                self.sw_cnt = 0
                self.bAddDevice = false
                self.StockDate = NSDate()                 //登録した日付を取得
                self.DateAlertStockSetting()
        })
        
        alert.addAction(okAction)
        // UIAlertControllerにtextFieldを追加
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
        }
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    // Linkingデバイスからの汎用情報通知
    func sendNotifyPdGeneralInformationSuccessDelegate(peripheral: CBPeripheral!, receiveArray: NSMutableArray!) {
        NSLog("Linkingデバイスからの汎用情報が通知されました。");
        
        for (var i:Int=0; i < receiveArray.count; i++) {
            NSLog("index: %d, value: %@", i, String(receiveArray.objectAtIndex(i)));
        }
    }
    
    func receivedAdvertisement(peripheral: CBPeripheral!, advertisement data: [NSObject : AnyObject]!) {
        if(peripheral.name == BLEDeviceName){
            let batteryLv: Float = Float((data["remainingPercentage"] as! Float))

            self.delegate.blebat = String(batteryLv)
        }
    }
    
    func deviceButtonPushed(peripheral: CBPeripheral!, buttonID: Int8) {
        // TableViewを再読み込み.
        NSLog("ボタン %d が操作されました。", buttonID);
        bSetCount = true
        if(sw_cnt == 0){
            // タイマー生成、開始 １秒後の実行
            sw_timer = NSTimer.scheduledTimerWithTimeInterval(
                0.01,                                   // 時間の間隔〔0.01〕
                target: self,                           // タイマーの実際の処理の場所
                selector: Selector("SwichAction"),        // メソッド タイマーの実際の処理
                userInfo: nil,
                repeats: true)                          // 繰り返し
            // NSDate：日付と時間を管理するクラス
            sw_judge_time = NSDate.timeIntervalSinceReferenceDate()
        }
        sw_cnt++
    }
    
    // タイマー処理
    func SwichAction(){
        // NSTimer：タイマーを管理するクラス
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        // 現在の時間を調べるためにスタートします
        let Time: NSTimeInterval = currentTime - sw_judge_time
        
        let time_cnt = Int(Time*100)
        
        //1回目のボタンを押してから2秒間で判定
        if(time_cnt >= 200){
            switch sw_cnt{
                case 2:
                    items[0].2 += SettingsData.fallPercentage
                break
                case 3:
                    items[0].2 = 0
                break
                case 4:
                    items[0].2 = 100
                break
                default:
                    items[0].2 -= SettingsData.fallPercentage
                    if(items[0].2<=0){
                        items[0].2 = 0
                    }
                break
            }
            self.tableView.reloadData()
            bSetCount = false
            sw_cnt = 0
            
            if(items[0].2 == 0){
                LED_LightUp()
                ZeroDate = NSDate()                 //0になった日付を取得
                DateAlertEmptySetting()
                
            }
            sw_timer.invalidate()
        }
    }
    
    func LED_LightUp(){
        // タイマー生成、開始 １秒後の実行
        LEDChengeStatus(true)
        
        led_timer = NSTimer.scheduledTimerWithTimeInterval(
            0.01,                                   // 時間の間隔〔0.01〕
            target: self,                           // タイマーの実際の処理の場所
            selector: Selector("LEDAction"),        // メソッド タイマーの実際の処理
            userInfo: nil,
            repeats: true)                          // 繰り返し
        // NSDate：日付と時間を管理するクラス
        led_judge_time = NSDate.timeIntervalSinceReferenceDate()
        
    }
    
    // タイマー処理
    func LEDAction(){
        // NSTimer：タイマーを管理するクラス
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        // 現在の時間を調べるためにスタートします
        let Time: NSTimeInterval = currentTime - led_judge_time
        
        let time_cnt = Int(Time*100)
        
        //1回目のボタンを押してから2秒間で判定
        if(time_cnt >= 180){
            LEDChengeStatus(false)
            led_timer.invalidate()
        }
    }
    
    func LEDChengeStatus(ledstatus: Bool){
        var LedInitNum:Int = 0
        bLED = true
        if(ledstatus){
            LedInitNum = 3  //1秒毎に点滅
        }else{
            LedInitNum = 1  //消灯
        }
        let dic: NSMutableDictionary = NSMutableDictionary(dictionary: (self.device?.settingInformationDataLED)!)
        dic.setObject(LedInitNum, forKey: "settingPatternNumber")
        
        BLERequestController.sharedInstance().setSelectSettingInformationWithLED(dic.copy() as! [NSObject : AnyObject], vibration: nil, peripheral: self.peripheral, disconnect: false)
        
    }
    
    func LED_Power(){
            // LEDを点灯させる(現在設定されている設定値で点灯します)
            BLERequestController.sharedInstance().sendGeneralInformation(nil, text: nil, appName: nil, appNameLocal: nil, package: nil, notifyId: 0, notifyCategoryId: 0, ledSetting: true, vibrationSetting: false, led: nil, vibration: nil, deviceId: (self.device?.deviceId)!, deviceUId: nil, peripheral: self.peripheral, disconnect: false)
    }
    
    func sendSelectSettingInformationRespSuccessDelegate(peripheral: CBPeripheral!) {
        //設定の変更が反映されているかデバイス情報を取得
        BLERequestController.sharedInstance().getSettingInformationMessage(self.peripheral, disconnect: false)
    }
    
    func getSettingInformationRespSuccessDelegate(peripheral: CBPeripheral!) {
        if(bLED){
            LED_Power()
            bLED = false
        }
    }
    
    /*
    繋がらない、メッセージが送信できていない場合は下記デリゲートを確認
    ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓
    */
    
    //接続に失敗した
    func didFailToConnectPeripheral(peripheral: CBPeripheral!, error: NSError!) {
        NSLog("接続に失敗しました(%@)", peripheral.name!)

        //失敗通知
        let alertController = UIAlertController(title: "Error", message: "Linking Device cannot Connect.", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        if self.bAddDevice{
            self.bAddDevice = false
        }
    }
    
    //デバイスが切断された
    func didDisconnectPeripheral(peripheral: CBPeripheral!) {
        NSLog("%@が切断されました", peripheral.name!)
        if self.bAddDevice{
            self.bAddDevice = false
        }
    }
    
    //書き込みが失敗した
    func didFailToWrite(peripheral: CBPeripheral!, error: NSError!) {
        NSLog("書き込みが失敗しました:(%@)", error)
        if self.bAddDevice{
            self.bAddDevice = false
        }
    }
    
    //日付計算処理
    func DateAlertStockSetting(){
        let StockInterval: NSTimeInterval = NSTimeInterval(SettingsData.alertDate)*24*60*60
        resStockDate = NSDate(timeInterval: StockInterval, sinceDate: StockDate!)
        bEmpty = true
    }
    func DateAlertEmptySetting(){
        let EmptyInterval: NSTimeInterval = NSTimeInterval(SettingsData.expiryDate)*24*60*60
        resEmptyDate = NSDate(timeInterval: EmptyInterval, sinceDate: ZeroDate!)
        bStock = true
    }
    
    
}