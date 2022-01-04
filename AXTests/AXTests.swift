//
//  AXTests.swift
//  AXTests
//
//  Created by Robert Chatfield on 17/12/2021.
//

import XCTest
@testable import AX
import CustomDump
import ViewInspector
import SwiftUI

struct AXElement: CustomDumpReflectable {
    var values: [(label: String?, value: Any)]
    
    static func walk<V: View>(view: V) -> [AXElement] {
        let vc = UIHostingController(rootView: view)
//        vc.view.frame = CGRect(x: 0, y: 0, width: 300, height: 3000)
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 300, height: 3000))
        window.rootViewController = vc
        window.makeKeyAndVisible()
        let children = walk(accessibilityElements: vc.view.accessibilityElements) ?? []
        window.resignKey()
        return children
    }
    
    static func walk(accessibilityElements: [Any]?) -> [AXElement]? {
        guard let accessibilityElements = accessibilityElements else { return nil }
        let children: [AXElement] = accessibilityElements.compactMap { any in
            guard let el = any as? NSObject,
                  el.isAccessibilityElement
            else { return nil }
            let m = Mirror(reflecting: any)
            let optionals: [(label: String?, value: Any?)] = [
                ("label", el.accessibilityLabel),
                ("hint", el.accessibilityHint),
                ("value", el.accessibilityValue),
                ("traits", el.accessibilityTraits.isEmpty ? nil : el.accessibilityTraits),
//                ("frame", el.accessibilityFrame == .zero ? nil : el.accessibilityFrame),
                // accessibilityPath: UIBezierPath?
                // accessibilityActivationPoint: CGPoint
                // accessibilityLanguage: String?
                ("elementsHidden", el.accessibilityElementsHidden ? true : nil), // : Bool
                ("viewIsModal", el.accessibilityViewIsModal ? true : nil), //: Bool
                ("shouldGroupAccessibilityChildren", el.shouldGroupAccessibilityChildren ? true : nil), // : Bool
                // accessibilityNavigationStyle: UIAccessibilityNavigationStyle
                // accessibilityRespondsToUserInteraction: Bool
                // accessibilityUserInputLabels: [String]!
                // accessibilityAttributedUserInputLabels: [NSAttributedString]!
                // accessibilityTextualContext: UIAccessibilityTextualContext?
                // accessibilityCustomActions: [UIAccessibilityCustomAction]?
                // accessibilityDragSourceDescriptors: [UIAccessibilityLocationDescriptor]?
                // accessibilityDropPointDescriptors: [UIAccessibilityLocationDescriptor]?
                // accessibilityCustomRotors: [UIAccessibilityCustomRotor]?
                // accessibilityContainerType: UIAccessibilityContainerType
                ("children", walk(accessibilityElements: m["children"] as? [Any])),
            ]
            return AXElement(
                values: optionals.compactMap({ (label, value) in value.map { (label, $0) } })
            )
        }
        return children.isEmpty ? nil : children
    }
    
    var customDumpMirror: Mirror {
        Mirror(self, children: values, displayStyle: .struct)
    }
}

class AXTests: XCTestCase {
    var v: some View {
        VStack {
            Text("ax_text")
            HStack {
                Button("ax_button") {}
                    .accessibilityLabel("ax_button_label")
            }
        }
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
        XCTAssertEqual(try v.inspect().vStack().text(0).string(), "ax_text")
        customDump(nsax1, maxDepth: 1)
        print("NSAX1:")
        print(nsax1.isAccessibilityElement)
        print(nsax1.accessibilityLabel)
        print(nsax1.accessibilityValue)
        print(nsax1.accessibilityHint)
        print(nsax1.accessibilityFrame)
    }
    
    func test3() {
        customDump(AXElement.walk(view: v))
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

extension UIAccessibilityTraits: CustomDumpStringConvertible {
    public var customDumpDescription: String {
        var array: [String] = []
        if contains(.button) { array.append(".button") }
        if contains(.link) { array.append(".link") }
        if contains(.header) { array.append(".header") }
        if contains(.searchField) { array.append(".searchField") }
        if contains(.image) { array.append(".image") }
        if contains(.selected) { array.append(".selected") }
        if contains(.playsSound) { array.append(".playsSound") }
        if contains(.keyboardKey) { array.append(".keyboardKey") }
        if contains(.staticText) { array.append(".staticText") }
        if contains(.summaryElement) { array.append(".summaryElement") }
        if contains(.notEnabled) { array.append(".notEnabled") }
        if contains(.updatesFrequently) { array.append(".updatesFrequently") }
        if contains(.startsMediaSession) { array.append(".startsMediaSession") }
        if contains(.adjustable) { array.append(".adjustable") }
        if contains(.allowsDirectInteraction) { array.append(".allowsDirectInteraction") }
        if contains(.causesPageTurn) { array.append(".causesPageTurn") }
        if contains(.tabBar) { array.append(".tabBar") }
        return array.joined(separator: ", ")
    }
}
