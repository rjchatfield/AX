import CustomDump
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
//        guard obj.isAccessibilityElement else {
////            return nil
//            print("Not Accessible:")
//            customDump(any)
//            dump(obj)
//            return AXElement(
//                values: [
//                    ("notAccessible", type(of: any)),
//                ],
//                style: .unknown
//            )
//        }
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
