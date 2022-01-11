import CustomDump

public func find(_ predicate: String, in any: Any) -> Trace? {
    find(any: any, path: [], parents: [], predicate: predicate)
}

public func trace(path: String, in any: Any) -> Trace? {
    let paths = path.split(separator: ".").map(String.init)
    return trace(path: paths, in: any, idx: 0)
}

// MARK: -

public enum Trace: CustomStringConvertible, Equatable {
    indirect case parent(subject: Any, label: String, next: Trace)
    case leaf(value: Any)
    
    public var description: String {
        buildString(indent: 0)
    }
    
    public var path: String {
        paths.joined(separator: ".")
    }
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.description == rhs.description
    }
    
    private func buildString(indent: Int) -> String {
        switch self {
        case .parent(let subject, let label, let next):
            return """
            \(type(of: subject))
            \(String(repeating: " ", count: indent * 2))\(label): \(next.buildString(indent: indent + 1))
            """
        case .leaf(let value):
            var str = ""
            customDump(value, to: &str)
            return str
        }
    }
    
    private var paths: [String] {
        switch self {
        case .parent(_, let label, let next):
            return [label] + next.paths
        case .leaf(_):
            return []
        }
    }
}

// MARK: -

private func find(any: Any, path: [String], parents: Set<ObjectIdentifier>, predicate: String) -> Trace? {
    guard avoidRecursion(any, parents) else {
        return nil
    }
    let m = Mirror(reflecting: any)
    let children = Array(m.allChildren)
    if children.isEmpty {
        var output = ""
        customDump(any, to: &output)
        guard output.contains(predicate) else {
            return nil
        }
        return .leaf(value: any)
    } else {
//        var founds: Trace? = nil
        for case let (idx, (label, child)) in zip(0..., children) {
            let newPath: String = label ?? "\(idx)"
            let trace = find(
                any: child,
                path: path + [newPath],
                parents: objIDs(parents, adding: any),
                predicate: predicate
            )
            if let next = trace {
                return .parent(subject: any, label: newPath, next: next)
            }
        }
        return nil
    }
}

// return true if safe
private func avoidRecursion(_ any: Any, _ parents: Set<ObjectIdentifier>) -> Bool {
//    guard parents.count < 10 else { return false }
    guard let id = objID(any) else { return true }
    return !parents.contains(id)
}

func objIDs(_ other: Set<ObjectIdentifier>, adding any: Any) -> Set<ObjectIdentifier> {
    guard let id = objID(any) else { return other }
    return other.union([id])
}

func objID(_ any: Any) -> ObjectIdentifier? {
    let m = Mirror(reflecting: any)
    guard case .class = m.displayStyle else { return nil }
    return ObjectIdentifier(any as AnyObject)
}

// MARK: -

private func trace(path: [String], in any: Any, idx: Int) -> Trace? {
    if idx == path.endIndex {
        return .leaf(value: any)
    }
    let m = Mirror(reflecting: any)
    let children = Array(m.allChildren)
    guard !children.isEmpty else {
//        print(" children empty")
        return nil
    }
    let firstPath = path[idx]
    if let num = Int(firstPath) {
//        print("Finding \(num)")
        // may have multiple children with no labels
        let child = children[num]
        guard let next = trace(path: path, in: child.value, idx: idx + 1) else {
            return nil
        }
        return .parent(subject: any, label: firstPath, next: next)
//        let foundChild = children
//            .filter({ $0.label == nil })
//            .compactMap({ trace(path: path, in: $0.value, idx: idx + 1) })
//            .first
//        return foundChild
    }
    guard let child = children.first(where: { $0.label == firstPath }) else {
        return nil
    }
    if let childTrace = trace(path: path, in: child.value, idx: idx + 1) {
        return .parent(subject: any, label: firstPath, next: childTrace)
    } else {
        return nil
    }
}
