//
//  NotificationViewController.swift
//  ContentExtension
//
//  Created by Allen Boynton on 6/11/17.
//  Copyright © 2017 Allen Boynton. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

//    @IBOutlet weak var notifImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {

//        guard let attachment = notification.request.content.attachments.first else {
//            return
//        }
//        
//        if attachment.url.startAccessingSecurityScopedResource() {
//            let imageData = try? Data.init(contentsOf: attachment.url)
//            if let img = imageData {
//                notifImageView.image = UIImage(data: img)
//            }
//        }
    }

}
