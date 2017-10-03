//
//  SwiftTests.swift
//  SWLogger
//
//  Created by Eddie Long on 02/10/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//


import XCTest
@testable import SWLogger

class TestLogger : LogHandler {
    public var messageLog : LogLine?
    public var messageTag : String?
    public var messageLevel : LogLevel?
    public var didLog : Bool = false
    
    init() {
        reset()
    }
    
    func logMessage(log : LogLine, tag : String, level : LogLevel) {
        didLog = true
        messageLog = log
        messageTag = tag
        messageLevel = level
    }
    
    public func reset() {
        messageLog = nil
        messageTag = nil
        messageLevel = nil
        didLog = false
    }
}

class TestLoggerWrapper {
    public var handler = TestLogger()
    init() {
        Log.addHandler(handler);
    }
    deinit {
        Log.removeHandler(handler)
    }
}

class TestLogLevelWrapper {
    private let originalLevel : LogLevel
    init(level : LogLevel) {
        originalLevel = Log.getLevel()
        Log.setLevel(level)
    }
    deinit {
        Log.setLevel(originalLevel)
    }
}

class LoggerTests : XCTestCase {
    
    override func setUp() {
        // Turn off the default handler - makes the tests harder to read
        Log.enableDefaultLogHandler = false
    }
    
    func testA1ValidateDefaults() {
        XCTAssertFalse(Log.enableDefaultLogHandler)
#if DEBUG
        XCTAssertTrue(Log.getLevel() == LogLevel.debug)
#else
        XCTAssertTrue(Log.getLevel() == LogLevel.warning)
#endif
    }
    
    func testAHandlerAddRemove() {
        let handler = TestLogger()
        XCTAssertFalse(Log.hasHandler(handler))
        
        Log.addHandler(handler);
        XCTAssertTrue(Log.hasHandler(handler))
        Log.removeHandler(handler)
        XCTAssertFalse(Log.hasHandler(handler))
    }
    
    func testBNoHandlerLog() {
        Log.d("")
        Log.d("Some content")
    }
    
    func testB1TestChangeLogLevel() {
        let originalLevel = Log.getLevel()
        Log.setLevel(LogLevel.verbose)
        XCTAssertEqual(Log.getLevel(), LogLevel.verbose)
        
        Log.setLevel(LogLevel.debug)
        XCTAssertEqual(Log.getLevel(), LogLevel.debug)
        
        Log.setLevel(LogLevel.info)
        XCTAssertEqual(Log.getLevel(), LogLevel.info)
        
        Log.setLevel(LogLevel.warning)
        XCTAssertEqual(Log.getLevel(), LogLevel.warning)
        
        Log.setLevel(LogLevel.error)
        XCTAssertEqual(Log.getLevel(), LogLevel.error)
        
        Log.setLevel(originalLevel)
        XCTAssertEqual(Log.getLevel(), originalLevel)
    }
    
    func testCHandlerLoggingAfterRemove() {
        let handler = TestLogger()
        Log.d("Some content")
        Log.addHandler(handler);
        Log.removeHandler(handler)
        XCTAssertFalse(handler.didLog)
    }
    
    func testDHandlerDebugLogging() {
        let wrapper = TestLoggerWrapper()
        let handler = wrapper.handler
        
        let levelWrapper = TestLogLevelWrapper(level: LogLevel.debug)
        
        let message = "Debug"
        Log.d(message)
        XCTAssertTrue(handler.didLog)
        
        XCTAssertNotNil(handler.messageLog)
        XCTAssertTrue(handler.messageLog?.message == message)
        
        XCTAssertNotNil(handler.messageTag)
        XCTAssertTrue(handler.messageTag?.isEmpty ?? false)
        
        XCTAssertNotNil(handler.messageLevel)
        XCTAssertEqual(handler.messageLevel, LogLevel.debug)
        handler.reset()
    }
    
    func testEHandlerDebugLoggingTag() {
        let levelWrapper = TestLogLevelWrapper(level: LogLevel.debug)
        
        let wrapper = TestLoggerWrapper()
        let handler = wrapper.handler
        
        let message1 = "Debug2"
        let tag1 = "TAG1"
        Log.d(message1, tag1)
        XCTAssertTrue(handler.didLog)
        
        XCTAssertNotNil(handler.messageLog)
        XCTAssertTrue(handler.messageLog?.message == message1)
        
        XCTAssertNotNil(handler.messageTag)
        XCTAssertTrue(handler.messageTag == tag1)
    }
    
    // Test that the message log level is assigned correctly
    func testFTestLogLevels() {
        
        let levelWrapper = TestLogLevelWrapper(level: LogLevel.verbose)
        
        let wrapper = TestLoggerWrapper()
        let handler = wrapper.handler
        
        let message1 = "Debug2"
        let tag1 = "TAG1"
        
        Log.v(message1, tag1)
        XCTAssertNotNil(handler.messageLevel)
        XCTAssertEqual(handler.messageLevel, LogLevel.verbose)
        handler.reset()
        
        Log.d(message1, tag1)
        XCTAssertTrue(handler.didLog)
        
        XCTAssertNotNil(handler.messageLevel)
        XCTAssertEqual(handler.messageLevel, LogLevel.debug)
        handler.reset()
        
        Log.i(message1, tag1)
        XCTAssertNotNil(handler.messageLevel)
        XCTAssertEqual(handler.messageLevel, LogLevel.info)
        handler.reset()
        
        Log.w(message1, tag1)
        XCTAssertNotNil(handler.messageLevel)
        XCTAssertEqual(handler.messageLevel, LogLevel.warning)
        handler.reset()
        
        Log.e(message1, tag1)
        XCTAssertNotNil(handler.messageLevel)
        XCTAssertEqual(handler.messageLevel, LogLevel.error)
        handler.reset()
    }
    
    func testFHandlerTestVerbosity() {
        let levelWrapper = TestLogLevelWrapper(level: LogLevel.error)
        
        let wrapper = TestLoggerWrapper()
        let handler = wrapper.handler
        
        let message1 = "Test"
        let tag1 = "TAG1"
        
        Log.v(message1, tag1)
        XCTAssertFalse(handler.didLog)
        XCTAssertNil(handler.messageLog)
        XCTAssertNil(handler.messageTag)
        XCTAssertNil(handler.messageLevel)
        handler.reset()
        
        Log.d(message1, tag1)
        XCTAssertFalse(handler.didLog)
        XCTAssertNil(handler.messageLog)
        XCTAssertNil(handler.messageTag)
        XCTAssertNil(handler.messageLevel)
        handler.reset()
        
        Log.i(message1, tag1)
        XCTAssertFalse(handler.didLog)
        XCTAssertNil(handler.messageLog)
        XCTAssertNil(handler.messageTag)
        XCTAssertNil(handler.messageLevel)
        handler.reset()
        
        Log.w(message1, tag1)
        XCTAssertFalse(handler.didLog)
        XCTAssertNil(handler.messageLog)
        XCTAssertNil(handler.messageTag)
        XCTAssertNil(handler.messageLevel)
        handler.reset()
        
        Log.e(message1, tag1)
        XCTAssertTrue(handler.didLog)
        
        XCTAssertNotNil(handler.messageLog)
        XCTAssertTrue(handler.messageLog?.message == message1)
        
        XCTAssertNotNil(handler.messageTag)
        XCTAssertTrue(handler.messageTag == tag1)
        
        XCTAssertNotNil(handler.messageLevel)
        XCTAssertEqual(handler.messageLevel, LogLevel.error)
    }
}
