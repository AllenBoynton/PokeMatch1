//
//  MainMenuViewController.swift
//  PokeMatch
//
//  Created by Allen Boynton on 5/24/17.
//  Copyright © 2017 Allen Boynton. All rights reserved.
//

import UIKit
import GameKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

// Global GC identifiers
let timeLeaderboardID = "com.abtechapps.PokeMatch" // Time Leaderboard
var muteButton: UIButton?

class MainMenuViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    // Class delegates
    var gameController = PokeMemoryGame()
    var music = Music()
    
    @IBOutlet weak var muteButton: UIButton!
    
    var facebookImage: UIImageView!
    var facebookName: UILabel!
    
    let localPlayer = GKLocalPlayer.localPlayer()
    
    lazy var gcEnabled = Bool() // Check if the user has Game Center enabled
    lazy var gcDefaultLeaderBoard = String() // Check the default
    let GKPlayerAuthenticationDidChangeNotificationName: String = ""
    
    let score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookLoginButton()
        facebookLikeButton()
        handleFacebookImage()
        handleFacebookName()
        fetchProfile()
        
        authenticatePlayer()        
    }
    
    // Authenticates the user to access to the GC
    func authenticatePlayer() {
        localPlayer.authenticateHandler = {(view, error) -> Void in
            if view != nil {
                
                // 1. Show login if player is not logged in
                self.present(view!, animated: true, completion: nil)
                
                NotificationCenter.default.addObserver(
                    self, selector: #selector(self.authenticationDidChange(_:)),
                    name: NSNotification.Name(rawValue: self.GKPlayerAuthenticationDidChangeNotificationName),
                    object: nil)
                
            } else if self.localPlayer.isAuthenticated {
                
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                self.localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifier, error) in
                    if error != nil {
                        print(error as Any)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifier!
                    }
                })
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error as Any)
            }
        }
    }

    // Report example score after user logs in
    @objc func authenticationDidChange(_ notification: Notification) {}
    
    // Authentication notification
    func notificationReceived() {
        print("GKPlayerAuthenticationDidChangeNotificationName - Authentication Status: \(localPlayer.isAuthenticated)")
    }
    
    // Reporting game time
    func saveHighScore(_ score: Int64) {
        // if player is logged in to GC, then report the score
        if GKLocalPlayer.localPlayer().isAuthenticated {
            
            // Save game time to GC
            let scoreReporter = GKScore(leaderboardIdentifier: timeLeaderboardID)
            scoreReporter.value = Int64(score)
            
            let gkScoreArray: [GKScore] = [scoreReporter]
            
            GKScore.report(gkScoreArray, withCompletionHandler: { error in
                guard error == nil  else { return }
            })
        }
    }
    
    // Music button to turn music on/off
    @IBAction func muteButtonTapped(_ sender: UIButton) {
        music.handleMuteMusic()
    }

    @IBAction func bestTimesButtonTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HighScoreViewController")
        self.show(vc!, sender: self)
    }
    
    // Fetch facebook profile
    func fetchProfile() {
        if FBSDKAccessToken.current() != nil {
            //print permissions, such as public_profile
            print(FBSDKAccessToken.current().permissions)
            
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email"])
            let connection = FBSDKGraphRequestConnection()
            
            connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
                
                let data = result as! [String : AnyObject]
                
                self.facebookName.text = data["name"] as? String
                
                let FBid = data["id"] as? String
                
                let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
                self.facebookImage.image = UIImage(data: NSData(contentsOf: url! as URL)! as Data)
                
                let email = data["email"] as? String
                
                if email != nil {
                    print("Email: \(String(describing: email))")
                } else {
                    print("Email: Not available")
                }
            })
            connection.start()
        }
        print("Fetched profile")
    }
    
    // Facebook image
    func handleFacebookImage() {
        facebookImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        facebookImage.center = CGPoint(x: view.center.x, y: view.center.y - 100)
        
        facebookImage.image = UIImage(named: "fb_logo")
        facebookImage.materialDesign = true
        
        view.addSubview(facebookImage)
    }
    
    // Facebook name label
    func handleFacebookName() {
        facebookName = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        facebookName.center = CGPoint(x: view.center.x, y: view.center.y - 65)
        
        facebookName.text = "Not Logged In"
        facebookName.textAlignment = .center
        facebookName.font = UIFont.init(name: "MarkerFelt-Thin", size: 13)
        facebookName.textAlignment = NSTextAlignment.center
        
        view.addSubview(facebookName)
    }
    
    // Facebook login button
    func facebookLoginButton() {
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["email"]
        
        loginButton.center = CGPoint(x: view.center.x, y: view.center.y - 30)
        loginButton.delegate = self
        
        view.addSubview(loginButton)
    }
    
    // Facebook Like button
    func facebookLikeButton() {
        let likeButton = FBSDKLikeControl()
        
        likeButton.frame.origin.x = likeButton.frame.width * 0.3
        likeButton.frame.origin.y = (self.view.frame.height - 8) - likeButton.frame.height * 1.5

        likeButton.objectID = "https://www.facebook.com/PokeMatchMobileApp/"
        
        view.addSubview(likeButton)
    }
    
    // Facebook login delegate
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        fetchProfile()
        print("Facebook login complete")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        facebookImage.image = UIImage(named: "fb_logo")
        facebookName.text = "Not Logged In"
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
}
