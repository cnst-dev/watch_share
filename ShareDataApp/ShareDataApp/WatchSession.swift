//
//  WatchSession.swift
//  ShareDataApp
//
//  Created by Konstantin Khokhlov on 02.06.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import UIKit
import WatchConnectivity

protocol WatchSession: WCSessionDelegate {}

extension WatchSession {

    /// Returns the default session object for current device
    var defaultSession: WCSession {
        return WCSession.default()
    }

    /// Indicates is the current iOS device able to use a session object.
    var isSuported: Bool {
        return WCSession.isSupported()
    }

    /// Indicates is the session active and the Watch app and iOS app may communicate with each other freely.
    var isActivated: Bool {
        return defaultSession.activationState == .activated
    }

    /// Indicates is the app available for live messaging.
    var isReachable: Bool {
        return defaultSession.isReachable
    }

    /// Sets the delegate for the default session and activates the session asynchronously.
    func activateSession() {
        defaultSession.delegate = self
        defaultSession.activate()
    }
}
