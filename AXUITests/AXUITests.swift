//
//  AXUITests.swift
//  AXUITests
//
//  Created by Robert Chatfield on 17/12/2021.
//

import XCTest

class AXUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        /*
         (lldb) po app
         Element subtree:
          →Application, 0x133909640, pid: 8869, label: 'AX'
             Window (Main), 0x133909de0, {{0.0, 0.0}, {390.0, 844.0}}
               Other, 0x133909ef0, {{0.0, 0.0}, {390.0, 844.0}}
                 Other, 0x13390a2a0, {{0.0, 0.0}, {390.0, 844.0}}
                   Other, 0x13390a000, {{0.0, 0.0}, {390.0, 844.0}}
                     Other, 0x13390a110, {{0.0, 0.0}, {390.0, 844.0}}
                       StaticText, 0x13390a830, {{147.7, 404.1}, {94.7, 20.3}}, label: 'Hello, world!'
                       Button, 0x13390a3b0, {{164.7, 448.7}, {60.7, 20.3}}, label: 'Tap me!'
         Path to element:
          →Application, 0x133909640, pid: 8869, label: 'AX'
         Query chain:
          →Find: Target Application 'com.rjchatfield.AX'
           Output: {
             Application, 0x131d14c50, pid: 8869, label: 'AX'
           }
         */
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
