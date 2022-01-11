import CustomDump
import SwiftUI

@dynamicMemberLookup
struct AXElement {
    var values: [(label: String?, value: Any)]
    var style: AXElement.Style
    
    subscript(label: String) -> Any? {
        values.first(where: { $0.label == label })?.value
    }
    
    subscript(dynamicMember label: String) -> Any? {
        self[label]
    }
    
    enum Style {
        case staticText
        case button
        case image
        case unknown(Any)
        
        var unknownValue: Any? {
            guard case .unknown(let value) = self else { return nil }
            return value
        }
    }
    
    static func failure(_ reason: String, subject: Any) -> AXElement {
        AXElement(
            values: [("failure", reason)],
            style: .unknown(subject)
        )
    }
    
    private static func make(any: Any) -> AXElement? {
        Wrapper(any: any).element
    }
    
    static func walk<V: View>(view: V) -> [AXElement] {
        let frame = CGRect(x: 0, y: 0, width: 300, height: 3000)
        let viewController = UIHostingController(rootView: view)
        viewController.view.frame = frame
        let children = walk(accessibilityElements: viewController.view.accessibilityElements) ?? []
        return children
    }
    
    static func walk<V: UIView>(view: V) -> [AXElement] {
        guard let element = make(any: view) else { return [] }
        return [element]
    }
    
    private static func walk(accessibilityElements: [Any]?) -> [AXElement]? {
        guard let accessibilityElements = accessibilityElements else { return nil }
        let children = accessibilityElements.compactMap(make(any:))
//        { any -> AXElement? in
//            func _make<T>(t: T) -> AXElement? { Wrapper(any: t).element }
//            return _openExistential(any, do: _make(t:))
//        }
        return children.isEmpty ? nil : children
    }
}

extension AXElement: CustomDumpReflectable {
    var customDumpMirror: Mirror {
        func makeMirror(_ subject: Any) -> Mirror {
            Mirror.make(any: subject, children: values)
        }
        // Tick to make a Button look like a button
        switch style {
        case .button:
            return makeMirror(Button("") {})
        case .staticText:
            return makeMirror(Text(""))
        case .image:
            return makeMirror(Image(systemName: ""))
        case .unknown(let any):
            return makeMirror(any)
        }
    }

    var customDumpTypeName: String? {
        switch style {
        case .button: return "Button"
        case .staticText: return "Text"
        case .image: return "Image"
        case .unknown(let any): return "\(type(of: any))"
        }
    }
}

extension AXElement {
    final class Wrapper {
        init(any: Any) {
            self.any = any
        }
        
        let any: Any
        var obj: NSObject { (any as? NSObject) ?? NSObject() }
        lazy var mirror = Mirror(reflecting: any)
        
        var element: AXElement {
            AXElement(values: values, style: style)
        }
        
        var values: [(label: String?, value: Any)] {
            let optionals: [(label: String?, value: Any?)] = [
//                ("type", uiViewClass),
                ("identifier", accessibilityIdentifier),
                ("label", accessibilityLabel),
                ("hint", accessibilityHint),
                ("value", accessibilityValue),
                ("traits", accessibilityTraits),
    //                ("frame", el.accessibilityFrame == .zero ? nil : el.accessibilityFrame),
                // accessibilityPath: UIBezierPath?
                // accessibilityActivationPoint: CGPoint
                // accessibilityLanguage: String?
                ("elementsHidden", accessibilityElementsHidden),
                ("viewIsModal", accessibilityViewIsModal),
                ("shouldGroupAccessibilityChildren", shouldGroupAccessibilityChildren),
                ("navigationStyle", accessibilityNavigationStyle),
    //            ("respondsToUserInteraction", ifTrue(el.accessibilityRespondsToUserInteraction))
                ("userInputLabels", accessibilityUserInputLabels),
    //            ("attributedUserInputLabels", el.accessibilityAttributedUserInputLabels),
                ("textualContext", accessibilityTextualContext),
                ("customActions", accessibilityCustomActions),
                ("dragSourceDescriptors", accessibilityDragSourceDescriptors),
                ("dropPointDescriptors", accessibilityDropPointDescriptors),
                ("customRotors", accessibilityCustomRotors),
                ("containerType", accessibilityContainerType),
                ("headingLevel", accessibilityHeadingLevel),
                ("respondsToUserInteraction", accessibilityRespondsToUserInteraction),
                ("children", accessibilityChildren),
            ]
            
            let values = optionals.compactMap({ (label, value) in value.map { (label, $0) } })
            
            if values.isEmpty {
                print("🧐 NO ACCESSIBILITY PROPERTIES?")
                customDump(any)
                for (label, value) in mirror.children {
                    print("", label ?? "<nil>", value)
                }
            }
            
            return values
        }
        
        var style: Style {
            if any is UIView { return .unknown(any) }
            let traits = obj.accessibilityTraits
            if traits.contains(.button) { return .button }
            if traits.contains(.staticText) { return .staticText }
            if traits.contains(.image) { return .image }
            return .unknown(any)
        }
        
        var uiViewClass: Any? {
            (any is UIView)
                ? type(of: any)
                : nil
        }
        
