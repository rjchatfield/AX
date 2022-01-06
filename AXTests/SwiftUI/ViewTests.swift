import SwiftUI
import XCTest
import SnapshotTesting

final class ViewTests: XCTestCase {
    
    // MARK: - Elements
    
    func testButton() {
    }
    
    func testColor() {
    }
    
    func testDatePicker() {
    }
    
    func testDivider() {
    }
    
    func testEditButton() {
    }
    
    func testEmptyView() {
    }
    
    func testImage() {
    }
    
    func testLabel() {
    }
    
    func testLink() {
    }
    
    func testMenuButton() {
    }
    
    func testPicker() {
    }
    
    func testProgressView() {
    }
    
    func testSecureField() {
    }
    
    func testSlider() {
    }
    
    func testStepper() {
    }
    
    func testTextEditor() {
    }
    
    func testTextField() {
    }
    
    func testText() {
        let view = Text("title")
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title")
        ]
        """)
    }
    
    func testToggle() {
    }
    
    
    // MARK: - Containers
    
    func testAlert() {
    }
    
    func testAnyView() {
    }
    
    func testCustomView() {
    }
    
    func testDisclosureGroup() {
    }
    
    func testForEach() {
    }
    
    func testForm() {
    }
    
    func testGroup() {
    }
    
    func testHStack() {
    }
    
    func testLazyHGrid() {
    }
    
    func testLazyHStack() {
    }
    
    func testLazyVGrid() {
    }
    
    func testLazyVStack() {
    }
    
    func testList() {
    }
    
    func testMenu() {
    }
    
    func testNavigationLink() {
    }
    
    func testNavigationView() {
    }
    
    func testScrollView() {
    }
    
    func testSection() {
    }
    
    func testTabView() {
    }
    
    func testTimelineView() {
    }
    
    func testToolbar() {
    }
    
    func testVStack() {
    }
    
    func testZStack() {
    }
}
