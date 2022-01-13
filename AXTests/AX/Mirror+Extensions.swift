import UIKit

extension Mirror {
    
    /// `Mirror(_: Any)` will print as `Any`. This will print proper underlying type.
    static func make(any: Any, children: [(label: String?, value: Any)]) -> Mirror {
        func _makeMirror<T>(t: T) -> Mirror { Mirror(t, children: children, displayStyle: .struct) }
        return _openExistential(any, do: _makeMirror(t:))
    }

    subscript(label: String) -> Any? {
        allChildren.first(where: { $0.label == label })?.value
    }
    
    var allChildren: AnySequence<(label: String?, value: Any)> {
        AnySequence(
            sequence(first: self, next: \.superclassMirror)
                .reversed()
                .flatMap(\.children)
        )
    }
}

extension NSObject {
    subscript(mirroring label: String) -> Any? {
        Mirror(reflecting: self)[label]
    }
}
