//
//  FileManager.swift
//  ShareDataApp
//
//  Created by Konstantin Khokhlov on 02.06.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import Foundation

protocol FileManagerSupport {}

extension FileManagerSupport {

    var defaultFileManager: FileManager {
        return FileManager.default
    }

    var documentDirectory: URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
}
