//
//  Notifications.swift
//  PokéMatch
//
//  Created by Allen Boynton on 8/7/17.
//  Copyright © 2017 Allen Boynton. All rights reserved.
//

import Foundation
import UserNotifications

class Notifications {
    // MARK: Notification function
    
    func showNotification(inSeconds: TimeInterval, completion: @escaping (_ Success: Bool) -> ())  {
        // Add an attachment
        let logoImage = "tenor1"
        guard let imageURL = Bundle.main.url(forResource: logoImage, withExtension: "gif") else {
            completion(false)
            return
        }
        
        var attachment: UNNotificationAttachment
        
        attachment = try! UNNotificationAttachment(identifier: "myNotification", url: imageURL, options: .none)
        
        // Create timer for notification to alert once app is exited
        let notification = UNMutableNotificationContent()
        
        notification.title = "New PokéMatch Notification"
        notification.subtitle = "Come back to PokéMatch?"
        notification.body = "Tap here to finish your game!"
        notification.badge = 1
        
        notification.attachments = [attachment]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        let request = UNNotificationRequest(identifier: "gameOver", content: notification, trigger: trigger)
        
        // Add to Notification Center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            
            if error != nil {
                print(error.debugDescription)
                completion(false)
            } else {
                completion(true)
            }
        })
    }
}
