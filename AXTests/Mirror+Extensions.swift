import UIKit

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