        var accessibilityIdentifier: Any? { obj.value(forKey: "accessibilityIdentifier") }
        var accessibilityLabel: Any? {
            obj.accessibilityLabel
                ?? uiLabel.map { $0.text ?? "" } // If label, then default to empty string
                ?? uiButton?.title(for: .normal)
        }
        var accessibilityHint: Any? { obj.accessibilityHint }
        var accessibilityValue: Any? { obj.accessibilityValue }
        var accessibilityTraits: UIAccessibilityTraits? {
            let traits = obj.accessibilityTraits.subtracting([.staticText, .image, .button])
            return traits.isEmpty ? nil : traits
        }
        // ("frame", el.accessibilityFrame == .zero ? nil : el.accessibilityFrame),
        // accessibilityPath: UIBezierPath?
        // accessibilityActivationPoint: CGPoint
        // accessibilityLanguage: String?
        var accessibilityElementsHidden: Bool? { ifTrue(obj.accessibilityElementsHidden) }
        var accessibilityViewIsModal: Bool? { ifTrue(obj.accessibilityViewIsModal) }
        var shouldGroupAccessibilityChildren: Bool? { ifTrue(obj.shouldGroupAccessibilityChildren) }
        var accessibilityNavigationStyle: UIAccessibilityNavigationStyle? { obj.accessibilityNavigationStyle == .automatic ? nil : obj.accessibilityNavigationStyle }
        // ("respondsToUserInteraction", ifTrue(el.accessibilityRespondsToUserInteraction)), // : Bool
        var accessibilityUserInputLabels: [String]? { nonEmpty(obj.accessibilityUserInputLabels) }
        // ("attributedUserInputLabels", el.accessibilityAttributedUserInputLabels), // : [NSAttributedString]!
        var accessibilityTextualContext: UIAccessibilityTextualContext? { obj.accessibilityTextualContext }
        var accessibilityCustomActions: [UIAccessibilityCustomAction]? { obj.accessibilityCustomActions }
        var accessibilityDragSourceDescriptors: [UIAccessibilityLocationDescriptor]? { nonEmpty(obj.accessibilityDragSourceDescriptors) }
        var accessibilityDropPointDescriptors: [UIAccessibilityLocationDescriptor]? { nonEmpty(obj.accessibilityDropPointDescriptors) }
        var accessibilityCustomRotors: [UIAccessibilityCustomRotor]? { nonEmpty(obj.accessibilityCustomRotors) }
        var accessibilityContainerType: UIAccessibilityContainerType? { obj.accessibilityContainerType == .none ? nil : obj.accessibilityContainerType }
        
        var accessibilityHeadingLevel: Any? {
            nil // throws exception
//            obj.responds(to: Selector(("_accessibilityHeadingLevel")))
//                //? obj.value(forKey: "_accessibilityHeadingLevel")
//                ? obj.perform(Selector(("_accessibilityHeadingLevel")))
//                : nil
        }
        
        var accessibilityRespondsToUserInteraction: Bool? {
            nil // Too noisy
//            obj.value(forKey: "accessibilityRespondsToUserInteraction") as? Bool
        }
    
        var accessibilityChildren: [Any]? {
            if let accessibilityElements = obj.accessibilityElements {
                return AXElement.walk(accessibilityElements: accessibilityElements)
            } else if let view = any as? UIView {
                return AXElement.walk(accessibilityElements: view.subviews)
            } else if let mirrorChildren = mirror["children"] as? [Any] {
                return AXElement.walk(accessibilityElements: mirrorChildren)
            } else {
                return nil
            }
        }
        
        var uiLabel: UILabel? { any as? UILabel }
        var uiButton: UIButton? { any as? UIButton }

        private func nonEmpty<T>(_ arr: [T]?) -> [T]? { arr?.isEmpty == true ? nil : arr }
        private func ifTrue(_ bool: Bool?) -> Bool? { bool == true ? true : nil }
        private func ifFalse(_ bool: Bool?) -> Bool? { bool == false ? false : nil }
    }
}

extension UIWindow {
    
    static func prepare(viewController: UIViewController, frame: CGRect) -> (() -> Void) {
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
        
        return {
//            window.resignKey()
            
            rootViewController.beginAppearanceTransition(false, animated: false)
            rootViewController.endAppearanceTransition()
            window.rootViewController = nil
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

extension UIAccessibilityCustomRotor: CustomDumpReflectable {
    public var customDumpMirror: Mirror {
        let child: Mirror.Child = systemRotorType == .none
            ? ("custom", name)
            : ("systemRotorType", systemRotorType)
        return Mirror(self, children: [child], displayStyle: .struct)
    }
}

extension UIAccessibilityCustomRotor.SystemRotorType: CustomDumpStringConvertible {
    public var customDumpDescription: String {
        switch self {
        case .none: return ".none"
        case .link: return ".link"
        case .visitedLink: return ".visitedLink"
        case .heading: return ".heading"
        case .headingLevel1: return ".headingLevel1"
        case .headingLevel2: return ".headingLevel2"
        case .headingLevel3: return ".headingLevel3"
        case .headingLevel4: return ".headingLevel4"
        case .headingLevel5: return ".headingLevel5"
        case .headingLevel6: return ".headingLevel6"
        case .boldText: return ".boldText"
        case .italicText: return ".italicText"
        case .underlineText: return ".underlineText"
        case .misspelledWord: return ".misspelledWord"
        case .image: return ".image"
        case .textField: return ".textField"
        case .table: return ".table"
        case .list: return ".list"
        case .landmark: return ".landmark"
        @unknown default:
            return ".unknown⚠️"
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}
