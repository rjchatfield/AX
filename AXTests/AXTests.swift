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
    var style: AXElement.Style
    
    enum Style {
        case staticText
        case button
        case image
        case unknown
    }
    
    private static func make(any: Any) -> AXElement? {
        guard let obj = any as? NSObject else {
            return AXElement(
                values: [
                    ("unknown", type(of: any)),
                ],
                style: .unknown
            )
        }
        guard obj.isAccessibilityElement else {
//            return nil
            print("Not Accessible:")
            customDump(any)
            dump(obj)
            return AXElement(
                values: [
                    ("notAccessible", type(of: any)),
                ],
                style: .unknown
            )
        }
        var traits = obj.accessibilityTraits
        let style: Style = {
            if let _ = traits.remove(.button) { return .button }
            if let _ = traits.remove(.staticText) { return .staticText }
            if let _ = traits.remove(.image) { return .image }
            if any is UIButton { return .button }
            if any is UILabel { return .staticText }
            return .unknown
        }()

        let elId = any as? UIAccessibilityIdentification
        func nonEmpty(_ arr: [Any]?) -> [Any]? { arr?.isEmpty == true ? nil : arr }
        func ifTrue(_ bool: Bool) -> Bool? { bool ? true : nil }
        var optionals: [(label: String?, value: Any?)] = [
            ("identifier", elId?.accessibilityIdentifier),
            ("label", obj.accessibilityLabel),
            ("hint", obj.accessibilityHint),
            ("value", obj.accessibilityValue),
            ("traits", traits.isEmpty ? nil : traits),
//                ("frame", el.accessibilityFrame == .zero ? nil : el.accessibilityFrame),
            // accessibilityPath: UIBezierPath?
            // accessibilityActivationPoint: CGPoint
            // accessibilityLanguage: String?
            ("elementsHidden", ifTrue(obj.accessibilityElementsHidden)), // : Bool
            ("viewIsModal", ifTrue(obj.accessibilityViewIsModal)), //: Bool
            ("shouldGroupAccessibilityChildren", ifTrue(obj.shouldGroupAccessibilityChildren)), // : Bool
            ("navigationStyle", obj.accessibilityNavigationStyle == .automatic ? nil : obj.accessibilityNavigationStyle), //: UIAccessibilityNavigationStyle
//            ("respondsToUserInteraction", ifTrue(el.accessibilityRespondsToUserInteraction)), // : Bool
            ("userInputLabels", nonEmpty(obj.accessibilityUserInputLabels)), // : [String]!
//            ("attributedUserInputLabels", el.accessibilityAttributedUserInputLabels), // : [NSAttributedString]!
            ("textualContext", obj.accessibilityTextualContext), // : UIAccessibilityTextualContext?
            ("customActions", obj.accessibilityCustomActions), // : [UIAccessibilityCustomAction]?
            ("dragSourceDescriptors", nonEmpty(obj.accessibilityDragSourceDescriptors)), // : [UIAccessibilityLocationDescriptor]?
            ("dropPointDescriptors", nonEmpty(obj.accessibilityDropPointDescriptors)), // : [UIAccessibilityLocationDescriptor]?
            ("customRotors", nonEmpty(obj.accessibilityCustomRotors)), // : [UIAccessibilityCustomRotor]?
            ("containerType", obj.accessibilityContainerType == .none ? nil : obj.accessibilityContainerType), // : UIAccessibilityContainerType
        ]
        
        var children: [Any]? {
            if let accessibilityElements = obj.accessibilityElements {
                return Self.walk(accessibilityElements: accessibilityElements)
            } else if let view = any as? UIView {
                return Self.walk(accessibilityElements: view.subviews)
            } else if let mirrorChildren = Mirror(reflecting: any)["children"] as? [Any] {
                return Self.walk(accessibilityElements: mirrorChildren)
            } else {
                return nil
            }
        }
        optionals.append(("children", children))
                        
        let el = AXElement(
            values: optionals.compactMap({ (label, value) in value.map { (label, $0) } }),
            style: style
        )
        
        if el.values.isEmpty {
            print("🧐 NO ACCESSIBILITY PROPERTIES?")
            customDump(any)
            let m = Mirror(reflecting: any)
            for (label, value) in m.children {
                print("", label ?? "<nil>", value)
            }
        }
        
        return el
    }
    
    static func walk<V: View>(view: V) -> [AXElement] {
        let frame = CGRect(x: 0, y: 0, width: 300, height: 3000)
        let viewController = UIHostingController(rootView: view)
//        viewController.view.frame = frame
        let window = UIWindow(frame: frame)
        
        // vvv FROM SNAPSHOT
        let rootViewController = UIViewController()
        rootViewController.view.backgroundColor = .clear
        rootViewController.view.frame = window.frame
        rootViewController.view.translatesAutoresizingMaskIntoConstraints =
          viewController.view.translatesAutoresizingMaskIntoConstraints
        rootViewController.preferredContentSize = rootViewController.view.frame.size
        viewController.view.frame = rootViewController.view.frame
        rootViewController.view.addSubview(viewController.view)
        if viewController.view.translatesAutoresizingMaskIntoConstraints {
          viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        } else {
          NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: rootViewController.view.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: rootViewController.view.bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: rootViewController.view.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: rootViewController.view.trailingAnchor),
          ])
        }
        rootViewController.addChild(viewController)

