/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The process completed view controller scene.
 */

import Foundation
import StoreKit

struct StoreReviewHelper {
    static func incrementAppOpenedCount() { // called from appdelegate didfinishLaunchingWithOptions:
        guard var appOpenCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.APP_OPENED_COUNT) as? Int else {
            UserDefaults.standard.set(1, forKey: UserDefaultsKeys.APP_OPENED_COUNT)
            return
        }
        appOpenCount += 1
        UserDefaults.standard.set(appOpenCount, forKey: UserDefaultsKeys.APP_OPENED_COUNT)
        
//        // Get the current bundle version for the app
//        let infoDictionaryKey = kCFBundleVersionKey as String
//        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
//            else { fatalError("Expected to find a bundle version in the info dictionary") }
//
//        let lastVersionPromptedForReview = UserDefaults.standard.string(forKey: UserDefaultsKeys.LATEST_VERSION)
//
//        // Has the process been completed several times and the user has not already been prompted for this version?
//        if appOpenCount >= 4 && currentVersion != lastVersionPromptedForReview {
//            let twoSecondsFromNow = DispatchTime.now() + 2.0
//            DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
//                StoreReviewHelper().checkAndAskForReview()
//            }
//        }
    }
    func checkAndAskForReview() { // call this whenever appropriate
        // this will not be shown everytime. Apple has some internal logic on how to show this.
        guard let appOpenCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.APP_OPENED_COUNT) as? Int else {
            UserDefaults.standard.set(1, forKey: UserDefaultsKeys.APP_OPENED_COUNT)
            return
        }
        
        switch appOpenCount {
        case 10,50:
            StoreReviewHelper().requestReview()
        case _ where appOpenCount % 100 == 0 :
            StoreReviewHelper().requestReview()
        default:
            print("App run count completed \(appOpenCount) time(s)")
            break;
        }
        
    }
    fileprivate func requestReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            // Fallback on earlier versions
            // Try any other 3rd party or manual method here.
        }
    }
}

struct UserDefaultsKeys {
    static let APP_OPENED_COUNT = "APP_OPENED_COUNT"
    static let LATEST_VERSION = "LATEST_VERSION"
}
