//
//  LogHandler.swift
//  Cork Weather
//
//  Created by Eddie Long on 07/09/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

public protocol LogHandler {
    func logMessage(log : LogLine, tag : String, level : LogLevel)
}
