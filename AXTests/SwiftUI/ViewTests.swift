import SwiftUI
import XCTest
import SnapshotTesting

final class ViewTests: XCTestCase {
    
    // MARK: - Elements
    
    func testButton() {
        let view = Button {} label: { Text("title") }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Button(label: "title")
        ]
        """)
    }
    
    func testColor() {
        let view = Color.red
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        []
        """)
    }
    
    func testDatePicker() {
        let d1 = Date(timeIntervalSince1970: 0)
        let d2 = d1.advanced(by: 601)
        let view = DatePicker("title", selection: .constant(d1), in: d1...d2)
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title"),
          [1]: PlatformAccessibilityElement(
            children: [
              [0]: UIView(
                children: [
                  [0]: UIView(
                    children: [
                      [0]: UIView(),
                      [1]: UIView(
                        children: [
                          [0]: UIView()
                        ]
                      )
                    ]
                  ),
                  [1]: UIView(
                    children: [
                      [0]: UIView(),
                      [1]: UIView(),
                      [2]: UIView(),
                      [3]: UIView(),
                      [4]: UIView()
                    ]
                  )
                ]
              )
            ]
          )
        ]
        """)
    }
    
    func testDivider() {
        let view = Divider()
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        []
        """)
    }
    
    func testEditButton() {
        let view = EditButton()
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Button(label: "Edit")
        ]
        """)
    }
    
    func testEmptyView() {
        let view = EmptyView()
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        []
        """)
    }
    
    func testImage() {
        let view = Image(systemName: "star")
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Image(label: "Favorite")
        ]
        """)
    }
    
    func testLabel() {
        let view = Label("title", systemImage: "star")
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title")
        ]
        """)
    }
    
    func testLink() {
        let view = Link("title", destination: URL(string: "www.atlassian.com")!)
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Button(
            label: "title",
            traits: .link
          )
        ]
        """)
    }
    
    func testPicker() {
        let view = Picker(selection: .constant(1), label: Text("Title")) {
            Text("First Option").tag(0)
            Text("Second Option").tag(1)
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: PlatformAccessibilityElement(label: "Second Option"),
          [1]: Text(label: "Title")
        ]
        """)
    }
    
    func testProgressView() {
        let view = ProgressView(
            value: 0.1,
            total: 1,
            label: { Text("label") },
            currentValueLabel: { Text("currentValueLabel") }
        )
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: PlatformAccessibilityElement(
            label: "label, currentValueLabel",
            value: "10%",
            children: [
              [0]: UIView(),
              [1]: UIView()
            ]
          )
        ]
        """)
    }
    
    func testSecureField() {
        let view = SecureField("title", text: .constant("value"), prompt: Text("prompt"))
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: PlatformAccessibilityElement(
            children: [
              [0]: UIView()
            ]
          )
        ]
        """)
    }
    
    func testSlider() {
        let view = Slider(value: .constant(69), in: 0...100, step: 1, onEditingChanged: { _ in })
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: PlatformAccessibilityElement(
            value: "69%",
            children: [
              [0]: UIView()
            ]
          )
        ]
        """)
    }
    
    func testStepper() {
        let view = Stepper("title", value: .constant(69), in: 0...100, step: 1)
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title"),
          [1]: PlatformAccessibilityElement(
            value: "69",
            children: [
              [0]: UIView(
                children: [
                  [0]: UIView(),
                  [1]: UIView(),
                  [2]: UIView(
                    children: [
                      [0]: UIView()
                    ]
                  ),
                  [3]: UIView(),
                  [4]: UIView(),
                  [5]: UIView(),
                  [6]: UIView()
                ]
              )
            ]
          )
        ]
        """)
    }
    
    func testTextEditor() {
        let view = TextEditor(text: .constant("value"))
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: PlatformAccessibilityElement(
            children: [
              [0]: UIView(),
              [1]: UIView(
                children: [
                  [0]: UIView(),
                  [1]: UIView()
                ]
              )
            ]
          )
        ]
        """)
    }
    
    func testTextField() {
        let view = TextField("title", value: .constant(1.0), format: .percent, prompt: Text("prompt"))
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: PlatformAccessibilityElement(
            children: [
              [0]: UIView()
            ]
          )
        ]
        """)
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
        let view = Toggle("title", isOn: .constant(true))
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Button(
            label: "title",
            value: "1",
            traits: 
          )
        ]
        """)
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
    
    // MARK: -
    
    override func setUp() {
        super.setUp()
        SnapshotTesting.isRecording = true
    }
}
