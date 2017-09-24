//
//  PokeMatchViewController.swift
//  PokeMatch
//
//  Created by Allen Boynton on 5/22/17.
//  Copyright © 2017 Allen Boynton. All rights reserved.
//  Image Source: © Pokémon
//

import UIKit
import DeviceKit
import GoogleMobileAds

// Global Identifier
let cellID = "PokeCell"

class PokeMatchViewController: UIViewController, GADBannerViewDelegate {
    
    var gameController = PokeMemoryGame()
    var notifications = Notifications()
    var music = Music()
    
    // Collection view to hold all images
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Outlet for game display
    @IBOutlet weak var timerDisplay: UILabel!
    
    // Outlets for views
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var playButton: UIButton!
    
    // AdMob banner ad
    @IBOutlet weak var adBannerView: GADBannerView!
    
    // Constraint outlets for animation
    @IBOutlet weak var topViewTopConstraint: NSLayoutConstraint!
    
    // MARK - Local variables
    
    // Uses DeviceKit to determine device family
    let device = Device()
    
    // Time passed to FinalScoreVC
    lazy var gameTimePassed = UILabel()
    
    // Deducts images until we reach 0 and the user wins
    lazy var gameOver = Bool()
    
    // NSTimers for game time and delays in revealed images
    var timer: Timer?
    var timer1 = Timer(), timer2 = Timer(), timer3 = Timer()
    
    // Time values instantiated
    lazy var startTime: Double = 0
    lazy var time: Double = 0
    lazy var elapsed: Double = 0
    lazy var display: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        print("Reset game screen")
        resetGame()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        handleAdRequest()
        
        gameController.delegate = self
    }
    
    // AdMob banner ad
    func handleAdRequest() {
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        
        adBannerView.adUnitID = "ca-app-pub-2292175261120907/6252355617"
        adBannerView.rootViewController = self
        adBannerView.delegate = self
        
        if (adBannerView.rootViewController?.isBeingDismissed)! {
            music.handleMuteMusic()
        }
        
        adBannerView.load(request)
    }

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error.debugDescription)
    }
    
    // Updates game time on displays
    @objc func startGameTimer() -> String {
        // Calculate total time since timer started in seconds
        time = gameController.elapsedTime
        
        // Calculate minutes
        let minutes = UInt32(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        // Calculate seconds
        let seconds = UInt32(time)
        time -= TimeInterval(seconds)
        
        // Calculate milliseconds
        let milliseconds = UInt32(time * 100)
        
        // Format time vars with leading zero
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strMilliseconds = String(format: "%02d", milliseconds)
        
        // Add time vars to relevant labels
        display = String(format: "\(strMinutes):\(strSeconds).\(strMilliseconds)", NSLocalizedString("", comment: ""), gameController.elapsedTime)
        
        // Display game time counter
        timerDisplay.text = display
        
        return display
    }
    
    // Sets up for new game
    func setupNewGame() {
        if device.isPhone {
            let cardsData: [UIImage] = PokeMemoryGame.topCardImages
            gameController.newGame(cardsData)
        } 
    }
    
    // Created to reset game. Resets points, time and start button.
    func resetGame() {
        gameController.stopGame()
        if timer?.isValid == true {
            timer?.invalidate()
        }
        
        topViewTopConstraint.constant = 0
        bottomView.alpha = 0
        
        collectionView.isHidden = true
        collectionView.isUserInteractionEnabled = true
        collectionView.reloadData()
        
        playButton.isHidden = false
        playButton.isEnabled = true
    }
}

extension PokeMatchViewController: MemoryGameDelegate {
    // MARK: - MemoryGameDelegate
    
    func memoryGameDidStart(_ game: PokeMemoryGame) {
        collectionView.reloadData()
        collectionView.isUserInteractionEnabled = true
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(startGameTimer), userInfo: nil, repeats: true)
    }
    
    // Function for cards that are being shown
    func memoryGame(_ game: PokeMemoryGame, showCards cards: [Card]) {
        for card in cards {
            guard let index = gameController.indexForCard(card) else { continue }
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! PokeVCell
            cell.showCard(true, animated: true)
        }
    }
    
    // Function for cards that are being hidden
    func memoryGame(_ game: PokeMemoryGame, hideCards cards: [Card]) {
        for card in cards {
            guard let index = gameController.indexForCard(card) else { continue }
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! PokeVCell
            cell.showCard(false, animated: true)
        }
    }
    
    // End of game methods
    func memoryGameDidEnd(_ game: PokeMemoryGame, elapsedTime: TimeInterval) {
        timer?.invalidate()
        
        let when = DispatchTime.now() + 1.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "HighScoreViewController") as! HighScoreViewController
            myVC.timePassed = self.display
            self.present(myVC, animated: true)
        }
    }
    
    // Animate views for ad placement
    func animateViewsForPlay() {
        print("\(device)")
        topViewTopConstraint.constant = -80
        
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.alpha = 1.0
            self.view.layoutIfNeeded()
        })
    }
}

extension PokeMatchViewController: UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource
    
    // Determines which device the user has - determines # of cards
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameController.numberOfCards > 0 ? gameController.numberOfCards: 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PokeVCell
        cell.showCard(false, animated: false)
        
        guard let card = gameController.cardAtIndex(indexPath.item) else { return cell }
        cell.card = card
        
        return cell
    }
}

extension PokeMatchViewController: UICollectionViewDelegate {
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PokeVCell
        
        if cell.shown { return }
        gameController.didSelectCard(cell.card)
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension PokeMatchViewController: UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat!
        let itemHeight: CGFloat!
        
        itemWidth = collectionView.frame.width / 4.0 - 10.0 // 4 wide
        itemHeight = collectionView.frame.height / 5.0 - 12.0
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    // MARK - IBAction functions
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        // Begin with new setup
        setupNewGame()
        
        // Animate views
        animateViewsForPlay()
        
        // Shows button at beginning of game
        playButton.isHidden = true
        playButton.isEnabled = false
        
        // Unhides views after start button is pressed
        collectionView.isHidden = false
        bottomView.isHidden = false
    }
    
    // Back button to bring to main menu
    @IBAction func backButtonTapped(_ sender: Any) {
        notifications.showNotification(inSeconds: 3, completion: { success in
            if success {
                print("Successfully scheduled notification")
            } else {
                print("Error scheduling notification")
            }
        })
        
        timer?.invalidate()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuViewController")
        self.show(vc!, sender: self)
    }
}
