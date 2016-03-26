//
//  LocalNotificationManeger.swift
//  StockSwitch
//
//  Created by mizuho on 2016/03/25.
//  Copyright © 2016年 mizuho. All rights reserved.
//

import UIKit

//賞味期限におけるローカル通知
public class LocalNotificationManager: UIResponder,UIApplicationDelegate{
    func addLocalNotification(){
        var notification:UILocalNotification = UILocalNotification.init()
        notification.fireDate = NSDate(timeIntervalSinceNow: 30)
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "test"
        notification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}