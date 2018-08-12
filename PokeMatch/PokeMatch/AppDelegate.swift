//
//  AppDelegate.swift
//  PokeMatch
//
//  Created by Allen Boynton on 5/22/17.
//  Copyright © 2017 Allen Boynton. All rights reserved.
//

import UIKit
//import UserNotifications
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var music = Music()
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Start app with sound
        music.startGameMusic()
        
        StoreReviewHelper().checkAndAskForReview()
        
        // Sample AdMob app ID: ca-app-pub-3940256099942544~1458002511
        // Testing banner ID:  ca-app-pub-3940256099942544/2934735716
        GADMobileAds.configure(withApplicationID: "ca-app-pub-2292175261120907~2981949238")
        
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {granted, error in
//
//                if granted {
//                    print("Notification access granted")
//                } else {
//                    print(error?.localizedDescription as Any)
//                }
//            })
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//
//        application.registerForRemoteNotifications()
        
        // Asks permission to show notifications
//        func askToShowVisibleNotifications() {
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { ( granted, error) in
//                print(error?.localizedDescription as Any)
//            }
//        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        bgMusic?.pause()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        bgMusic?.stop()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        music.handleMuteMusic()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        bgMusic?.stop()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
}

//extension AppDelegate: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler(.alert)
//    }
//}
