import SwiftUI
import SnapshotTesting
import CustomDump

// MARK: - Accessibility elements

extension Snapshotting where Value: SwiftUI.View, Format == String {
    static var accessibilityElements: Snapshotting {
        Snapshotting<Any, String>.customDump
            .pullback { (view: Value) -> Any in
                AXElement.walk(view: view)
            }
    }
    
    static var voiceOver: Snapshotting {
        Snapshotting<Any, String>.customDump
            .pullback { (view: Value) -> Any in
                "TODO: voiceOver elements"
            }
    }
    
    static func findingInView(_ predicate: String) -> Snapshotting {
        Snapshotting<Any, String>.finding(predicate)
            .pullback { view -> Any in
                let frame = CGRect(x: 0, y: 0, width: 300, height: 3000)
                let viewController = UIHostingController(rootView: view)
                viewController.view.frame = frame
                return viewController.view?.accessibilityElements ?? []
            }
    }
    
    static var presentedAccessibilityElements: Snapshotting {
        Snapshotting<Any, String>.customDump
            .pullback { (view: Value) -> Any in
                let vc = UIHostingController(rootView: view)
                let dispose = UIWindow.prepare(viewController: vc, frame: .init(x: 0, y: 0, width: 300, height: 3000))
                defer { dispose() }
                guard let presentedView = vc.presentedViewController?.view else {
                    return "<no presentedViewController>"
                }
                return AXElement.walk(view: presentedView)
            }
    }

}

extension Snapshotting where Value: UIView, Format == String {
    static var accessibilityElements: Snapshotting {
        Snapshotting<Any, String>.customDump
            .pullback { (view: Value) -> Any in
                AXElement.walk(view: view)
            }
    }
    
    static var voiceOver: Snapshotting {
        Snapshotting<Any, String>.customDump
            .pullback { (view: Value) -> Any in
                "TODO: voiceOver elements"
            }
    }
}

// MARK: - Custom Dump

extension Snapshotting where Value == Any, Format == String {
    static var customDump: Snapshotting {
        customDump()
    }
    
    static func customDump(maxDepth: Int = .max) -> Snapshotting {
        Snapshotting<String, String>.lines
            .pullback { any -> String in
                var result = ""
                _customDump(any, to: &result, maxDepth: maxDepth)
                return result
            }
    }
    
    static func finding(_ predicate: String) -> Snapshotting {
        Snapshotting<String, String>.lines
            .pullback { any -> String in
                guard let trace = find(predicate, in: any) else { return "<not found>" }
                return trace.description
            }
    }
}

// MARK: NSObject

extension Snapshotting where Value == NSObject, Format == String {
    static var allSelectors: Snapshotting {
        Snapshotting<Any, String>.customDump
            .pullback { obj -> Any in
                obj.allSelectors
            }
    }
}
