import SwiftUI
import XCTest
import SnapshotTesting

final class UIKitAXTests: XCTestCase {
    
    func testLabelText() {
        let view = UILabel()
        view.text = "title"
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title"),
        ]
        """)
    }
    
    func testAXIdentifier() {
        let view = UILabel()
        view.text = "title"
        view.accessibilityIdentifier = "ax_identifier"
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(
            identifier: "ax_identifier",
            label: "title",
          ),
        ]
        """)
    }

    func testAXLabel() {
        let view = UILabel()
        view.text = "title"
        view.accessibilityLabel = "ax_label"
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "ax_label"),
        ]
        """)
    }

    func testAXHint() {
        let view = UILabel()
        view.text = "title"
        view.accessibilityHint = "ax_hint"
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(
            label: "title",
            hint: "ax_hint",
          ),
        ]
        """)
    }

//    func testAXHelp() {
////        let view = Text("title").help(Text("help"))
//        let view = UILabel()
//        view.text = "title"
//        view.help = "help"
//        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
//        [
//          [0]: Text(
//            label: "title",
//            hint: "help",
//          ),
//        ]
//        """)
//    }

//    func testAXHintThenHelp() {
//        let view = Text("title")
//            .accessibilityHint(Text("ax_hint"))
//            .help(Text("help"))
//        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
//        [
//          [0]: Text(
//            label: "title",
//            hint: "help",
//          ),
//        ]
//        """)
//    }
//    func testAXHintBeforeHelp() {
//        let view = Text("title")
//            .help(Text("help"))
//            .accessibilityHint(Text("ax_hint"))
//        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
//        [
//          [0]: Text(
//            label: "title",
//            hint: "ax_hint",
//          ),
//        ]
//        """)
//    }
//
    func testAXValue() {
        let view = UILabel()
        view.text = "title"
        view.accessibilityValue = "ax_value"
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(
            label: "title",
            value: "ax_value",
          ),
        ]
        """)
    }

    func testAXInputLabels() {
        let view = UILabel()
        view.text = "title"
        view.accessibilityUserInputLabels = ["ax_input_label1", "ax_input_label2"]
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(
            label: "title",
            userInputLabels: [
              [0]: "ax_input_label1",
              [1]: "ax_input_label2",
            ],
          ),
        ]
        """)
    }

    func testAXSubviews() {
        let label1 = UILabel()
        label1.text = "title1"
        let label2 = UILabel()
        label2.text = "title2"
        let label3 = UILabel()
        label3.text = "title3"

        let view = UIView()
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title1"),
          [1]: Text(label: "title2"),
          [2]: Text(label: "title3"),
        ]
        """)
    }

    func testAXAccessibilityElements() {
        let label1 = UILabel()
        label1.text = "title1"
        let label2 = UILabel()
        label2.text = "title2"
        let label3 = UILabel()
        label3.text = "title3"

        let view = UIView()
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.accessibilityElements = [
            label3, // reversed order
            label2, // & no more label1
        ]
        
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title3"),
          [1]: Text(label: "title2"),
        ]
        """)
    }

    func testAXAddTraits() {
        let view = UILabel()
        view.text = "title"
        view.accessibilityTraits.insert([.header, .playsSound, .keyboardKey])

        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(
            label: "title",
            traits: .header, .playsSound, .keyboardKey,
          ),
        ]
        """)
    }

    func testAXRemoveTraits() {
        let label1 = UILabel()
        label1.text = "label1"
        let label2 = UILabel()
        label2.text = "label2"
        label2.accessibilityTraits.remove(.staticText)
        
        let button1 = UIButton(type: .system)
        button1.setTitle("button1", for: .normal)
        let button2 = UIButton(type: .system)
        button2.setTitle("button2", for: .normal)
        button2.accessibilityTraits.remove(.button)
        
        let view = UIStackView()
        view.addArrangedSubview(label1)
        view.addArrangedSubview(label2)
        view.addArrangedSubview(button1)
        view.addArrangedSubview(button2)

        #warning("TODO: Missing `.staticText` attribute?")
        #warning("TODO: Missing `.button` attribute?")
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "label1"),
          [1]: Text(label: "label2"),
          [2]: Button(label: "button1"),
          [3]: Button(label: "button2"),
        ]
        """)
    }

    func testAXHidden() {
        let label1 = UILabel()
        label1.text = "title"
        let label2 = UILabel()
        label2.text = "accessibilityElementsHidden = false"
        label2.accessibilityElementsHidden = false
        let label3 = UILabel()
        label3.text = "accessibilityElementsHidden = true"
        label3.accessibilityElementsHidden = true
        let label4 = UILabel()
        label4.text = "isHidden = true"
        label4.isHidden = true
        let label5 = UILabel()
        label5.text = "layer.opacity = 0"
        label5.layer.opacity = 0
        
        /// Using UIView here to ensure because UIStackView has in-built behaviour of removing hidden views
        let view = UIView()
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)

        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title"),
          [1]: Text(label: "accessibilityElementsHidden = false"),
        ]
        """)
    }

//    func testAXRepresentation() {
//        let view = Text("title").accessibilityRepresentation { Text("ax_representation") }
//        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
//        [
//          [0]: Text(label: "ax_representation"),
//        ]
//        """)
//    }
//
//    func testAXChildren() {
//        let view = VStack {
//            Text("title")
//            Text("subtitle")
//        }.accessibilityChildren {
//            Text("ax_children1")
//            Text("ax_children2")
//                .accessibilityChildren {
//                    Text("ax_children2.1")
//                }
//        }
//        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
//        [
//          [0]: AccessibilityNode(
//            shouldGroupAccessibilityChildren: true,
//            navigationStyle: .separate,
//            containerType: .semanticGroup,
//            accessibilityElements: [
//              [0]: Text(label: "ax_children1"),
//              [1]: AccessibilityNode(
//                label: "ax_children2",
//                shouldGroupAccessibilityChildren: true,
//                navigationStyle: .combined,
//                containerType: .semanticGroup,
//                accessibilityElements: [
//                  [0]: Text(label: "ax_children2.1"),
//                ],
//              ),
//            ],
//          ),
//        ]
//        """)
//    }
//
//    func testAXElementCombine() {
//        let view = VStack {
//            Text("text_title")
//            Button("button_title") {}
//        }.accessibilityElement(children: .combine)
//        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
//        [
//          [0]: AccessibilityNode(
//            label: "text_title",
//            customActions: [
//              [0]: button_title,
//            ],
//          ),
//        ]
//        """)
//    }
//
//    func testAXElementContain() {
//        let view = VStack {
//            Text("text_title")
//            Button("button_title") {}
//        }.accessibilityElement(children: .contain)
//        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
//        [
//          [0]: AccessibilityNode(
//            shouldGroupAccessibilityChildren: true,
//            navigationStyle: .combined,
//            containerType: .semanticGroup,
//            accessibilityElements: [
//              [0]: Text(label: "text_title"),
//              [1]: Button(label: "button_title"),
//            ],
//          ),
//        ]
//        """)
//    }
//
//    func testAXElementIgnore() {
//        let view = VStack {
//            Text("text_title")
//            Button("button_title") {}
//        }.accessibilityElement(children: .ignore)
//        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
//        [
//          [0]: AccessibilityNode(),
//        ]
//        """)
//    }
//
//    func testAXActionUnamed() {
//        let view = Text("title").accessibilityAction {}
//        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
//        [
//          [0]: Button(label: "title"),
//        ]
//        """)
//    }
//
//    func testAXActionNamed() {
//        let view = Text("title").accessibilityAction(named: Text("ax_action_name"), {})
//        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
//        [
//          [0]: Text(
//            label: "title",
//            customActions: [
//              [0]: ax_action_name,
//            ],
//          ),
//        ]
//        """)
//    }
//
//    func testAXAdjustableAction() {
//        let view = Text("title").accessibilityAdjustableAction { _ in }
//        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
//        [
//          [0]: Text(
//            label: "title",
//            traits: .adjustable,
//          ),
//        ]
//        """)
//    }
//
//    func testAXRotor() {
//        struct Example: View {
//            @Namespace var ns
//            var body: some View {
//                Text("title")
//                    .accessibilityRotor(.boldText) {
//                        AccessibilityRotorEntry(Text("ax_rotor_entry"), id: ns)
//                    }
//                    .accessibilityRotor(Text("ax_custom_rotor")) {
//                        AccessibilityRotorEntry(Text("ax_rotor_entry"), id: ns)
//                    }
//
//            }
//        }
//        let view = Example()
//        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
//        [
//          [0]: Text(
//            label: "title",
//            customRotors: [
//              [0]: UIAccessibilityCustomRotor(custom: "ax_custom_rotor"),
//              [1]: UIAccessibilityCustomRotor(systemRotorType: .boldText),
//            ],
//          ),
//        ]
//        """)
//    }
//
//    func testAXRotorEntry() {
//        struct Example: View {
//            @Namespace var ns
//            var body: some View {
//                Text("title")
//                    .accessibilityRotorEntry(id: "ax_rotor_id", in: ns)
//            }
//        }
//        let view = Example()
//        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
//        [
//          [0]: Text(label: "title"),
//        ]
//        """)
//    }
//
//    // MARK: - Not yet supported
//
//    func testAXCustomContent() {
//        let view = Text("title")
//            .accessibilityCustomContent("ax_label1", Text("ax_value1"))
//            .accessibilityCustomContent("ax_label2", Text("ax_value2"), importance: .high)
//        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
//        [
//          [0]: Text(
//            label: "title",
//            customContent: [
//              [0]: AXCustomContent(ax_label1: "ax_value1"),
//              [1]: AXCustomContent(
//                ax_label2: "ax_value2",
//                importance: .high,
//              ),
//            ],
//          ),
//        ]
//        """)
//    }
//
//    func testAXHeading() {
//        let view = HStack {
//            Text("title")
//            Text("h1").accessibilityHeading(.h1)
//            Text("h2").accessibilityHeading(.h2)
//            Text("h3").accessibilityHeading(.h3)
//            Text("h4").accessibilityHeading(.h4)
//            Text("h5").accessibilityHeading(.h5)
//            Text("h6").accessibilityHeading(.h6)
//            Text("unspecified").accessibilityHeading(.unspecified)
//        }
//        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
//        [
//          [0]: Text(label: "title"),
//          [1]: Text(label: "h1"),
//          [2]: Text(label: "h2"),
//          [3]: Text(label: "h3"),
//          [4]: Text(label: "h4"),
//          [5]: Text(label: "h5"),
//          [6]: Text(label: "h6"),
//          [7]: Text(label: "unspecified"),
//        ]
//        """)
//    }
//
//    func testAXShowsLargeContentViewer() {
//        let view = Text("title").accessibilityShowsLargeContentViewer { Text("ax_larger_content") }
//        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
//        [
//          [0]: Text(label: "title"),
//        ]
//        """)
//    }
//
//    func testAXRespondsToUserInteraction() {
//        let view = VStack {
//            Text("title")
//            Text(".accessibilityRespondsToUserInteraction()").accessibilityRespondsToUserInteraction()
//            Text(".accessibilityRespondsToUserInteraction(true)").accessibilityRespondsToUserInteraction(true)
//            Text(".accessibilityRespondsToUserInteraction(flase)").accessibilityRespondsToUserInteraction(false)
//        }
//        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
//        [
//          [0]: Text(label: "title"),
//          [1]: Text(label: ".accessibilityRespondsToUserInteraction()"),
//          [2]: Text(label: ".accessibilityRespondsToUserInteraction(true)"),
//          [3]: Text(label: ".accessibilityRespondsToUserInteraction(flase)"),
//        ]
//        """)
//    }
//
//    func testAXTextContentType() {
//        let view = Text("title").accessibilityTextContentType(.sourceCode)
//        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
//        [
//          [0]: Text(label: "title"),
//        ]
//        """)
//    }
//
//    func testAX() {
//        // .accessibilityActivationPoint
//        // .accessibilityLinkedGroup
//        // .accessibilityLabeledPair
//        // .accessibilityScrollAction
//    }

    // MARK: -
    
    override func setUp() {
        super.setUp()
        SnapshotTesting.isRecording = true
    }
}
