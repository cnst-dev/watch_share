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

    var defaultSession: WCSession {
        return WCSession.default()
    }

    var isSuported: Bool {
        return WCSession.isSupported()
    }

    var isActivated: Bool {
        return defaultSession.activationState == .activated
    }

    var isReachable: Bool {
        return defaultSession.isReachable
    }

    func activateSession() {
        defaultSession.delegate = self
        defaultSession.activate()
    }
}
