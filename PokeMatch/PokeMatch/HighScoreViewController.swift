//
//  HighScoreViewController.swift
//  PokéMatch
//
//  Created by Allen Boynton on 8/1/17.
//  Copyright © 2017 Allen Boynton. All rights reserved.
//

import UIKit
import GameKit
import FBSDKShareKit
import GoogleMobileAds

class HighScoreViewController: UIViewController, GKGameCenterControllerDelegate, GADBannerViewDelegate, GADInterstitialDelegate {
    
    var music = Music()
    var pokeMatchViewController = PokeMatchViewController()
    
    @IBOutlet weak var gameTimeImage: UIImageView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLbl: UILabel!
    
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var gcIconView: UIView!
    
    @IBOutlet weak var adBannerView: GADBannerView!
    
    lazy var score = Int()
    lazy var highScore = Int()
    
    lazy var minutes = Int()
    lazy var seconds = Int()
    lazy var millis = Int()
    
    // Time passed from PokeMatchVC
    var timePassed: String?
    
    lazy var mute = true
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interstitial = createAndLoadInterstitial()
        
        handleAdRequest()
        animateGCIcon()
        showItems()
        
        checkHighScoreForNil()
        addScore()
        
        facebookShareButton()
    }
    
    // Shows items depending on best score screen or final score screen
    func showItems() {
        gameTimeImage.isHidden = false
        playAgainButton.isHidden = false
        menuButton.isHidden = false
    }
    
    /*************************** High Score Logic *********************/
    
    // Verifies score/time is not nil
    func checkHighScoreForNil() {
        let highScoreDefault = UserDefaults.standard
        
        if highScoreDefault.value(forKey: "HighScore") != nil {
            highScore = score
            highScore = highScoreDefault.value(forKey: "HighScore") as! NSInteger
            highScoreLbl.text = "\(intToScoreString(score: highScore))"
        }
    }
    
    // Score format for time
    func intToScoreString(score: Int) -> String {
        minutes = score / 10000
        seconds = (score / 100) % 100
        millis = score % 100
        
        let scoreString = NSString(format: "%02i:%02i.%02i", minutes, seconds, millis) as String
        return scoreString
    }
    
    // Adds time from game to high scores. Compares again others for order
    func addScore() {
        if timePassed != nil {
            menuButton.isHidden = true
            score = Int(convertStringToNumbers(time: timePassed!)!)
            scoreLabel.text = "\(intToScoreString(score: score))"
            print("Score Displayed")
            
            if (score > highScore) {
                highScore = score
                highScoreLbl.text = "\(intToScoreString(score: Int(highScore)))"
                
                handleHighScore()
                print("Best Time Displayed")
            }
        } else {
            gameTimeImage.isHidden = true
            scoreLabel.isHidden = true
            playAgainButton.isHidden = true
            print("timePassed = nil")
        }
    }
    
    // Handles the saving of high score as cumulative or reset to 0
    func handleHighScore() {
        let highScoreDefault = UserDefaults.standard
        highScoreDefault.set(highScore, forKey: "HighScore")
        highScoreDefault.synchronize()
    }
    
    // Seperate string out to numbers
    func convertStringToNumbers(time: String) -> Int? {
        let strToInt = time.westernArabicNumeralsOnly
        return Int(strToInt)!
    }
    
    /**************************** Game Center ***********************/
    
    // Reporting game time
    func saveHighScore(_ score: Int) {
        // if player is logged in to GC, then report the score
        if GKLocalPlayer.localPlayer().isAuthenticated {
            
            // Save game time to GC
            let scoreReporter = GKScore(leaderboardIdentifier: timeLeaderboardID)
            scoreReporter.value = Int64(score)
            
            let gkScoreArray: [GKScore] = [scoreReporter]
            
            GKScore.report(gkScoreArray, withCompletionHandler: { error in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                } else {
                    print("Best Time submitted to the Leaderboard!")
                }
            })
        }
    }
    
    // Retrieves the GC VC leaderboard
    func showLeaderboard() {
        let gameCenterViewController = GKGameCenterViewController()
        
        gameCenterViewController.gameCenterDelegate = self
        gameCenterViewController.viewState = .leaderboards
        gameCenterViewController.leaderboardIdentifier = timeLeaderboardID
        
        // Show leaderboard
        self.present(gameCenterViewController, animated: true, completion: nil)
    }
    
    // Adds the Done button to the GC view controller
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    /************************** Facebook Share ************************/
    
    // Facebook Share button
    func facebookShareButton() {
        let content = FBSDKShareLinkContent()
        
        content.contentURL = URL(string: "https://www.facebook.com/PokeMatchMobileApp/")
        content.hashtag = FBSDKHashtag(string: "#AlsMobileApps")
        
        FBSDKShareDialog.show(from: self, with: content, delegate: nil)
        FBSDKMessageDialog.show(with: content, delegate: nil)
        
        let shareButton = FBSDKShareButton()
        shareButton.shareContent = content
        
        shareButton.center = CGPoint(x: view.center.x, y: (self.view.frame.height - 40) - shareButton.frame.height * 3.0)
        
        view.addSubview(shareButton)
    }
    
    /*************************** AdMob Requests ***********************/
    
    // Ad request
    func handleAdRequest() {
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        
        // Ad setup
        adBannerView.adUnitID = "ca-app-pub-2292175261120907/3388241322"
        adBannerView.rootViewController = self
        adBannerView.delegate = self
        
        adBannerView.load(request)
    }
    
    // Create and load an Interstitial Ad
    func createAndLoadInterstitial() -> GADInterstitial {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID, "2077ef9a63d2b398840261c8221a0c9b" ]
        interstitial.load(request)
        
        return interstitial
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        
        music.handleMuteMusic()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /*************************** GC Animation **********************/
    
    // Animate GC image
    func animateGCIcon() {
        UIView.animate(withDuration: 3, animations: {
            self.gcIconView.transform = CGAffineTransform(scaleX: 50, y: 50)
            self.gcIconView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }) { (finished) in
            UIView.animate(withDuration: 1, animations: {
                self.gcIconView.transform = CGAffineTransform.identity
            })
        }
    }
    
    /**************************** IBActions ************************/
    
    @IBAction func showGameCenter(_ sender: UIButton) {
        showLeaderboard()
    }
    
    // Play again game button to main menu
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
        // Interstitial Ad setup
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
            print("Ad page attempted")
            
            music.handleMuteMusic()
        } else {
            print("Ad wasn't ready")
        }

        if timePassed != nil {
            saveHighScore(convertStringToNumbers(time: timePassed!)!)
            print("GC Time: \(convertStringToNumbers(time: timePassed!)!)")
        } else {
            print("Time is nil")
        }
                
        // Return to game screen
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PokeMatchViewController")
        print("Present PokeMatchVC and reset game screen")
        show(vc!, sender: self)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

