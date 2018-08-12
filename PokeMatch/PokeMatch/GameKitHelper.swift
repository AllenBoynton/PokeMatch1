////
////  GameKitHelper.swift
////  PokéMatch
////
////  Created by Allen Boynton on 5/28/17.
////  Copyright © 2017 Allen Boynton. All rights reserved.
////
//
//import UIKit
//import GameKit
//
//protocol GameKitHelperDelegate {
//    func matchStarted()
//    func matchEnded()
//    func matchReceivedData(match: GKMatch, data: NSData,
//                           fromPlayer player: String)
//}
//
//class GameKitHelper: NSObject, GKGameCenterControllerDelegate, GKMatchmakerViewControllerDelegate, GKMatchDelegate {
//    
//    var delegate: GameKitHelperDelegate?
//    var multiplayerMatch: GKMatch?
//    
//    var presentingViewController: UIViewController?
//    var multiplayerMatchStarted: Bool
//    var gcEnabled = Bool()
//    
//    override init() {
//        multiplayerMatchStarted = false
//    }
//    
//    func findMatch(minPlayers: Int, maxPlayers: Int, presentingViewController viewController: UIViewController,
//                   delegate: GameKitHelperDelegate) {
//        //1
//        if !gcEnabled {
//            print("Local player is not authenticated")
//            return
//        }
//        
//        //2
//        multiplayerMatchStarted = false
//        multiplayerMatch = nil
//        self.delegate = delegate
//        presentingViewController = viewController
//        
//        //3
//        let matchRequest = GKMatchRequest()
//        matchRequest.minPlayers = minPlayers
//        matchRequest.maxPlayers = maxPlayers
//        
//        //4
//        let matchMakerViewController = GKMatchmakerViewController(matchRequest: matchRequest)
//        matchMakerViewController?.matchmakerDelegate = self
//        
//        presentingViewController?.present(matchMakerViewController!, animated: false, completion: nil)
//    }
//    
//    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
//        
//        presentingViewController?.dismiss(animated: true, completion: nil)
//        delegate?.matchEnded()
//    }
//    
//    func matchmakerViewController(viewController: GKMatchmakerViewController!, didFailWithError error: NSError!) {
//        
//        presentingViewController?.dismiss(animated: true, completion: nil)
//        print("Error creating match: \(error.localizedDescription)")
//        delegate?.matchEnded()
//    }
//    func matchmakerViewController(viewController: GKMatchmakerViewController!, didFindMatch match: GKMatch!) {
//        
//        presentingViewController?.dismiss(animated: true, completion: nil)
//        multiplayerMatch = match
//        multiplayerMatch!.delegate = self
//        
//        if !multiplayerMatchStarted &&
//            multiplayerMatch?.expectedPlayerCount == 0 {
//            print("Ready to start the match")
//        }
//    }
//    
//    // Matchmaker
//    func match(match: GKMatch!, didReceiveData data: NSData!, fromPlayer playerID: String!) {
//        
//        if multiplayerMatch != match {
//            return
//        }
//        delegate?.matchReceivedData(match: match, data: data, fromPlayer: playerID)
//    }
//    
//    func match(match: GKMatch!, didFailWithError error: NSError!) {
//        if multiplayerMatch != match {
//            return
//        }
//        multiplayerMatchStarted = false
//        delegate?.matchEnded()
//    }
//    
//    func match(match: GKMatch!, player playerID: String!, didChangeState state: GKPlayerConnectionState) {
//        
//        if multiplayerMatch != match {
//            return
//        }
//        
//        switch state {
//            
//        case .stateConnected:
//            print("Player connected")
//            if !multiplayerMatchStarted &&
//                multiplayerMatch?.expectedPlayerCount == 0 {
//                print("Ready to start the match")
//            }
//        case .stateDisconnected:
//            print("Player disconnected")
//            multiplayerMatchStarted = false
//            delegate?.matchEnded()
//        case .stateUnknown:
//            print("Initial player state")
//        }
//    }
//}
