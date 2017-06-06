//
//  InterfaceController.swift
//  ShareDataApp WatchKit Extension
//
//  Created by Konstantin Khokhlov on 01.06.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation

class InterfaceController: WKInterfaceController, FileManagerSupport, WatchSession {

    // MARK: - Outlets
    @IBOutlet private var dataLabel: WKInterfaceLabel!

    // MARK: - Properties
    var text: String? {
        didSet {
            guard let text = text else { return }
            setTextAsync(text)
        }
    }

    // MARK: - WKInterfaceController
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        guard isSuported else { return }
        activateSession()
    }

    // MARK: - Text
    func setTextAsync(_ text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.dataLabel.setText(text)
        }
    }

    // MARK: - User Info
    @IBAction private func sendButtonPressed() {
        guard isActivated else { return }
        let userInfo = ["text": "User Info from the watch"]
        defaultSession.transferUserInfo(userInfo)
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        text = userInfo["text"] as? String
    }

    // MARK: - Message
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        text = message["text"] as? String
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        text = message["text"] as? String
        let response = ["response": "Response from the watch"]
        replyHandler(response)
    }

    // MARK: - Context
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        text = applicationContext["text"] as? String
    }

    // MARK: - File
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        do {
            text = try String(contentsOf: file.fileURL)
        } catch let error as NSError {
            print("ERROR: \(error)")
        }
    }

    // MARK: - WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            print("Communication is activated")
        }
    }
}
