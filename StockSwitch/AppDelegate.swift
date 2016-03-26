//
//  AppDelegate.swift
//  StockSwitch
//
//  Created by mizuho on 2016/03/14.
//  Copyright © 2016年 mizuho. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var blename:String?
    var blebat:String?
    
    //ApDelegate.swifの起動時に呼ばれる関数
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
         //Notification登録前のおまじない。テストの為、現在のノーティフケーションを削除します
        let types: UIUserNotificationType = [.Badge , .Sound , .Alert]
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        //Notification登録前のおまじない。これがないとpermissionエラーが発生するので必要です。
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: types, categories: nil))
        
        
        //登録処理
        if(ViewController().bEmpty){
            addEmptyLocalNotification()
        }
        if(ViewController().bStock){
            addStockLocalNotification()
        }
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
 
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        var alart = UIAlertView()
        alart.title = "受け取りました"
        alart.message = notification.alertBody
        alart.addButtonWithTitle(notification.alertAction!)
        alart.show()
        
        // アプリ起動中(フォアグラウンド)に通知が届いた場合
        if(application.applicationState == UIApplicationState.Active){
        }
        
        // アプリがバックグラウンドにある状態で通知が届いた場合
        if(application.applicationState == UIApplicationState.Inactive){
        }
        // 通知領域から削除する
        UIApplication.sharedApplication().cancelLocalNotification(notification)
        
    }
    
    //通知処理
    func addStockLocalNotification(){
        
        var notification = UILocalNotification()
        notification.fireDate = ViewController().resStockDate
        notification.timeZone = NSTimeZone.defaultTimeZone()
        let Text :String = String(ViewController().items[0].1) + "は保存して" + String(SettingsData.alertDate) + "日経過しています"
        notification.alertBody = Text
        notification.alertAction = "OK"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
     
    }
    
    func addEmptyLocalNotification(){
        
        var notification = UILocalNotification()
        notification.fireDate = ViewController().ZeroDate
        notification.timeZone = NSTimeZone.defaultTimeZone()
        let Text :String = String(ViewController().items[0].1) + "は保存して" + String(SettingsData.expiryDate) + "日経過しています"
        notification.alertBody = Text
        notification.alertAction = "OK"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }


}

