//
//  MainMenuViewControllerTests.swift
//  PokéMatch
//
//  Created by Allen Boynton on 9/12/17.
//  Copyright © 2017 Allen Boynton. All rights reserved.
//

import XCTest
@testable import PokéMatch

class MainMenuViewControllerTests: XCTestCase {
    
    var vc = MainMenuViewController!
    
    override func setUp() {
        super.setUp()
        
        vc = mockController()
    }
    
    override func tearDown() {
        super.tearDown()
        
        vc = nil
    }
    
    func testSaveHighScore() {
        XCTAssert
    }
    
    func mockControllers() -> MainMenuViewController? {
        let story = UIStoryboard(name: "MainMenuViewController", bundle: nil)
        vc = story.instantiateViewController(withIdentifier: "MainMenuViewController") as? MainMenuViewController
        _ = vc.view
        return vc
    }
}
