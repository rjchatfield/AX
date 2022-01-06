import SwiftUI
import XCTest
import SnapshotTesting

final class ButtonTests: XCTestCase {
    
    func testTitleString() {
        let view = Button("title", action: {})
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Button(label: "title")
        ]
        """)
    }
    
    func testTitleBuilder() {
        let view = Button(action: {}, label: { Text("title") })
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Button(label: "title")
        ]
        """)
    }
    
    func testTitleBuilderComplex() {
        let view = Button(action: {}) {
            HStack {
                Image(systemName: "star")
                VStack {
                    Text("title")
                    Text("subtitle")
                }
            }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Button(label: "title, subtitle")
        ]
        """)
    }
    
    func testAX() {
        let view = Button("title", action: {})
            .accessibilityLabel(Text("ax_label"))
            .accessibilityHint(Text("ax_label"))
            .accessibilityValue(Text("ax_value"))
            .accessibilityInputLabels([Text("ax_input_label1"), Text("ax_input_label2")])
            .accessibilityIdentifier("ax_identifier")
        // .accessibilityActivationPoint
        // sort priority
        // .accessibilityShowsLargeContentViewer {}
        // .accessibilityAddTraits
        // .accessibilityLinkedGroup
        // .accessibilityLabeledPair
        // .accessibilityRepresentation
        // .accessibilityChildren
        // .accessibilityElement(children:)
        // .accessibilityScrollAction
        // .accessibilityAdjustableAction
        // .accessibilityTextContentType
        // .accessibilityHeading(_: AccessibilityHeadingLevel)
        // .help
        // .accessibilityRotorEntry
        // .accessibilityAction
        // .accessibilityCustomContent
        // .accessibilityHidden
        // .accessibilityRespondsToUserInteraction
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Button(
            identifier: "ax_identifier",
            label: "ax_label",
            hint: "ax_label",
            value: "ax_value",
            userInputLabels: [
              [0]: "ax_input_label1",
              [1]: "ax_input_label2"
            ]
          )
        ]
        """)
    }
    
    func testEnclosedView() throws {
        let sut = Button(action: {}, label: { Text("Test") })
        let value = AXElement.walk(view: sut).first?.label as? String
        XCTAssertEqual(value, "Test")
    }
    
//    func testResetsModifiers() throws {
//        let view = Button(action: {}, label: { Text("") }).padding()
//        let sut = try view.inspect().button().labelView().text()
//        XCTAssertEqual(sut.content.medium.viewModifiers.count, 0)
//    }
//
    func testExtractionFromSingleViewContainer() throws {
        let sut = AnyView(Button(action: {}, label: { Text("") }))
        XCTAssertNotNil(AXElement.walk(view: sut)[safe: 0]?.label as? String)
    }

    func testExtractionFromMultipleViewContainer() throws {
        let sut = HStack {
            Button(action: {}, label: { Text("") })
            Button(action: {}, label: { Text("") })
        }
        XCTAssertNotNil(AXElement.walk(view: sut)[safe: 0]?.label as? String)
        XCTAssertNotNil(AXElement.walk(view: sut)[safe: 1]?.label as? String)
    }
//
//    func testSearch() throws {
//        let view = Group { Button(action: {}, label: { AnyView(Text("abc")) }) }
//        XCTAssertEqual(try view.inspect().find(ViewType.Button.self).pathToRoot,
//                       "group().button(0)")
//        XCTAssertEqual(try view.inspect().find(button: "abc").pathToRoot,
//                       "group().button(0)")
//        XCTAssertEqual(try view.inspect().find(ViewType.Text.self).pathToRoot,
//                       "group().button(0).labelView().anyView().text()")
//        XCTAssertEqual(try view.inspect().find(text: "abc").pathToRoot,
//                       "group().button(0).labelView().anyView().text()")
//    }
//
//    func testWhenButtonDoesNotHaveTheDisabledModifier_InvokesCallback() throws {
//        let exp = XCTestExpectation(description: "Callback")
//        let button = Button(action: {
//            exp.fulfill()
//        }, label: { Text("Test") })
//        try button.inspect().button().tap()
//        wait(for: [exp], timeout: 0.5)
//    }
//
//    func testTap() throws {
//        let exp = XCTestExpectation(description: "Callback")
//        let button = Button(action: {
//            exp.fulfill()
//        }, label: { Text("Test") }).disabled(false)
//        try button.inspect().button().tap()
//        wait(for: [exp], timeout: 0.5)
//    }
//
//    func testTapWhenDisabled() throws {
//        let exp = XCTestExpectation(description: "Callback")
//        exp.isInverted = true
//        let button = Button(action: {
//            exp.fulfill()
//        }, label: { Text("Test") }).disabled(true)
//        XCTAssertThrows(try button.inspect().button().tap(),
//            "Button is unresponsive: it is disabled")
//        wait(for: [exp], timeout: 0.5)
//    }
//
//    func testButtonRole() throws {
//        let v = VStack {
//            Button(role: .cancel, action: { }, label: { Text("") })
//            Button(role: .destructive, action: { }, label: { Text("") })
//            Button(action: { }, label: { Text("") })
//        }
//        _assertInlineSnapshot(matching: v, as: .accessibilityElements, with: """
//        [
//          [0]: Button(label: ""),
//          [1]: Button(label: ""),
//          [2]: Button(label: "")
//        ]
//        """)
////        XCTAssertEqual(try sut1.inspect().button().role(), .cancel)
////        XCTAssertEqual(try sut2.inspect().button().role(), .destructive)
////        XCTAssertNil(try sut3.inspect().button().role())
//    }
    
    // MARK: -
    
    override func setUp() {
        super.setUp()
        SnapshotTesting.isRecording = true
    }
}
