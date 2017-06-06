//
//  MainViewController.swift
//  ShareDataApp
//
//  Created by Konstantin Khokhlov on 01.06.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import UIKit
import WatchConnectivity

class MainViewController: UIViewController, WatchSession, FileManagerSupport {

    // MARK: - Outlets
    @IBOutlet private weak var dataLabel: UILabel!

    // MARK: - Properties
    private var text: String? {
        didSet {
            guard let text = text else { return }
            DispatchQueue.main.async { [weak self] in
                self?.dataLabel.text = text
            }
        }
    }

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        guard isSuported else { return }
        activateSession()
    }

    // MARK: - User Info
    /// Sends a UserInfo dictionary to the Watch app.
    ///
    /// - Parameter sender: - The button from the Main.storyboard.
    @IBAction private func userInfoButtonPressed(_ sender: UIButton) {
        guard isActivated else { return }
        let userInfo = ["text": "User Info from the iPhone"]
        defaultSession.transferUserInfo(userInfo)
    }

    /// Receives a UserInfo dictionary from the Watch app and sets the text property.
    ///
    /// - Parameters:
    ///   - session: The session object of the current process.
    ///   - userInfo: A dictionary of property list values representing the contents of the message.
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        text = userInfo["text"] as? String
    }

    // MARK: - Message
    /// Sends a message dictionary immediately to the Watch app.
    ///
    /// - Parameter sender: - The button from the Main.storyboard.
    @IBAction private func messageButtonPressed(_ sender: UIButton) {
        guard isActivated else { return }
        guard isReachable else { return }
        let message = ["text": "Message from the iPhone"]
        defaultSession.sendMessage(message, replyHandler: nil)
    }

    /// Sends a message dicitionary immediately to the Watch app and handles a response. 
    /// Receives a reply from the Watch app and sets the text property.
    ///
    /// - Parameter sender: - The button from the Main.storyboard.
    @IBAction private func responseButtonPressed(_ sender: UIButton) {
        guard isActivated else { return }
        guard isReachable else { return }
        let message = ["text": "Message with the response from the iPhone"]
        defaultSession.sendMessage(message, replyHandler: { [weak self] (response) in
            self?.text = response["response"] as? String
        })
    }

    // MARK: - Context
    /// Sends a context dictionary to the Watch app.
    ///
    /// - Parameter sender: - The button from the Main.storyboard.
    @IBAction private func appContextButtonPressed(_ sender: Any) {
        guard isActivated else { return }
        let context = ["text": "Updated context from the iPhone"]
        do {
            try defaultSession.updateApplicationContext(context)
        } catch {
            print("Updating app context is failed!")
        }
    }

    // MARK: - File
    /// Sends a file that is local to the iOS app to the Watch app.
    ///
    /// - Parameter sender: - The button from the Main.storyboard.
    @IBAction private func fileButtonPressed(_ sender: UIButton) {
        guard isActivated else { return }
        let sourceURL = documentDirectory.appendingPathComponent("save")
        guard !defaultFileManager.fileExists(atPath: sourceURL.path) else { return }
        do {
            let text = "Saved text from the iPhone"
            try text.write(to: sourceURL, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("ERROR: \(error)")
        }
        defaultSession.transferFile(sourceURL, metadata: nil)
    }

    // MARK: - WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            print("Communication is activated")
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Communication is inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Initiate session with the new watch
        defaultSession.activate()
    }

}
