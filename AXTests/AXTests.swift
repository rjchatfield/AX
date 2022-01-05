//
//  AXTests.swift
//  AXTests
//
//  Created by Robert Chatfield on 17/12/2021.
//

import XCTest
import CustomDump
import ViewInspector
import SwiftUI
import AccessibilitySnapshot
import SnapshotTesting

class AXTests: XCTestCase {

    func test1() {
        customDump(v)
    }
    
    func test2() {
        let vc = UIHostingController(rootView: v)
        _assertInlineSnapshot(matching: vc.view!, as: .customDump(maxDepth: 1), with: """
        _UIHostingView(
          _rootView: VStack(…),
          viewGraph: SwiftUI.ViewGraph,
          renderer: DisplayList.ViewRenderer(…),
          eventBindingManager: EventBindingManager(…),
          currentTimestamp: Time(seconds: 0.0),
          propertiesNeedingUpdate: ViewRendererHostProperties(rawValue: 1023),
          isRendering: false,
          accessibilityVersion: DisplayList.Version(value: 0),
          externalUpdateCount: 0,
          disabledBackgroundColor: false,
          allowFrameChanges: true,
          wantsTransparentBackground: false,
          explicitSafeAreaInsets: nil,
          keyboardFrame: nil,
          defaultAddsKeyboardToSafeAreaInsets: nil,
          keyboardSeed: 0,
          isHiddenForReuse: false,
          inheritedEnvironment: nil,
          environmentOverride: nil,
          viewController: UIHostingController(…),
          eventBridge: UIKitEventBindingBridge(…),
          displayLink: nil,
          lastRenderTime: Time(seconds: 0.0),
          canAdvanceTimeAutomatically: true,
          pendingPreferencesUpdate: false,
          nextTimerTime: nil,
          updateTimer: nil,
          colorScheme: nil,
          navigationState: nil,
          deprecatedAlertBridge: DeprecatedAlertBridge(…),
          deprecatedActionSheetBridge: DeprecatedAlertBridge(…),
          sheetBridge: SheetBridge(…),
          focusBridge: FocusBridge(…),
          dragBridge: DragAndDropBridge(…),
          fileImportExportBridge: FileImportExportBridge(…),
          inspectorBridge: UIKitInspectorBridge(…),
          sceneBridge: nil,
          pointerBridge: nil,
          statusBarBridge: UIKitStatusBarBridge(…),
          contextMenuBridge: ContextMenuBridge(…),
          accessibilityEnabled: false,
          shouldUpdateAccessibilityFocus: false,
          largeContentViewerInteractionBridge: UILargeContentViewerInteractionBridge(…),
          scrollTest: nil,
          delegate: nil,
          rootViewDelegate: nil,
          focusedValues: FocusedValues(…),
          currentAccessibilityFocusStore: AccessibilityFocusStore(…),
          observedScene: nil,
          isEnteringForeground: false,
          currentResponderCommands: [:],
          $__lazy_storage_$__forwardingTarget: nil
        )
        """)
        
        _assertInlineSnapshot(matching: vc.view.accessibilityElements!, as: .customDump(maxDepth: 2), with: """
        [
          [0]: AccessibilityNode(
            id: UniqueID(value: 196),
            version: DisplayList.Version(value: 0),
            children: [],
            bridgedChild: nil,
            parent: AccessibilityNode(…),
            viewRendererHost: _UIHostingView(…),
            attachmentsStorage: […],
            cachedCombinedAttachment: nil,
            platformRotorStorage: [:],
            cachedIsPlaceholder: false,
            focusableAncestor: nil,
            relationshipScope: nil,
            isCell: false
          ),
          [1]: AccessibilityNode(
            id: UniqueID(value: 234),
            version: DisplayList.Version(value: 0),
            children: […],
            bridgedChild: nil,
            parent: AccessibilityNode(↩︎),
            viewRendererHost: _UIHostingView(↩︎),
            attachmentsStorage: […],
            cachedCombinedAttachment: nil,
            platformRotorStorage: [:],
            cachedIsPlaceholder: false,
            focusableAncestor: nil,
            relationshipScope: nil,
            isCell: false
          ),
          [2]: AccessibilityNode(
            id: UniqueID(value: 236),
            version: DisplayList.Version(value: 0),
            children: [],
            bridgedChild: nil,
            parent: AccessibilityNode(↩︎),
            viewRendererHost: _UIHostingView(↩︎),
            attachmentsStorage: […],
            cachedCombinedAttachment: nil,
            platformRotorStorage: [:],
            cachedIsPlaceholder: false,
            focusableAncestor: nil,
            relationshipScope: nil,
            isCell: false
          ),
          [3]: AccessibilityNode(
            id: UniqueID(value: 239),
            version: DisplayList.Version(value: 0),
            children: [],
            bridgedChild: nil,
            parent: AccessibilityNode(↩︎),
            viewRendererHost: _UIHostingView(↩︎),
            attachmentsStorage: […],
            cachedCombinedAttachment: nil,
            platformRotorStorage: [:],
            cachedIsPlaceholder: false,
            focusableAncestor: nil,
            relationshipScope: nil,
            isCell: false
          ),
          [4]: AccessibilityNode(
            id: UniqueID(value: 240),
            version: DisplayList.Version(value: 0),
            children: [],
            bridgedChild: nil,
            parent: AccessibilityNode(↩︎),
            viewRendererHost: _UIHostingView(↩︎),
            attachmentsStorage: […],
            cachedCombinedAttachment: nil,
            platformRotorStorage: [:],
            cachedIsPlaceholder: false,
            focusableAncestor: nil,
            relationshipScope: nil,
            isCell: false
          ),
          [5]: AccessibilityNode(
            id: UniqueID(value: 235),
            version: DisplayList.Version(value: 0),
            children: [],
            bridgedChild: nil,
            parent: AccessibilityNode(↩︎),
            viewRendererHost: _UIHostingView(↩︎),
            attachmentsStorage: […],
            cachedCombinedAttachment: nil,
            platformRotorStorage: [:],
            cachedIsPlaceholder: false,
            focusableAncestor: nil,
            relationshipScope: nil,
            isCell: false
          )
        ]
        """)
        
        let ax1 = vc.view.accessibilityElements![0]
        let nsax1 = ax1 as! NSObject
        XCTAssertEqual(try v.inspect().vStack().text(0).string(), "ax_text")
        _assertInlineSnapshot(matching: nsax1, as: .customDump(maxDepth: 1), with: """
        AccessibilityNode(
          id: UniqueID(value: 196),
          version: DisplayList.Version(value: 0),
          children: [],
          bridgedChild: nil,
          parent: AccessibilityNode(…),
          viewRendererHost: _UIHostingView(…),
          attachmentsStorage: […],
          cachedCombinedAttachment: nil,
          platformRotorStorage: [:],
          cachedIsPlaceholder: false,
          focusableAncestor: nil,
          relationshipScope: nil,
          isCell: false
        )
        """)
        print("NSAX1:")
        _assertInlineSnapshot(matching: nsax1.isAccessibilityElement, as: .customDump, with: """
        true
        """)
        _assertInlineSnapshot(matching: nsax1.accessibilityLabel as Any, as: .customDump, with: """
        "ax_text"
        """)
        _assertInlineSnapshot(matching: nsax1.accessibilityValue as Any, as: .customDump, with: """
        nil
        """)
        _assertInlineSnapshot(matching: nsax1.accessibilityHint as Any, as: .customDump, with: """
        nil
        """)
        _assertInlineSnapshot(matching: nsax1.accessibilityFrame, as: .customDump, with: """
        CGRect(
          origin: CGPoint(
            x: 0.0,
            y: -16.172159830729164
          ),
          size: CGSize(
            width: 0.0,
            height: 0.0
          )
        )
        """)
    }
    
