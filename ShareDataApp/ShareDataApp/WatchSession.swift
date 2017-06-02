//
//  WatchSession.swift
//  ShareDataApp
//
//  Created by Konstantin Khokhlov on 02.06.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import Foundation
import WatchConnectivity

protocol WatchSession {}

extension WatchSession {

    var defaultSession: WCSession {
        return WCSession.default()
    }
}
