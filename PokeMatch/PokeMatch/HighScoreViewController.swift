//
//  HighScoreViewController.swift
//  PokéMatch
//
//  Created by Allen Boynton on 8/1/17.
//  Copyright © 2017 Allen Boynton. All rights reserved.
//

import UIKit
import GameKit
import GoogleMobileAds

class HighScoreViewController: UIViewController, GKGameCenterControllerDelegate, GADBannerViewDelegate, GADInterstitialDelegate {
    
    private var music = Music()
    private var pokeMatchViewController: PokeMatchViewController!
    
    @IBOutlet weak var gameTimeImage: UIImageView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLbl: UILabel!
    
    @IBOutlet weak var youWonLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var gcIconView: UIView!
    
    private var adBannerView: GADBannerView!
    
    private var score = Int()
    private var highScore = Int()
    
    private var minutes = Int()
    private var seconds = Int()
    private var millis = Int()
    
    // Time passed from PokeMatchVC
    var timePassed: String?
    
    private var mute = true
    
    private var interstitial: GADInterstitial!
    
    override func viewWillAppear(_ animated: Bool) {
        animateGCIcon()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.interstitial = createAndLoadInterstitial()
                
        handleAdRequest()
        
        showItems()
        
        checkHighScoreForNil()
        addScore()
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
            youWonLabel.isHidden = true
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
    
    /*************************** AdMob Requests ***********************/
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
            // In iOS 11, we need to constrain the view to the safe area.
            positionBannerViewFullWidthAtBottomOfSafeArea(bannerView)
        }
        else {
            // In lower iOS versions, safe area is not available so we use
            // bottom layout guide and view edges.
            positionBannerViewFullWidthAtBottomOfView(bannerView)
        }
    }
    
    // MARK: - view positioning
    @available (iOS 11, *)
    func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
        // Position the banner. Stick it to the bottom of the Safe Area.
        // Make it constrained to the edges of the safe area.
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
            guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
            guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
            ])
    }
    
    func positionBannerViewFullWidthAtBottomOfView(_ bannerView: UIView) {
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: view.safeAreaLayoutGuide.bottomAnchor,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 0))
    }
    
    // Ad request
    func handleAdRequest() {
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        
        adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        addBannerViewToView(adBannerView)
        
        // Ad setup
        adBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"//"ca-app-pub-2292175261120907/3388241322"
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
        UIView.animate(withDuration: 1.5, animations: {
            self.gcIconView.transform = CGAffineTransform(scaleX: 30, y: 30)
            self.gcIconView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }) { (finished) in
            UIView.animate(withDuration: 0.8, animations: {
                self.gcIconView.transform = CGAffineTransform.identity
            })
        }
    }
    
    /**************************** IBActions ************************/
    
    @IBAction func showGameCenter(_ sender: UIButton) {
        showLeaderboard()
    }
    
    // Play again game button to main menu
    @IBAction func playAgainButtonPressed(_ sender: Any) {
        // Interstitial Ad setup
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
            print("Ad page attempted")
            
//            music.handleMuteMusic()
        } else {
            print("Ad wasn't ready")
        }

        if timePassed != nil {
            saveHighScore(convertStringToNumbers(time: timePassed!)!)
        } else {
            print("Time is nil")
        }
                
        // Return to game screen
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PokeMatchViewController")
        show(vc!, sender: self)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

