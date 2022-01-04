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

class AXTests: XCTestCase {
    var v: some View { Examples.body1 }
    
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

    func testExample() {
//        customDump(v)
    }
    
    func test2() {
        let vc = UIHostingController(rootView: v)
//        customDump(vc.view, maxDepth: 1)
        /*
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
         */
        
//        customDump(vc.view.accessibilityElements, maxDepth: 2)
        /*
         [
           [0]: AccessibilityNode(
             id: UniqueID(value: 67),
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
             id: UniqueID(value: 86),
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
         */
        let ax1 = vc.view.accessibilityElements![0]
        let nsax1 = ax1 as! NSObject
//        XCTAssertEqual(try v.inspect().vStack().text(0).string(), "ax_text")
        customDump(nsax1, maxDepth: 1)
        print("NSAX1:")
        print(nsax1.isAccessibilityElement)
        print(nsax1.accessibilityLabel as Any)
        print(nsax1.accessibilityValue as Any)
        print(nsax1.accessibilityHint as Any)
        print(nsax1.accessibilityFrame)
    }
    
    func test3() {
        customDump(AXElement.walk(view: v))
        /*
         [
           [0]: Text(label: "ax_text"),
           [1]: AXElement(
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
           [3]: Button(label: "ax_button_1")
         ]
         */
        
        /*
         [
           [0]: Text(label: "ax_text"),
           [1]: AXElement(
             label: "section_header_text",
             isHeader: true,
             customActions: [
               [0]: "section_header_button"
             ]
           ),
           [2]: Button(
             label: "ax_button_label",
             hint: "ax_button_hint",
             value: "ax_button_value"
           ),
           [3]: Button(label: "ax_button_1")
         ]
         */
        /*
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
        /*
         [
           [0]: AXElement(
             children: [
               [0]: AXElement(),
               [1]: AXElement(
                 children: [
                   [0]: AXElement(
                     label: "ax_button_label",
                     hint: "ax_button_hint",
                     value: "ax_button_value"
                   ),
                   [1]: AXElement()
                 ]
               )
             ]
           )
         ]
         */
    }
    
    func test5() {
        let vc = UIHostingController(rootView: v)
        let parsed = AccessibilityHierarchyParser().parseAccessibilityElements(in: vc.view)
        XCTAssert(parsed.isEmpty) // Not sure why
        customDump(parsed)
    }
    
    func test6() {
        let parsed = AccessibilityHierarchyParser().parseAccessibilityElements(in: uiView)
        customDump(parsed)
    }

}

extension Mirror {
    subscript(label: String) -> Any? {
        children.first(where: { $0.label == label })?.value
            ?? superclassMirror?[label]
    }
}

extension UIView {
    subscript(mirroring label: String) -> Any? {
        Mirror(reflecting: self)[label]
    }
}
