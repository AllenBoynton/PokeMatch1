//
//  GameCenterVC.swift
//  PokeMatch
//
//  Created by Allen Boynton on 5/25/17.
//  Copyright © 2017 Allen Boynton. All rights reserved.
//

//import UIKit
//import GameKit
//
//let timeLeaderboardID = "BEST_TIME"
//let pointsLeaderboardID = "HIGH_POINTS"

/************************************ Game Center Methods *****************************************/
// MARK: - Game Center Methods

//class GameCenterVC: UIViewController, GKGameCenterControllerDelegate {

    // Class delegates
//    let pokeMatchVC = PokeMatchVC()
    
//    // The local player object.
//    let gameCenterPlayer = GKLocalPlayer.localPlayer()
    
    // Local GC variables
//    var gcEnabled = Bool() // Check if the user has Game Center enabled
//    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
//    
//    var score = 0
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        authenticatePlayer()
//    }

//    // Authenticates the user to access to the GC
//    func authenticatePlayer() {
//        
//        // The local player object.
//        let localPlayer = GKLocalPlayer.localPlayer()
//        
//        localPlayer.authenticateHandler = {(view, error) -> Void in
//            if((view) != nil) {
//                
//                // 1. Show login if player is not logged in
//                self.present(view!, animated: true, completion: nil)
//                
//            } else if (localPlayer.isAuthenticated) {
//                
//                // 2. Player is already authenticated & logged in, load game center
//                self.gcEnabled = true
//                
//                // Get the default leaderboard ID
//                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifier, error) in
//                    if error != nil {
//                        
//                        print(error as Any)
//                    } else {
//                        
//                        self.gcDefaultLeaderBoard = leaderboardIdentifier!
//                    }
//                })
//                
//            } else {
//                // 3. Game center is not enabled on the users device
//                self.gcEnabled = false
//                print("Local player could not be authenticated!")
//                print(error as Any)
//            }
//        }
//        
//        NotificationCenter.default.addObserver(
//            self, selector: #selector(authenticationDidChange(_:)),
//            name: NSNotification.Name(rawValue: GKPlayerAuthenticationDidChangeNotificationName),
//            object: nil
//        )
//    }
    
//    func notificationReceived() {
//        print("GKPlayerAuthenticationDidChangeNotificationName - Authentication Status: \(gameCenterPlayer.isAuthenticated)")
//    }
    
//    // Reporting score
//    func saveHighScore(_ score: Int64) {
//        
//        if GKLocalPlayer.localPlayer().isAuthenticated {
//            
//            let gkScore = GKScore(leaderboardIdentifier: pointsLeaderboardID)
//            gkScore.value = score
//            
//            let gkScoreArray: [GKScore] = [gkScore]
//            
//            GKScore.report(gkScoreArray, withCompletionHandler: { error in
//                guard error == nil  else { return }
//                
//                let vc = GKGameCenterViewController()
//                vc.leaderboardIdentifier = pointsLeaderboardID
//                vc.gameCenterDelegate = self
//                vc.viewState = .leaderboards
//                
//                self.present(vc, animated: true, completion: nil)   })
//        }
//    }
//    
//    func authenticationDidChange(_ notification: Notification) {
//        saveHighScore(0) // report example score after user logs in
//    }
    
//    // Continue the Game, if GameCenter Auth state has been changed
//    func gameCenterStateChanged() {
//        view.isUserInteractionEnabled = true
//    }
    
    // Retrieves the GC VC leaderboard
//    func showLeaderboard() {
//        
//        let viewController = self.view.window?.rootViewController
//        
//        let gameCenterViewController = GKGameCenterViewController()
//        gameCenterViewController.gameCenterDelegate = self
//        gameCenterViewController.viewState = .leaderboards
//        gameCenterViewController.leaderboardIdentifier = pointsLeaderboardID
//        
//        // Show leaderboard
//        viewController?.present(gameCenterViewController, animated: true, completion: nil)
//    }
//    
//    // Continue the game after GameCenter is closed
//    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
//        
//        gameCenterViewController.dismiss(animated: true, completion: nil)
//        
//        pokeMatchVC.gameOver = false
//    }
//}

