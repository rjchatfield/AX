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

}
