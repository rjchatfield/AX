@testable import CustomDump
import UIKit

/// Dumps the given value's contents using its mirror to the specified output stream.
///
/// - Parameters:
///   - value: The value to output to the `target` stream.
///   - target: The stream to use for writing the contents of `value`.
///   - name: A label to use when writing the contents of `value`. When `nil` is passed, the label
///     is omitted. The default is `nil`.
///   - indent: The number of spaces to use as an indent for each line of the output. The default is
///     `0`.
///   - maxDepth: The maximum depth to descend when writing the contents of a value that has nested
///     components. The default is `Int.max`.
/// - Returns: The instance passed as `value`.
@discardableResult
func _customDump<T, TargetStream>(
    _ value: T,
    to target: inout TargetStream,
    name: String? = nil,
    indent: Int = 0,
    maxDepth: Int = .max
) -> T where TargetStream: TextOutputStream {
    
    var visitedItems: Set<ObjectIdentifier> = []
    
    func customDumpHelp<T, TargetStream>(
        _ value: T,
        to target: inout TargetStream,
        name: String?,
        indent: Int,
        maxDepth: Int
    ) where TargetStream: TextOutputStream {
        if T.self is AnyObject.Type, withUnsafeBytes(of: value, { $0.allSatisfy { $0 == 0 } }) {
            target.write((name.map { "\($0): " } ?? "").appending("(null pointer)").indenting(by: indent))
            return
        }
        
        let mirror = Mirror.customDumpValue(reflecting: value)
        var out = ""
        
        func dumpChildren(
            of mirror: CustomDumpValue,
            prefix: String,
            suffix: String,
            by areInIncreasingOrder: ((Mirror.Child, Mirror.Child) -> Bool)? = nil,
            _ transform: (inout Mirror.Child, Int) -> Void = { _, _ in }
        ) {
            out.write(prefix)
            if !mirror.children.isEmpty {
                if mirror.isSingleValueContainer {
                    var childOut = ""
                    let child = mirror.children.first!
                    customDumpHelp(
                        child.value, to: &childOut, name: child.label, indent: 0, maxDepth: maxDepth - 1
                    )
                    if childOut.contains("\n") {
                        if maxDepth == 0 {
                            out.write("…")
                        } else {
                            out.write("\n")
                            out.write(childOut.indenting(by: 2))
                            out.write("\n")
                        }
                    } else {
                        out.write(childOut)
                    }
                } else if maxDepth == 0 {
                    out.write("…")
                } else {
                    out.write("\n")
                    var children = Array(mirror.children)
                    if let areInIncreasingOrder = areInIncreasingOrder {
                        children.sort(by: areInIncreasingOrder)
                    }
                    for (offset, var child) in children.enumerated() {
                        transform(&child, offset)
                        customDumpHelp(
                            child.value, to: &out, name: child.label, indent: 2, maxDepth: maxDepth - 1)
                        if offset != children.count - 1 {
                            out.write(",")
                        }
                        out.write("\n")
                    }
                }
            }
            out.write(suffix)
        }
        
        switch (value, mirror.displayStyle) {
        case let (value as Any.Type, _):
            out.write("\(typeName(value)).self")
            
        case let (value as CustomDumpStringConvertible, _):
            out.write(value.customDumpDescription)
            
        case let (value as CustomDumpRepresentable, _):
            customDumpHelp(value.customDumpValue, to: &out, name: nil, indent: 0, maxDepth: maxDepth - 1)
            
        case let (value as AnyObject, .class?):
            let item = ObjectIdentifier(value)
            if visitedItems.contains(item) {
                out.write("\(mirror.typeName)(↩︎)")
            } else {
                visitedItems.insert(item)
                dumpChildren(of: mirror, prefix: "\(mirror.typeName)(", suffix: ")")
            }
            
        case (_, .collection?):
            dumpChildren(of: mirror, prefix: "[", suffix: "]", { $0.label = "[\($1)]" })
            
        case (_, .dictionary?):
            if mirror.children.isEmpty {
                out.write("[:]")
            } else {
                dumpChildren(
                    of: mirror,
                    prefix: "[", suffix: "]",
                    by: {
                        guard
                            let (lhsKey, _) = $0.value as? (key: AnyHashable, value: Any),
                            let (rhsKey, _) = $1.value as? (key: AnyHashable, value: Any)
                        else { return false }
                        
                        return _customDump(lhsKey.base, name: nil, indent: 0, maxDepth: 1)
                        < _customDump(rhsKey.base, name: nil, indent: 0, maxDepth: 1)
                    },
                    { child, _ in
                        guard let pair = child.value as? (key: AnyHashable, value: Any) else { return }
                        let key = _customDump(pair.key.base, name: nil, indent: 0, maxDepth: maxDepth - 1)
                        child = (key, pair.value)
                    })
            }
            
        case (_, .enum?):
            //      out.write("\(typeName(mirror.subjectType)).")
            out.write("\(mirror.typeName).")
            if let child = mirror.children.first {
                let childMirror = Mirror.customDumpValue(reflecting: child.value)
                let associatedValuesMirror =
                childMirror.displayStyle == .tuple
                ? childMirror
                : Mirror(value, unlabeledChildren: [child.value], displayStyle: .tuple).customDumpValue
                dumpChildren(
                    of: associatedValuesMirror,
                    prefix: "\(child.label ?? "@unknown")(",
                    suffix: ")",
                    { child, _ in
                        if child.label?.first == "." {
                            child.label = nil
                        }
                    }
                )
            } else {
                out.write("\(value)")
            }
            
        case (_, .optional?):
            if let value = mirror.children.first?.value {
                customDumpHelp(value, to: &out, name: nil, indent: 0, maxDepth: maxDepth)
            } else {
                out.write("nil")
            }
            
        case (_, .set?):
            dumpChildren(
                of: mirror,
                prefix: "Set([", suffix: "])",
                by: {
                    _customDump($0.value, name: nil, indent: 0, maxDepth: 1)
                    < _customDump($1.value, name: nil, indent: 0, maxDepth: 1)
                })
            
        case (_, .struct?):
//            dumpChildren(of: mirror, prefix: "\(typeName(mirror.subjectType))(", suffix: ")")
            dumpChildren(of: mirror, prefix: "\(mirror.typeName)(", suffix: ")")
            
        case (_, .tuple?):
            dumpChildren(
                of: mirror,
                prefix: "(",
                suffix: ")",
                { child, _ in
                    if child.label?.first == "." {
                        child.label = nil
                    }
                })
            
        default:
            if let value = stringFromStringProtocol(value) {
                if value.contains(where: \.isNewline) {
                    if maxDepth == 0 {
                        out.write("\"…\"")
                    } else {
                        let hashes = String(repeating: "#", count: value.hashCount)
                        out.write("\(hashes)\"\"\"")
                        out.write("\n")
                        print(value.indenting(by: name != nil ? 2 : 0), to: &out)
                        out.write(name != nil ? "  \"\"\"\(hashes)" : "\"\"\"\(hashes)")
                    }
                } else {
                    out.write(value.debugDescription)
                }
            } else {
                out.write("\(value)")
            }
        }
        
        target.write((name.map { "\($0): " } ?? "").appending(out).indenting(by: indent))
    }
    
    customDumpHelp(value, to: &target, name: name, indent: indent, maxDepth: maxDepth)
    return value
}

