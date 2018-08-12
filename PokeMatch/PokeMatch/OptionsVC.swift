//
//  OptionsVC.swift
//  PokeMatch
//
//  Created by Allen Boynton on 5/26/17.
//  Copyright © 2017 Allen Boynton. All rights reserved.
//

import UIKit
import AVFoundation
import GameKit
import StoreKit
import GoogleMobileAds

enum Difficulty {
    case Easy, Medium, Hard
}

class OptionsVC: UIViewController, GKGameCenterControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, GADBannerViewDelegate {
    
    // Class delegates
    let music = Music()
    let musicPlayer = AVAudioPlayer()
    
    @IBOutlet var imagePicker: UIPickerView!
    @IBOutlet weak var musicOnView: DesignableViews!
    @IBOutlet weak var musicOffView: DesignableViews!
//    @IBOutlet weak var bannerView: GADBannerView!
    var bannerView: GADBannerView!
    
    var imageGroupArray: [[UIImage]] = [Array]()
    var sizeArray: [String] = ["Generation 1", "Generation 2", "Most Popular"]
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageGroupArray = [PokeMemoryGame.topCardImages]
        
        self.imagePicker.dataSource = self
        self.imagePicker.delegate = self
        
        handleMusicButtons()
        handleAdRequest()
    }
    
    // MARK:  UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return sizeArray.count
        }
        return sizeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    // MARK:  UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sizeArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let myView = UIView(frame: CGRect(x:0, y:0, width:pickerView.bounds.width - 30, height:60))
        
        let myImageView = UIImageView(frame: CGRect(x:60, y:5, width:50, height:50))
        let myLabel = UILabel(frame: CGRect(x:pickerView.bounds.maxX - 190, y:0, width:pickerView.bounds.width - 90, height:60 ))
        let lockImage = UIImageView(frame: CGRect(x:75, y: 15, width: 25, height: 25))
        var rowString = String()
        
        switch row {
        case 0:
            rowString = sizeArray[0]
            myImageView.image = UIImage(named:"_25.jpg")
        case 1:
            rowString = sizeArray[1]
            myImageView.image = UIImage(named:"_6.jpg")
            lockImage.image = UIImage(named: "lock.png")
        case 2: break
        default:
            rowString = "Error: too many rows"
            myImageView.image = nil
        }
        
        myLabel.text = rowString
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        myView.addSubview(lockImage)
        
        return myView
    }
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
    
    // AdMob banner ad
    func handleAdRequest() {
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"//"ca-app-pub-2292175261120907/4964310398"
        bannerView.rootViewController = self
        bannerView.delegate = self
        
        bannerView.load(request)
    }
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    
    // Create function to initiate music playing when game begins
    func startGameMusic() {
        let url = URL.init(fileURLWithPath: Bundle.main.path(forResource: "music", ofType: "mp3")!)
        
        do {
            bgMusic = try AVAudioPlayer(contentsOf: url)
            bgMusic?.prepareToPlay()
            bgMusic?.play()
        } catch let error as NSError {
            print("audioPlayer error \(error.localizedDescription)")
        }
    }
    
    func handleMusicButtons() {
        if (bgMusic?.isPlaying)! {
            musicOnView.layer.borderWidth = 2
            musicOffView.layer.borderWidth = 0
        } else {
            musicOnView.layer.borderWidth = 0
            musicOffView.layer.borderWidth = 2
        }
    }
    
    @IBAction func easyButtonTapped(_ sender: Any) {
        newGameDifficulty(difficulty: .Easy)
    }
    
    @IBAction func mediumButtonTapped(_ sender: Any) {
        newGameDifficulty(difficulty: .Medium)
    }
    
    @IBAction func hardButtonTapped(_ sender: Any) {
        newGameDifficulty(difficulty: .Hard)
    }
    
    @IBAction func musicButtonOn(_ sender: Any) {
        music.handleMuteMusic()
        musicOnView.layer.borderWidth = 2
        musicOffView.layer.borderWidth = 0
    }
    
    @IBAction func musicButtonOff(_ sender: Any) {
        music.handleMuteMusic()
        musicOnView.layer.borderWidth = 0
        musicOffView.layer.borderWidth = 2
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        // Return to game screen
        if #available( iOS 10.3,*){
            SKStoreReviewController.requestReview()
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PokeMatchViewController")
        show(vc!, sender: self)
    }
    
    @IBAction func gcButtonTapped(_ sender: Any) {
        showLeaderboard()
    }
    
    @IBAction func supportButtonTapped(_ sender: Any) {
        print("Website and Support button tapped!")
        if let url = URL(string: "https://www.facebook.com/PokeMatchMobileApp/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func rateButtonTapped(_ sender: Any) {
        print("Rate App button tapped!")
        let appleID = "1241113119"
        guard let writeReviewURL = URL(string: "https://itunes.apple.com/app/id\(appleID)?action=write-review")
            else { fatalError("Expected a valid URL") }
        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }
    
    @IBAction func backToMain(_ sender: UIButton) {
        // Just for testing, reset the run counter and last bundle version checked
//        UserDefaults.standard.set(0, forKey: UserDefaultsKeys.APP_OPENED_COUNT)
//        UserDefaults.standard.set("", forKey: UserDefaultsKeys.LATEST_VERSION)
//        print("All checks have been reset. Version: \(UserDefaultsKeys.LATEST_VERSION)")
        dismiss(animated: true, completion: nil)
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
}

extension OptionsVC {
    func onEasyTapped(sender: UIButton) {
        newGameDifficulty(difficulty: .Easy)
    }
    
    func onMediumTapped(sender: UIButton) {
        newGameDifficulty(difficulty: .Medium)
    }
    
    func onHardTapped(sender: UIButton) {
        newGameDifficulty(difficulty: .Hard)
    }
    
    func newGameDifficulty(difficulty: Difficulty) {
        switch difficulty {
        case .Easy:
            print("Easy")
        case .Medium:
            print("Medium")
        case .Hard:
            print("Hard")
        }
    }
}
