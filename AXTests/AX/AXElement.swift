import CustomDump
import SwiftUI

@dynamicMemberLookup
struct AXElement {
    var subject: Any
    var values: [(label: String?, value: Any)]
    var style: AXElement.Style

    // For debugging
    func value<T>(at idx: Int, as: T.Type) -> T {
        values[idx].value as! T
    }
    
    // For debugging
    func value(_ idx: Int = 0, axElement subIdx: Int) -> AXElement {
        value(at: idx, as: [AXElement].self)[subIdx]
    }
    
    // For debugging
    func subject<T>(as: T.Type) -> T {
        subject as! T
    }

    // For debugging
    func axElements(at idx: Int) -> [AXElement] {
        values[idx].value as! [AXElement]
    }
    
    // For debugging
    subscript(label: String) -> Any? {
        values.first(where: { $0.label == label })?.value
    }
    
    // For debugging
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
            subject: (),
            values: [("failure", reason)],
            style: .unknown(subject)
        )
    }
    
    private static func make(any: Any) -> [AXElement] {
        Wrapper(any: any).elements
    }
    
    static func walk<V: View>(view: V) -> [AXElement] {
        let frame = CGRect(x: 0, y: 0, width: 300, height: 3000)
        let viewController = UIHostingController(rootView: view)
        let nav = UINavigationController(rootViewController: viewController)
        nav.view.frame = frame
        let children = walk(accessibilityElements: viewController.view.accessibilityElements) ?? []
        return children
    }
    
    static func walk<V: UIView>(view: V) -> [AXElement] {
        make(any: view)
    }
    
    private static func walk(accessibilityElements: [Any]?) -> [AXElement]? {
        guard let accessibilityElements = accessibilityElements else { return nil }
        let children = accessibilityElements.flatMap(make(any:))
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
        
        var elements: [AXElement] {
            let element = AXElement(subject: any, values: values, style: style)
            if element.values.isEmpty, !obj.isAccessibilityElement {
                return []
            } else if element.values.count == 1,
                        case ("accessibilityElements"?, let anys)? = element.values.first,
                        let children = anys as? [AXElement] {
                return children
            } else if element.values.count == 1,
                        case ("subviews"?, let anys)? = element.values.first,
                        let children = anys as? [AXElement] {
                return children
            }
            return [element]
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
                ("isEnabled", isEnabled),
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
                ("customContent", accessibilityCustomContent),
//                ("children", accessibilityChildren),
                ("accessibilityElements", accessibilityElements),
                ("subviews", subviews),
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
            if any is UIView {
                if any is UIButton { return .button }
                if any is UILabel { return .staticText }
                if any is UIImageView { return .image }
            } else {
                // NSObject or SwiftUI
                let traits = obj.accessibilityTraits
                if traits.contains(.button) { return .button }
                if traits.contains(.staticText) { return .staticText }
                if traits.contains(.image) { return .image }
            }
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
//                ?? uiButton.map { $0.title(for: .normal) ?? "" }
        }
        var accessibilityHint: Any? { obj.accessibilityHint }
        var accessibilityValue: Any? {
            obj.accessibilityValue
                ?? uiTextField.flatMap { nonEmpty($0.text) ?? nonEmpty($0.placeholder) }
                ?? uiTextView.flatMap { nonEmpty($0.text) }
        }
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
        
        var accessibilityElements: [AXElement]? {
            AXElement.walk(accessibilityElements: obj.accessibilityElements)
        }
        
        var subviews: [AXElement]? {
            if isLeafAXView { return nil }
            if accessibilityElements != nil { return nil }
            return AXElement.walk(
                accessibilityElements: uiView?.subviews.filter({ !$0.isHidden })
            )
        }
        
//        var accessibilityChildren: [Any]? {
//            if let accessibilityElements = obj.accessibilityElements {
//                return AXElement.walk(accessibilityElements: accessibilityElements)
//            } else if let view = any as? UIView {
//                return AXElement.walk(accessibilityElements: view.subviews)
//            } else if let mirrorChildren = mirror["children"] as? [Any] {
//                return AXElement.walk(accessibilityElements: mirrorChildren)
//            } else {
//                return nil
//            }
//        }
        
        var accessibilityCustomContent: [AXCustomContent]? {
            guard let customContentProvider = obj as? AXCustomContentProvider else { return nil }
            return nonEmpty(customContentProvider.accessibilityCustomContent)
        }
        
        var isEnabled: Bool? {
            ifFalse(uiControl?.isEnabled)
        }
        
        var uiView: UIView? { any as? UIView }
        var uiControl: UIControl? { any as? UIControl }
        var uiLabel: UILabel? { any as? UILabel }
        var uiButton: UIButton? { any as? UIButton }
        var uiTextField: UITextField? { any as? UITextField }
        var uiTextView: UITextView? { any as? UITextView }
        
        var isLeafAXView: Bool {
            return obj.isAccessibilityElement
                || any is UILabel
                || any is UIButton
                || any is UITextField
                || any is UITextView
                // TODO: find all the Views that are accessibilityElement
        }

        private func nonEmpty<Col: Collection>(_ arr: Col?) -> Col? { arr?.isEmpty == true ? nil : arr }
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
        window.makeKeyAndVisible()

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
            window.resignKey()
            
            rootViewController.beginAppearanceTransition(false, animated: false)
            rootViewController.endAppearanceTransition()
            window.rootViewController = nil
        }
    }
}

extension UIAccessibilityTraits: CustomDumpStringConvertible {
    public var customDumpDescription: String {
        let known: [(UIAccessibilityTraits, String)] = [
            (.button, ".button"),
            (.link, ".link"),
            (.header, ".header"),
            (.searchField, ".searchField"),
            (.image, ".image"),
            (.selected, ".selected"),
            (.playsSound, ".playsSound"),
            (.keyboardKey, ".keyboardKey"),
            (.staticText, ".staticText"),
            (.summaryElement, ".summaryElement"),
            (.notEnabled, ".notEnabled"),
            (.updatesFrequently, ".updatesFrequently"),
            (.startsMediaSession, ".startsMediaSession"),
            (.adjustable, ".adjustable"),
            (.allowsDirectInteraction, ".allowsDirectInteraction"),
            (.causesPageTurn, ".causesPageTurn"),
            (.tabBar, ".tabBar"),
        ]
        var this = self
        var names = known.compactMap { this.remove($0.0) != nil ? $0.1 : nil }
        if !this.isEmpty {
            // The option set has been stripped of all publicly known cases, but is still not empty
            names.append("<private>")
        }
        return names.joined(separator: ", ")
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

extension AXCustomContent: CustomDumpReflectable {
    public var customDumpMirror: Mirror {
        var children: [Mirror.Child] = [(label, value)]
        if importance != .default {
            children.append(("importance", importance))
        }
        return Mirror(self, children: children, displayStyle: .struct)
    }
}

extension AXCustomContent.Importance: CustomDumpStringConvertible {
    public var customDumpDescription: String {
        switch self {
        case .default: return ".default"
        case .high: return ".high"
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
