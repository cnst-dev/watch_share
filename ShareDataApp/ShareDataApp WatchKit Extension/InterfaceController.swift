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
    private var text: String? {
        didSet {
            guard let text = text else { return }
            DispatchQueue.main.async { [weak self] in
                self?.dataLabel.setText(text)
            }
        }
    }

    // MARK: - WKInterfaceController
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        guard isSuported else { return }
        activateSession()
    }

    // MARK: - User Info
    /// Sends a UserInfo dictionary to the iOS app.
    @IBAction private func sendButtonPressed() {
        guard isActivated else { return }
        let userInfo = ["text": "User Info from the watch"]
        defaultSession.transferUserInfo(userInfo)
    }

    /// Receives a UserInfo dictionary from the iOS app and sets the text property.
    ///
    /// - Parameters:
    ///   - session: The session object of the current process.
    ///   - userInfo: A dictionary of property list values representing the contents of the message.
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        text = userInfo["text"] as? String
    }

    // MARK: - Message
    /// Receives a Message dictionary from the iOS app and sets the text property.
    ///
    /// - Parameters:
    ///   - session: The session object of the current process.
    ///   - message: A dictionary of property list values representing the contents of the message.
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        text = message["text"] as? String
    }

    /// Receives a Message dictionary from the iOS app and sets the text property. Provides an appropriate reply to the iOS app.
    ///
    /// - Parameters:
    ///   - session: The session object of the current process.
    ///   - message: A dictionary of property list values representing the contents of the message.
    ///   - replyHandler: A reply block to execute with the response.
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        text = message["text"] as? String
        let response = ["response": "Response from the watch"]
        replyHandler(response)
    }

    // MARK: - Context
    /// Receives a Context dictionary from the iOS apps and sets the text property.
    ///
    /// - Parameters:
    ///   - session: The session object of the current process.
    ///   - applicationContext: The context data from the iOS app.
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
