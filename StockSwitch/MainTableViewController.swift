//
//  MainTableViewController.swift
//  StockSwitch
//
//  Created by Yoko Yamanouchi on 2016/03/16.
//  Copyright © 2016年 mizuho. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, BLEConnecterDelegate {
/*
    var items = [("03/10", "ホウレンソウ", 50)
        , ("03/15", "ホウレンソウ", 90)
        , ("03/20", "りんご", 10)
    ]
*/
    var items: NSMutableArray = []
    
    //SettingsViewControllerの有効化
    let SettingView = SettingsViewController()
    
    var connecter: BLEConnecter?
    var peripheral: CBPeripheral?
    var device: BLEDeviceSetting?
    var canDiscover = false
    var canConnect = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    //BLE初期設定
    func BLEInit(){
        // インスタンス生成
        self.connecter = BLEConnecter.sharedInstance()
        // デリゲートの登録
        self.connecter?.addListener(self, deviceUUID: nil)
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
        tableView.editing = editing
    }

    override func tableView(tableView: UITableView,canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // 先にデータを更新する
        //items.removeAtIndex(indexPath.row)
        
        // それからテーブルの更新
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)],
            withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MAIN_CELL", forIndexPath: indexPath) as! MainTableViewCell

        let item = items[indexPath.row]
        //cell._date.text = item.0
        //cell._title.text = item.1
        //cell._status.progress = Float(item.2)/100
        

        return cell
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
        if(peripheral.name == "Linking Board32935"){
            self.device = self.connecter?.getDeviceByPeripheral(peripheral)
            // 発見したペリフェラル
            self.peripheral = peripheral
            // デバイスを発見したので接続ボタンを活性
        }
    }
    
    //BLE接続成功
    func didDeviceInitialFinished(peripheral: CBPeripheral!) {
        //        self.canLightning = peripheral.identifier.UUIDString == self.peripheral?.identifier.UUIDString
        
        SettingView.BLEInfo.text = "BLE Connect"
        SettingView.ConnectBLEName.text = peripheral.name!
        self.connecter?.addListener(self, deviceUUID: "8102")
        
        
    }
    
    // Linkingデバイスからの汎用情報通知
    func sendNotifyPdGeneralInformationSuccessDelegate(peripheral: CBPeripheral!, receiveArray: NSMutableArray!) {
        NSLog("Linkingデバイスからの汎用情報が通知されました。");
        
        for (var i:Int=0; i < receiveArray.count; i++) {
            NSLog("index: %d, value: %@", i, String(receiveArray.objectAtIndex(i)));
        }
    }
    
    func receivedAdvertisement(peripheral: CBPeripheral!, advertisement data: [NSObject : AnyObject]!) {
        if(peripheral == self.peripheral){
            let batteryLv: Float = Float((data["remainingPercentage"] as! Float))
            SettingView.BLEBatLv.text = String(batteryLv)
        }
    }
    
    
    
    func deviceButtonPushed(peripheral: CBPeripheral!, buttonID: Int8) {
        NSLog("ボタン %d が操作されました。", buttonID);
    }
    
    func sendSelectSettingInformationRespSuccessDelegate(peripheral: CBPeripheral!) {
        //設定の変更が反映されているかデバイス情報を取得
        BLERequestController.sharedInstance().getSettingInformationMessage(self.peripheral, disconnect: false)
    }
    func getSettingInformationRespSuccessDelegate(peripheral: CBPeripheral!) {
    }
    

}
