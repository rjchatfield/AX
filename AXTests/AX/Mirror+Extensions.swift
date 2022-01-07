import UIKit

extension Mirror {
    
    /// `Mirror(_: Any)` will print as `Any`. This will print proper underlying type.
    static func make(any: Any, children: [(label: String?, value: Any)]) -> Mirror {
        func _makeMirror<T>(t: T) -> Mirror { Mirror(t, children: children, displayStyle: .struct) }
        return _openExistential(any, do: _makeMirror(t:))
    }

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