//        rootViewController.setOverrideTraitCollection(traits, forChild: viewController)
        viewController.didMove(toParent: rootViewController)

        window.rootViewController = rootViewController

        rootViewController.beginAppearanceTransition(true, animated: false)
        rootViewController.endAppearanceTransition()

        rootViewController.view.setNeedsLayout()
        rootViewController.view.layoutIfNeeded()

        viewController.view.setNeedsLayout()
        viewController.view.layoutIfNeeded()
        // ^^^ FROM SNAPSHOT
        
//        // Try to call sizeToFit() if the view still has invalid size
//        viewController.view.sizeToFit()
//        viewController.view.setNeedsLayout()
//        viewController.view.layoutIfNeeded()

//        window.rootViewController = vc
//        window.makeKeyAndVisible()
        print(rootViewController.view.frame)
        let children = walk(accessibilityElements: viewController.view.accessibilityElements) ?? []
        
//        window.resignKey()
        // vvv FROM SNAPSHOT
        rootViewController.beginAppearanceTransition(false, animated: false)
        rootViewController.endAppearanceTransition()
        window.rootViewController = nil
        // ^^^ FROM SNAPSHOT
        
        return children
    }
    
    static func walk(view: UIView) -> [AXElement] {
        guard let element = make(any: view) else { return [] }
        return [element]
    }
    
    private static func walk(accessibilityElements: [Any]?) -> [AXElement]? {
        guard let accessibilityElements = accessibilityElements else { return nil }
        let children = accessibilityElements.compactMap(make(any:))
        return children.isEmpty ? nil : children
    }
    
    var customDumpMirror: Mirror {
        func makeMirror<Subject>(_ subject: Subject) -> Mirror {
            Mirror(subject, children: values, displayStyle: .struct)
        }
        // Tick to make a Button look like a button
        switch style {
        case .button:
            return makeMirror(Button("") {})
        case .staticText:
            return makeMirror(Text(""))
        case .image:
            return makeMirror(Image(systemName: ""))
        case .unknown:
            return makeMirror(self)
        }
    }
}

class AXTests: XCTestCase {
    var v: some View {
        VStack {
//        List {
//        LazyVStack {
            Text("ax_text")
            Section {
                Button("ax_button_1") {}
                    .accessibilitySortPriority(-1) // after everything
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
                Label("ax_label_title", systemImage: "ax_label_systemImageName")
                
                Image(systemName: "ax_image_systemName")
                
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
        let v = UIStackView(arrangedSubviews: [
            label,
            section,
        ])
        customDump(AXElement.walk(view: v))
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

extension UIAccessibilityContainerType: CustomDumpStringConvertible {
    public var customDumpDescription: String {
        switch self {
        case .none: return ".none"
        case .dataTable: return ".dataTable"
        case .list: return ".list"
        case .landmark: return ".landmark"
        case .semanticGroup: return ".semanticGroup"
        @unknown default:
            return ".unknown⚠️"
        }
    }
}

extension UIAccessibilityNavigationStyle: CustomDumpStringConvertible {
    public var customDumpDescription: String {
        switch self {
        case .automatic: return ".automatic"
        case .separate: return ".separate"
        case .combined: return ".combined"
        @unknown default:
            return ".unknown⚠️"
        }
    }
}

extension UIAccessibilityTextualContext: CustomDumpStringConvertible {
    public var customDumpDescription: String {
        switch self {
        case .wordProcessing: return ".wordProcessing"
        case .narrative: return ".narrative"
        case .messaging: return ".messaging"
        case .spreadsheet: return ".spreadsheet"
        case .fileSystem: return ".fileSystem"
        case .sourceCode: return ".sourceCode"
        case .console: return ".console"
        default:
            return ".unknown⚠️"
        }
    }
}

//extension UIAccessibilityCustomAction: CustomDumpReflectable {
//    public var customDumpMirror: Mirror {
//        Mirror(self, children: [("name", name)], displayStyle: .struct)
//    }
//}
extension UIAccessibilityCustomAction: CustomDumpStringConvertible {
    public var customDumpDescription: String {
        name
    }
}
