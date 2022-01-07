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
            type: SwiftUIDatePicker.self,
            children: [
              [0]: UIView(
                type: _UIDatePickerIOSCompactView.self,
                children: [
                  [0]: UIView(
                    type: _UIDatePickerCompactDateLabel.self,
                    children: [
                      [0]: UIView(type: UIView.self),
                      [1]: UIView(
                        type: _UIDatePickerLinkedLabel.self,
                        children: [
                          [0]: UIView(type: UILabel.self)
                        ]
                      )
                    ]
                  ),
                  [1]: UIView(
                    type: _UIDatePickerCompactTimeLabel.self,
                    children: [
                      [0]: UIView(type: UIView.self),
                      [1]: UIView(type: UILabel.self),
                      [2]: UIView(type: UILabel.self),
                      [3]: UIView(type: UILabel.self),
                      [4]: UIView(type: UILabel.self)
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
          [0]: PlatformAccessibilityElement(
            type: UIButton.self,
            label: "Second Option"
          ),
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
            type: UIProgressView.self,
            label: "label, currentValueLabel",
            value: "10%",
            children: [
              [0]: UIView(type: UIImageView.self),
              [1]: UIView(type: UIImageView.self)
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
            type: UITextField.self,
            children: [
              [0]: UIView(type: _UITextLayoutCanvasView.self)
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
            type: UISlider.self,
            value: "69%",
            children: [
              [0]: UIView(type: _UISlideriOSVisualElement.self)
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
            type: UIStepper.self,
            value: "69",
            children: [
              [0]: UIView(
                type: UIStepperHorizontalVisualElement.self,
                children: [
                  [0]: UIView(type: UIImageView.self),
                  [1]: UIView(type: UIImageView.self),
                  [2]: UIView(
                    type: UIImageView.self,
                    children: [
                      [0]: UIView(type: UIImageView.self)
                    ]
                  ),
                  [3]: UIView(type: UIImageView.self),
                  [4]: UIView(type: UIImageView.self),
                  [5]: UIView(type: _UIStepperButton.self),
                  [6]: UIView(type: _UIStepperButton.self)
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
            type: UITextView.self,
            children: [
              [0]: UIView(type: _UITextLayoutView.self),
              [1]: UIView(
                type: _UITextContainerView.self,
                children: [
                  [0]: UIView(type: _UITextViewCanvasView.self),
                  [1]: UIView(type: UITextSelectionView.self)
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
            type: UITextField.self,
            children: [
              [0]: UIView(type: _UITextLayoutCanvasView.self)
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
        let view = EmptyView()
            .alert(isPresented: .constant(true)) {
                Alert(
                    title: Text("title"),
                    message: Text("message"),
                    primaryButton: .destructive(Text("destructive")),
                    secondaryButton: .cancel()
                )
            }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        []
        """)
    }
    
    func testAnyView() {
        let view = AnyView(Text("title"))
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title")
        ]
        """)
    }
    
    func testCustomView() {
        struct MyView: View { var body: some View { Text("title") } }
        let view = MyView()
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title")
        ]
        """)
    }
    
    func testDisclosureGroup() {
        let view = DisclosureGroup("Group1", isExpanded: .constant(true)) {
            Text("item1")
            DisclosureGroup("Group2") {
                Button {} label: { Text("item2") }
            }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Button(
            label: "Group1",
            customActions: [
              [0]: Group1
            ]
          ),
          [1]: Text(label: "item1"),
          [2]: Button(
            label: "Group2",
            customActions: [
              [0]: Group2
            ]
          )
        ]
        """)
    }
    
    func testForEach() {
        let view = ForEach([1, 2], id: \.self) { i in
            Text("item\(i)")
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "item1"),
          [1]: Text(label: "item2")
        ]
        """)
    }
    
    func testForm() {
        let view = Form {
            Text("item1")
            Button {} label: { Text("item2") }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: PlatformAccessibilityElement(type: UpdateCoalescingTableView.self)
        ]
        """)
    }
    
    func testGroup() {
        let view = Group {
            Text("item1")
            Button {} label: { Text("item2") }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "item1"),
          [1]: Button(label: "item2")
        ]
        """)
    }
    
    func testGroupBox() {
        let view = GroupBox {
            Text("item1")
            Button {} label: { Text("item2") }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: PlatformAccessibilityElement(
            shouldGroupAccessibilityChildren: true,
            navigationStyle: .combined,
            containerType: .semanticGroup,
            children: [
              [0]: Text(label: "item1"),
              [1]: Button(label: "item2")
            ]
          )
        ]
        """)
    }
    
    func testHStack() {
        let view = HStack {
            Text("item1")
            Button {} label: { Text("item2") }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "item1"),
          [1]: Button(label: "item2")
        ]
        """)
    }
    
    func testLazyHGrid() {
        let view = LazyHGrid(
            rows: [GridItem()],
            alignment: .center,
            spacing: 10,
            pinnedViews: [.sectionHeaders],
            content: {
                Text("item1")
                Button {} label: { Text("item2") }
            }
        )
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: PlatformAccessibilityElement(
            shouldGroupAccessibilityChildren: true,
            navigationStyle: .combined,
            containerType: .semanticGroup,
            children: [
              [0]: Text(label: "item1"),
              [1]: Button(label: "item2")
            ]
          )
        ]
        """)
    }
    
    func testLazyHStack() {
        let view = LazyHStack {
            Text("item1")
            Button {} label: { Text("item2") }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: PlatformAccessibilityElement(
            shouldGroupAccessibilityChildren: true,
            navigationStyle: .combined,
            containerType: .semanticGroup,
            children: [
              [0]: Text(label: "item1"),
              [1]: Button(label: "item2")
            ]
          )
        ]
        """)
    }
    
    func testLazyVGrid() {
        let view = LazyVGrid(
            columns: [GridItem()],
            alignment: .center,
            spacing: 10,
            pinnedViews: [.sectionHeaders],
            content: {
                Text("item1")
                Button {} label: { Text("item2") }
            }
        )
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: PlatformAccessibilityElement(
            shouldGroupAccessibilityChildren: true,
            navigationStyle: .combined,
            containerType: .semanticGroup,
            children: [
              [0]: Text(label: "item1"),
              [1]: Button(label: "item2")
            ]
          )
        ]
        """)
    }
    
    func testLazyVStack() {
        let view = LazyVStack {
            Text("item1")
            Button {} label: { Text("item2") }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: PlatformAccessibilityElement(
            shouldGroupAccessibilityChildren: true,
            navigationStyle: .combined,
            containerType: .semanticGroup,
            children: [
              [0]: Text(label: "item1"),
              [1]: Button(label: "item2")
            ]
          )
        ]
        """)
    }
    
    func testList() {
        let view = List {
            Text("item1")
            Button {} label: { Text("item2") }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: PlatformAccessibilityElement(
            type: UpdateCoalescingTableView.self,
            children: [
              [0]: UIView(type: UITableViewWrapperView.self)
            ]
          )
        ]
        """)
    }
    
    func testMenu() {
        let view = Menu("title") {
            Text("item1")
            Button {} label: { Text("item2") }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Button(
            label: "title",
            traits: 
          )
        ]
        """)
    }
    
    func testNavigationLink() {
        let view = NavigationLink(destination: Text("next"), isActive: .constant(true)) {
            Text("item1")
            Button {} label: { Text("item2") }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Button(
            label: "item1",
            traits: .notEnabled,
            customActions: [
              [0]: item2
            ]
          )
        ]
        """)
    }
    
    func testNavigationView() {
        let view = NavigationView {
            Text("item1")
            Button {} label: { Text("item2") }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: PlatformAccessibilityElement(
            type: _UISplitViewControllerPanelImplView.self,
            children: [
              [0]: UIView(type: _UIPanelControllerContentView.self)
            ]
          )
        ]
        """)
    }
    
    func testScrollView() {
        let view = ScrollView {
            Text("item1")
            Button {} label: { Text("item2") }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: PlatformAccessibilityElement(
            type: HostingScrollView.self,
            children: [
              [0]: UIView(
                type: HostingScrollView.PlatformGroupContainer.self,
                shouldGroupAccessibilityChildren: true,
                children: [
                  [0]: Text(label: "item1"),
                  [1]: Button(label: "item2")
                ]
              ),
              [1]: UIView(
                type: _UIScrollViewScrollIndicator.self,
                children: [
                  [0]: UIView(type: UIView.self)
                ]
              )
            ]
          )
        ]
        """)
    }
    
    func testSection() {
        let view = Section {
            Text("item1")
            Button {} label: { Text("item2") }
        } header: {
            Text("header.item1")
            Button {} label: { Text("header.item2") }
        } footer: {
            Text("footer.item1")
            Button {} label: { Text("footer.item2") }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(
            label: "header.item1",
            traits: .header
          ),
          [1]: Button(
            label: "header.item2",
            traits: .header
          ),
          [2]: Text(label: "item1"),
          [3]: Button(label: "item2"),
          [4]: Text(label: "footer.item1"),
          [5]: Button(label: "footer.item2")
        ]
        """)
    }
    
    func testTabView() {
        let view = TabView {
            Text("item1")
                .badge(10)
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("First")
                }
            Button {} label: { Text("item2") }
                 .tabItem {
                     Image(systemName: "2.square.fill")
                     Text("Second")
                 }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: PlatformAccessibilityElement(
            type: UILayoutContainerView.self,
            children: [
              [0]: UIView(
                type: UITransitionView.self,
                children: [
                  [0]: UIView(
                    type: UIViewControllerWrapperView.self,
                    children: [
                      [0]: UIView(
                        type: _UIHostingView.self,
                        children: [
                          [0]: Text(
                            label: "item1",
                            value: "10"
                          )
                        ]
                      )
                    ]
                  )
                ]
              ),
              [1]: UIView(
                type: UITabBar.self,
                children: [
                  [0]: UIView(
                    type: UITabBarButton.self,
                    label: "First",
                    children: [
                      [0]: UIView(type: UITabBarSwappableImageView.self),
                      [1]: UIView(type: UITabBarButtonLabel.self),
                      [2]: UIView(
                        type: _UIBadgeView.self,
                        children: [
                          [0]: UIView(type: UILabel.self)
                        ]
                      )
                    ]
                  ),
                  [1]: UIView(
                    type: UITabBarButton.self,
                    label: "Second",
                    children: [
                      [0]: UIView(type: UITabBarSwappableImageView.self),
                      [1]: UIView(type: UITabBarButtonLabel.self)
                    ]
                  )
                ]
              )
            ]
          )
        ]
        """)
    }
    
    func testTimelineView() {
        let view = TimelineView(.everyMinute) { context in
            Text("item1")
            Button {} label: { Text("item2") }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "item1"),
          [1]: Button(label: "item2")
        ]
        """)
    }
    
    func testToolbar() {
        let view = Text("").toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Text("item1")
                Button {} label: { Text("item2") }
            }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "")
        ]
        """)
    }
    
    func testVStack() {
        let view = VStack {
            Text("item1")
            Button {} label: { Text("item2") }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "item1"),
          [1]: Button(label: "item2")
        ]
        """)
    }
    
    func testZStack() {
        let view = ZStack {
            Text("item1")
            Button {} label: { Text("item2") }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "item1"),
          [1]: Button(label: "item2")
        ]
        """)
    }
    
    // MARK: -
    
    override func setUp() {
        super.setUp()
        SnapshotTesting.isRecording = true
    }
}
