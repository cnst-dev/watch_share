//
//  MainViewController.swift
//  ShareDataApp
//
//  Created by Konstantin Khokhlov on 01.06.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import UIKit
import WatchConnectivity

class MainViewController: UIViewController, WCSessionDelegate, WatchSession, FileManagerSupport {

    // MARK: - Outlets
    @IBOutlet private weak var dataLabel: UILabel!

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        guard WCSession.isSupported() else { return }
        defaultSession.delegate = self
        defaultSession.activate()
    }

    // MARK: - User Info
    @IBAction private func userInfoButtonPressed(_ sender: UIButton) {
        guard defaultSession.activationState == .activated else { return }
        let userInfo = ["text": "User Info from the iPhone"]
        defaultSession.transferUserInfo(userInfo)
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async { [weak self] in
            guard let text = userInfo["text"] as? String else { return }
            self?.dataLabel.text = text
        }
    }

    // MARK: - Message
    @IBAction private func messageButtonPressed(_ sender: UIButton) {
        guard defaultSession.activationState == .activated else { return }
        guard defaultSession.isReachable else { return }
        let message = ["text": "Message from the iPhone"]
        defaultSession.sendMessage(message, replyHandler: nil)
    }

    @IBAction private func responseButtonPressed(_ sender: UIButton) {
        guard defaultSession.activationState == .activated else { return }
        guard defaultSession.isReachable else { return }
        let message = ["text": "Message with the response from the iPhone"]
        defaultSession.sendMessage(message, replyHandler: { response in
            DispatchQueue.main.async { [weak self] in
                guard let text = response["response"] as? String else { return }
                self?.dataLabel.text = text
            }

        })
    }

    // MARK: - Context
    @IBAction private func appContextButtonPressed(_ sender: Any) {
        guard defaultSession.activationState == .activated else { return }
        let context = ["text": "Updated context from the iPhone"]
        do {
            try defaultSession.updateApplicationContext(context)
        } catch {
            print("Updating app context is failed!")
        }
    }

    // MARK: - File
    @IBAction private func fileButtonPressed(_ sender: UIButton) {
        guard defaultSession.activationState == .activated else { return }
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