    func test3() {
        _assertInlineSnapshot(matching: v, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "ax_text"),
          [1]: PlatformAccessibilityElement(
            label: "section_header_text",
            traits: .header,
            customActions: [
              [0]: section_header_button
            ]
          ),
          [2]: Button(
            label: "ax_button_label",
            hint: "ax_button_hint",
            value: "ax_button_value"
          ),
          [3]: Text(label: "ax_label_title"),
          [4]: Image(label: "Forward"),
          [5]: Button(label: "ax_button_1")
        ]
        """)
        _assertInlineSnapshot(matching: v, as: .voiceOver, with: """
        "TODO: voiceOver elements"
        """)
        /*
         TODO: VoiceOver
         [
           [0]: "ax_text",
           [1]: "section_header_text, header"
           [2]: "button, ax_button_label, ax_button_hint, ax_button_value",
           [3]: "button, ax_button_1"
         ]
         */
    }
    
    func test4() {
        customDump(AXElement.walk(view: uiView))
        _assertInlineSnapshot(matching: uiView, as: .accessibilityElements, with: """
        [
          [0]: UIView(
            children: [
              [0]: Text(),
              [1]: UIView(
                children: [
                  [0]: Button(
                    label: "ax_button_label",
                    hint: "ax_button_hint",
                    value: "ax_button_value",
                    children: [
                      [0]: Text()
                    ]
                  ),
                  [1]: Button(
                    children: [
                      [0]: Text()
                    ]
                  )
                ]
              )
            ]
          )
        ]
        """)
        _assertInlineSnapshot(matching: uiView, as: .voiceOver, with: """
        "TODO: voiceOver elements"
        """)
    }
    
    func test5() {
        let vc = UIHostingController(rootView: v)
        let parsed = AccessibilityHierarchyParser().parseAccessibilityElements(in: vc.view)
        _assertInlineSnapshot(matching: parsed, as: .customDump, with: """
        []
        """)
    }
    
    func test6() {
        let parsed = AccessibilityHierarchyParser().parseAccessibilityElements(in: uiView)
        _assertInlineSnapshot(matching: parsed, as: .customDump, with: """
        [
          [0]: AccessibilityMarker(
            description: "ax_button_label: ax_button_value",
            hint: "ax_button_hint",
            shape: AccessibilityMarker.Shape.frame(
              CGRect(
                origin: CGPoint(
                  x: 0.0,
                  y: 0.0
                ),
                size: CGSize(
                  width: 0.0,
                  height: 0.0
                )
              )
            ),
            activationPoint: CGPoint(
              x: 0.0,
              y: 0.0
            ),
            usesDefaultActivationPoint: true,
            customActions: [],
            accessibilityLanguage: nil
          ),
          [1]: AccessibilityMarker(
            description: "",
            hint: nil,
            shape: AccessibilityMarker.Shape.frame(
              CGRect(
                origin: CGPoint(
                  x: 0.0,
                  y: 0.0
                ),
                size: CGSize(
                  width: 0.0,
                  height: 0.0
                )
              )
            ),
            activationPoint: CGPoint(
              x: 0.0,
              y: 0.0
            ),
            usesDefaultActivationPoint: true,
            customActions: [],
            accessibilityLanguage: nil
          )
        ]
        """)
    }

    // MARK: -
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        SnapshotTesting.isRecording = true
    }
    
    var v: some View {
        VStack {
//        List {
//        LazyVStack {
            Text("ax_text")
            Section {
                Button("ax_button_1") {}
                    .accessibilitySortPriority(-1) // after everything
                
                /*
                 ax_button_label, ax_button_value, Button, ax_button_hint
                 */
                Button("ax_button_2") {}
                    .accessibilityLabel("ax_button_label")
                    .accessibilityIdentifier("ax_button_identifier")
                    .accessibilityHint(Text("ax_button_hint"))
                    .accessibilityValue(Text("ax_button_value").bold())
                Button("ax_button_3_hidden") {}
                    .accessibilityHidden(true)
                
                /*
                 ```
                 Text(label: "ax_label_title")
                 ```
                 
                 No image is good
                 TODO: But should we avoid calling this "Text" just because it is .staticText?
                 */
                Label("ax_label_title", systemImage: "chevron.down")
                
                Image(systemName: "chevron.right")
                
                /*
                 Interestingly `TextField` is exposed as a `UITextField`
                 
                 - <UITextField: 0x13d014000; frame = (0 0; 0 0); opaque = NO; text = 'ax_textfield_text'; placeholder = ax_textfield_text; borderStyle = None; background = <_UITextFieldNoBackgroundProvider: 0x6000027c48e0: textfield=<UITextField 0x13d014000>>; layer = <CALayer: 0x6000025bcb40>> #0
                 */
//                TextField("ax_textfield_title", text: .constant("ax_textfield_text"), prompt: Text("ax_textfield_text"))
            } header: {
                HStack {
                    Text("section_header_text")
                    Button("section_header_button") {}
                }
                .accessibilityElement(children: .combine)
            }
        }
    }
    
    var uiView: UIView {
        let label = UILabel()
        label.text = "ax_text"
        let button1 = UIButton()
        button1.setTitle("ax_button_1", for: .normal)
        let button2 = UIButton(type: .system)
        button2.setTitle("ax_button_2", for: .normal)
        button2.accessibilityLabel = "ax_button_label"
        button2.accessibilityIdentifier = "ax_button_identifier"
        button2.accessibilityHint = "ax_button_hint"
        button2.accessibilityValue = "ax_button_value"
        let button3 = UIButton()
        button2.setTitle("ax_button_3_hidden", for: .normal)
        let section = UIStackView(arrangedSubviews: [
            // Section Header?
            button1,
            button2,
            button3,
        ])
        section.accessibilityElements = [button2, button1]
        let view = UIStackView(arrangedSubviews: [
            label,
            section,
        ])
        view.frame = CGRect(x: 0, y: 0, width: 300, height: 3000)
        view.sizeToFit()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        return view
    }
}