func _customDump(_ value: Any, name: String?, indent: Int, maxDepth: Int) -> String {
    var out = ""
    customDump(value, to: &out, name: name, indent: indent, maxDepth: maxDepth)
    return out
}

// MARK: - CustomDumpValue

struct CustomDumpValue {
    let typeName: String
    let children: [Mirror.Child]
    let displayStyle: Mirror.DisplayStyle?
}

extension CustomDumpValue {
    var isSingleValueContainer: Bool {
      switch self.displayStyle {
      case .collection?, .dictionary?, .set?:
        return false
      default:
        guard
          self.children.count == 1,
          let child = self.children.first
        else { return false }
        var value = child.value
        while let representable = value as? CustomDumpRepresentable {
          value = representable.customDumpValue
        }
        if let convertible = child.value as? CustomDumpStringConvertible {
          return !convertible.customDumpDescription.contains("\n")
        }
        return Mirror(customDumpReflecting: value).children.isEmpty
      }
    }
}

protocol CustomDumpValuable {
    var customDumpValue: CustomDumpValue { get }
}

extension Mirror {
    var customDumpValue: CustomDumpValue {
        CustomDumpValue(
            typeName: typeName(subjectType),
            children: Array(children),
            displayStyle: displayStyle
        )
    }
}

extension Mirror {
    static func customDumpValue(reflecting subject: Any) -> CustomDumpValue {
        if let customDumpValue = (subject as? CustomDumpValuable)?.customDumpValue {
            return customDumpValue
        } else {
            return Mirror(customDumpReflecting: subject).customDumpValue
        }
    }
}

extension UIView: CustomDumpValuable {
    var customDumpValue: CustomDumpValue {
        let m = Mirror(reflecting: self)
        return CustomDumpValue(
            typeName: "\(type(of: self))",
            children: Array(m.children),
            displayStyle: .struct
        )
    }
}
