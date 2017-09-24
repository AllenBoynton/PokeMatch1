//
//  MemoryGameDelegate.swift
//  PokéMatch
//
//  Created by Allen Boynton on 8/6/17.
//  Copyright © 2017 Allen Boynton. All rights reserved.
//

import Foundation

// MARK: - MemoryGameDelegate

protocol MemoryGameDelegate {
    func memoryGameDidStart(_ game: PokeMemoryGame)
    func memoryGame(_ game: PokeMemoryGame, showCards cards: [Card])
    func memoryGame(_ game: PokeMemoryGame, hideCards cards: [Card])
    func memoryGameDidEnd(_ game: PokeMemoryGame, elapsedTime: TimeInterval)
}

