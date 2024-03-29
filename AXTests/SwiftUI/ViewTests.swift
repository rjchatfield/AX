import SwiftUI
import XCTest
import SnapshotTesting

final class ViewTests: XCTestCase {
    
    // MARK: - Elements
    
    func testButton() {
        let view = Button {} label: { Text("title") }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Button(label: "title"),
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
          [1]: Text(label: ""),
          [2]: Text(label: "10:00 AM"),
        ]
        """)
        
        // Weirdly, UILabel doesn't have `text`. But at runtime it is visible. Not sure how else to debug this?!
//        let els = AXElement.walk(view: view)
//        let label = els[1]
//            .value(axElement: 0)
//            .value(axElement: 0)
//            .value(axElement: 1)
//            .value(axElement: 0)
//            .subject(as: UILabel.self)
//        _assertInlineSnapshot(matching: label, as: .dump, with: """
//        - <UILabel; frame = (0 0; 0 0); userInteractionEnabled = NO; layer = <_UILabelLayer>>
//        """)
//        _assertInlineSnapshot(matching: label, as: .windowedAccessibilityElements, with: """
//        [
//          [0]: UILabel(label: "")
//        ]
//        """)
//        _assertInlineSnapshot(matching: label, as: .ivars, with: """
//        [
//          "0. Type": UILabel.self,
//          "1. Mirror.children": [:],
//          "2. NSObject.selectors": [
//            "adjustsFontForContentSizeCategory": 1,
//            "adjustsFontSizeToFitWidth": 0,
//            "adjustsLetterSpacingToFitWidth": 0,
//            "allowsDefaultTighteningForTruncation": 0,
//            "attributedText": nil,
//            "autotrackTextToFit": 0,
//            "baselineAdjustment": 0,
//            "canUseFastLayoutSizeCalulation": 1,
//            "centersHorizontally": 0,
//            "color": UIDynamicSystemColor(),
//            "currentTextColor": UIDynamicSystemColor(↩︎),
//            "defaultAccessibilityTraits": 64,
//            "drawsUnderline": 0,
//            "enablesMarqueeWhenAncestorFocused": 0,
//            "font": UICTFont(),
//            "highlightedTextColor": nil,
//            "intrinsicContentSize": NSSize: {0, 0},
//            "invalidateIntrinsicContentSize": nil,
//            "isAccessibilityElementByDefault": 1,
//            "isElementAccessibilityExposedToInterfaceBuilder": 1,
//            "isEnabled": 1,
//            "isHighlighted": 0,
//            "isLayoutSizeDependentOnPerpendicularAxis": 1,
//            "largeContentTitle": nil,
//            "lineBreakMode": 4,
//            "lineBreakStrategy": 65535,
//            "lineSpacing": 0,
//            "marqueeEnabled": 0,
//            "marqueeRunning": 0,
//            "minimumFontSize": 0,
//            "minimumScaleFactor": 0,
//            "numberOfLines": 1,
//            "preferredMaxLayoutWidth": 0,
//            "rawSize": NSSize: {0, 0},
//            "setNeedsDisplay": nil,
//            "shadowBlur": 0,
//            "shadowColor": nil,
//            "shadowOffset": NSSize: {0, -1},
//            "showsExpansionTextWhenTruncated": 0,
//            "text": nil,
//            "textAlignment": 2,
//            "textColor": UIDynamicSystemColor(↩︎),
//            "textSize": NSSize: {0, 0},
//            "tintColorDidChange": nil
//          ]
//        ]
//        """)
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
          [0]: Button(label: "Edit"),
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
          [0]: Image(label: "Favorite"),
        ]
        """)
    }
    
    func testLabel() {
        let view = Label("title", systemImage: "star")
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title"),
        ]
        """)
    }
    
    func testLink() {
        let view = Link("title", destination: URL(string: "www.atlassian.com")!)
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Button(
            label: "title",
            traits: .link,
          ),
        ]
        """)
    }
    
    func testPicker() {
        let view = Picker(selection: .constant(1), label: Text("Title")) {
            Text("First Option").tag(0)
            Text("Second Option").tag(1)
        }
        /*
         {
             "Title, Second Option, Button"
             Label: Title
             Value: Second Option
             Trait: Button
         }
         */
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Button(label: "Title, Second Option"),
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
        /*
         {
             "label, currentValueLabel, 10%, Updates Frequently"
             Label: label, currentValueLabel
             Value: 10%
             Trait: Updates Frequently
         }
         */
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: AccessibilityNode(
            label: "label, currentValueLabel",
            value: "10%",
            traits: .updatesFrequently,
          ),
        ]
        """)
    }
    
    func testSecureField() {
        let view = SecureField("title", text: .constant("value"), prompt: Text("prompt"))
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: UITextField(value: "value"),
        ]
        """)
    }
    
    func testSlider() {
        let view = Slider(value: .constant(69), in: 0...100, step: 1, onEditingChanged: { _ in })
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: UISlider(value: "69%"),
        ]
        """)
    }
    
    func testStepper() {
        let view = Stepper("title", value: .constant(69), in: 0...100, step: 1)
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: UIStepper(
            label: "title",
            value: "69",
          ),
        ]
        """)
    }
    
    func testTextEditor() {
        let view = TextEditor(text: .constant("value"))
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: TextEditorTextView(value: "value"),
        ]
        """)
    }
    
    func testTextField() {
        let view = VStack {
            TextField("title (no prompt, no value)", text: .constant(""))
            TextField("title", text: .constant(""), prompt: Text("prompt (no value)"))
            TextField("title", text: .constant("value"), prompt: Text("prompt"))
            TextField("title", value: .constant(0.69), format: .percent, prompt: Text("prompt"))
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: UITextField(value: "title (no prompt, no value)"),
          [1]: UITextField(value: "prompt (no value)"),
          [2]: UITextField(value: "value"),
          [3]: UITextField(value: "69%"),
        ]
        """)
    }
    
    func testText() {
        let view = Text("title")
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title"),
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
            traits: <private>,
          ),
        ]
        """)
    }
    
    
    // MARK: - Containers
    
    func testAlert() {
        let view = EmptyView()
            .alert(isPresented: .constant(true)) {
                Alert(
                    title: Text("alert-title"),
                    message: Text("alert-message"),
                    primaryButton: .destructive(Text("destructive")),
                    secondaryButton: .cancel()
                )
            }
        _assertInlineSnapshot(matching: view, as: .presentedAccessibilityElements, with: """
        [
          [0]: Text(label: "alert-title"),
          [1]: Text(label: "alert-message"),
        ]
        """)
    }
    
    func testAnyView() {
        let view = AnyView(Text("title"))
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title"),
        ]
        """)
    }
    
    func testCustomView() {
        struct MyView: View { var body: some View { Text("title") } }
        let view = MyView()
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title"),
        ]
        """)
    }
    
    func testDisclosureGroup() {
        let view = DisclosureGroup("Group1", isExpanded: .constant(true)) {
            Text("item1")
            DisclosureGroup("Group2", isExpanded: .constant(false)) {
                Button {} label: { Text("item2") }
            }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: AccessibilityNode(label: "Group1"),
          [1]: Text(label: "item1"),
          [2]: AccessibilityNode(label: "Group2"),
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
          [1]: Text(label: "item2"),
        ]
        """)
    }
    
    func testForm() {
        let view = Form {
            Text("item1")
            Button {} label: { Text("item2") }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        []
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
          [1]: Button(label: "item2"),
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
          [0]: AccessibilityNode(
            shouldGroupAccessibilityChildren: true,
            navigationStyle: .combined,
            containerType: .semanticGroup,
            accessibilityElements: [
              [0]: Text(label: "item1"),
              [1]: Button(label: "item2"),
            ],
          ),
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
          [1]: Button(label: "item2"),
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
          [0]: AccessibilityIncrementalLayoutNode(
            shouldGroupAccessibilityChildren: true,
            navigationStyle: .combined,
            containerType: .semanticGroup,
            accessibilityElements: [
              [0]: Text(label: "item1"),
              [1]: Button(label: "item2"),
            ],
          ),
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
          [0]: AccessibilityIncrementalLayoutNode(
            shouldGroupAccessibilityChildren: true,
            navigationStyle: .combined,
            containerType: .semanticGroup,
          ),
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
          [0]: AccessibilityIncrementalLayoutNode(
            shouldGroupAccessibilityChildren: true,
            navigationStyle: .combined,
            containerType: .semanticGroup,
            accessibilityElements: [
              [0]: Text(label: "item1"),
              [1]: Button(label: "item2"),
            ],
          ),
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
          [0]: AccessibilityIncrementalLayoutNode(
            shouldGroupAccessibilityChildren: true,
            navigationStyle: .combined,
            containerType: .semanticGroup,
          ),
        ]
        """)
    }
    
    func testList() {
        let view = List {
            Text("item1")
            Button {} label: { Text("item2") }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        []
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
            traits: <private>,
          ),
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
            customActions: [
              [0]: item2,
            ],
          ),
        ]
        """)
        
//        let els = AXElement.walk(view: view)
//        let nav = els[0]
//            .value(axElement: 0)
//            .value(axElement: 0)
//            .value(axElement: 1)
//            .value(axElement: 0)
//            .subject(as: UILabel.self)
//            .subject(as: NSObject.self)
        let frame = CGRect(x: 0, y: 0, width: 300, height: 3000)
        let viewController = UIHostingController(rootView: view)
        viewController.view.frame = frame
        let nav = viewController.view!
        let els = nav.accessibilityElements![0] // as! UIView
        _assertInlineSnapshot(matching: els, as: .dump, with: """
        - <SwiftUI.AccessibilityNode>
        """)
//        _assertInlineSnapshot(matching: els, as: .windowedAccessibilityElements, with: """
//        [
//          [0]: UILabel(label: "")
//        ]
//        """)
        _assertInlineSnapshot(matching: els, as: .ivars(badSelectors: ["accessibilityRowRange"]), with: """
        [
          "0. Type": AccessibilityNode.self,
          "1. Mirror.children": [
            "attachmentsStorage": […],
            "bridgedChild": nil,
            "cachedCombinedAttachment": nil,
            "cachedIsPlaceholderOrIgnored": false,
            "children": […],
            "environment": EnvironmentValues(…),
            "id": UniqueID(value: 7573),
            "parent": AccessibilityNode(…),
            "platformElementPropertiesDirty": true,
            "platformRotorStorage": [:],
            "relationshipScope": AccessibilityRelationshipScope(…),
            "version": DisplayList.Version(value: 0),
            "viewRendererHost": _UIHostingView(…),
          ],
          "2. NSObject.selectors": [
            "accessibilityActivate": 0,
            "accessibilityActivationPoint": NSPoint: {150.16666666666666, 1500.1666666666665},
            "accessibilityAttributedHint": nil,
            "accessibilityAttributedLabel": "item1",
            "accessibilityAttributedUserInputLabels": nil,
            "accessibilityAttributedValue": nil,
            "accessibilityChartDescriptor": nil,
            "accessibilityContainer": _UIHostingView(↩︎),
            "accessibilityContainerType": 0,
            "accessibilityCustomActions": […],
            "accessibilityCustomContent": [],
            "accessibilityCustomRotors": [],
            "accessibilityDecrement": nil,
            "accessibilityDragSourceDescriptors": [],
            "accessibilityDropPointDescriptors": [],
            "accessibilityElementDidBecomeFocused": nil,
            "accessibilityElementDidLoseFocus": nil,
            "accessibilityElements": [],
            "accessibilityElementsHidden": 0,
            "accessibilityFrame": NSRect: {{104.66666666666666, 1490}, {91, 20.333333333333258}},
            "accessibilityHint": nil,
            "accessibilityIdentifier": nil,
            "accessibilityIncrement": nil,
            "accessibilityLabel": "item1",
            "accessibilityLanguage": "en-US",
            "accessibilityNavigationStyle": 0,
            "accessibilityPath": UIBezierPath(),
            "accessibilityPerformEscape": 0,
            "accessibilityPerformMagicTap": 0,
            "accessibilityRespondsToUserInteraction": 0,
            "accessibilityRowRange": "[IGNORED]",
            "accessibilityTextualContext": nil,
            "accessibilityTraits": 257,
            "accessibilityURL": nil,
            "accessibilityUserInputLabels": nil,
            "accessibilityValue": nil,
            "accessibilityViewIsModal": 0,
            "isAccessibilityElement": 1,
            "shouldGroupAccessibilityChildren": 0,
          ],
        ]
        """)
    }
    
    func testNavigationView() {
        let view = NavigationView {
            Text("item1")
            Button {} label: { Text("item2") }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        []
        """)
    }
    
    func testScrollView() {
        let view = ScrollView {
            Text("item1")
            Button {} label: { Text("item2") }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: PlatformGroupContainer(
            shouldGroupAccessibilityChildren: true,
            accessibilityElements: [
              [0]: Text(label: "item1"),
              [1]: Button(label: "item2"),
            ],
          ),
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
            traits: .header,
          ),
          [1]: Button(
            label: "header.item2",
            traits: .header,
          ),
          [2]: Text(label: "item1"),
          [3]: Button(label: "item2"),
          [4]: Text(label: "footer.item1"),
          [5]: Button(label: "footer.item2"),
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
        /*
         {
             Label: First
             Value: 10 items
             Trait: Button, Selected, Tab
         }, {
             "First, 10 items, Button, Selected, Tab"
             Label: First
             Value: 10 items
             Trait: Button, Selected, Tab
         }, {
             "Second, Button, Tab"
             Label: Second
             Value: <None>
             Trait: Button, Tab
         }
         */
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(
            label: "item1",
            value: "10",
          ),
          [1]: UITabBarButton(
            label: "First",
            subviews: [
              [0]: Text(label: "First"),
              [1]: Text(label: "10"),
            ],
          ),
          [2]: UITabBarButton(
            label: "Second",
            subviews: [
              [0]: Text(label: "Second"),
            ],
          ),
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
          [1]: Button(label: "item2"),
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
        []
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
          [1]: Button(label: "item2"),
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
          [1]: Button(label: "item2"),
        ]
        """)
    }
    
    // MARK: - Modifiers
    
    func testOnTapGesture() {
        let view = Text("title").onTapGesture {}
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title"),
        ]
        """)
    }
    
    func testDisabled() {
        let view = VStack {
            Button("title", action: {}).disabled(true)
            TextField("title", text: .constant("value")).disabled(true)
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Button(
            label: "title",
            traits: .notEnabled,
          ),
          [1]: UITextField(
            value: "value",
            isEnabled: false,
          ),
        ]
        """)
    }
    
    // MARK: -
    
    override func setUp() {
        super.setUp()
        SnapshotTesting.isRecording = true
    }
}
