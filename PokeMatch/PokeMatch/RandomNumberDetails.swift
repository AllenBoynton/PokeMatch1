//
//  RandomNumberDetails.swift
//  PokéMatch
//
//  Created by Allen Boynton on 5/28/17.
//  Copyright © 2017 Allen Boynton. All rights reserved.
//

import UIKit
import GameKit

class RandomNumberDetails: NSObject {
    let playerId: String
    let randomNumber: UInt32
    
    init(playerId: String, randomNumber: UInt32) {
        self.playerId = playerId
        self.randomNumber = randomNumber
        super.init()
    }
    
    func isEqual(object: AnyObject?) -> Bool {
        let randomNumberDetails = object as? RandomNumberDetails
        return randomNumberDetails?.playerId == self.playerId
    }
}

override init() {
    super.init()
    ourRandomNumber = arc4random()
    gameState = GameState.WaitingForMatch
    isPlayer1 = false
    receivedAllRandomNumbers = false
    
    orderOfPlayers = [RandomNumberDetails]()
}
