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

class InterfaceController: WKInterfaceController, WCSessionDelegate, FileManagerSupport, WatchSession {

    // MARK: - Outlets
    @IBOutlet private var dataLabel: WKInterfaceLabel!

    // MARK: - WKInterfaceController
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        guard WCSession.isSupported() else { return }
        defaultSession.delegate = self
        defaultSession.activate()
    }

    // MARK: - User Info
    @IBAction private func sendButtonPressed() {
        guard defaultSession.activationState == .activated else { return }
        let userInfo = ["text": "User Info from the watch"]
        defaultSession.transferUserInfo(userInfo)
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async { [weak self] in
            guard let text = userInfo["text"] as? String else { return }
            self?.dataLabel.setText(text)
        }
    }

    // MARK: - Message
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async { [weak self] in
            guard let text = message["text"] as? String else { return }
            self?.dataLabel.setText(text)
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let text = message["text"] as? String else { return }
            self?.dataLabel.setText(text)
        }
        let response = ["response": "Response from the watch"]
        replyHandler(response)
    }

    // MARK: - Context
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async { [weak self] in
            guard let text = applicationContext["text"] as? String else { return }
            self?.dataLabel.setText(text)
        }
    }

    // MARK: - File
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        do {
            let text = try String(contentsOf: file.fileURL)
            DispatchQueue.main.async { [weak self] in
                self?.dataLabel.setText(text)
            }
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
