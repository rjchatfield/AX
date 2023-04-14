import SwiftUI
import XCTest
import SnapshotTesting

final class AXTests: XCTestCase {
    
    func testTitle() {
        let view = Text("title")
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title"),
        ]
        """)
    }
    
    func testAXIdentifier() {
        let view = Text("title").accessibilityIdentifier("ax_identifier")
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
        let view = Text("title").accessibilityLabel(Text("ax_label"))
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "ax_label"),
        ]
        """)
    }
    
    func testAXHint() {
        let view = Text("title").accessibilityHint(Text("ax_hint"))
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(
            label: "title",
            hint: "ax_hint",
          ),
        ]
        """)
    }
    
    func testAXHelp() {
        let view = Text("title").help(Text("help"))
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(
            label: "title",
            hint: "help",
          ),
        ]
        """)
    }

    func testAXHintThenHelp() {
        let view = Text("title")
            .accessibilityHint(Text("ax_hint"))
            .help(Text("help"))
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(
            label: "title",
            hint: "help",
          ),
        ]
        """)
    }

    func testAXHintBeforeHelp() {
        let view = Text("title")
            .help(Text("help"))
            .accessibilityHint(Text("ax_hint"))
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(
            label: "title",
            hint: "ax_hint",
          ),
        ]
        """)
    }

    func testAXValue() {
        let view = Text("title").accessibilityValue(Text("ax_value"))
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
        let view = Text("title").accessibilityInputLabels([Text("ax_input_label1"), Text("ax_input_label2")])
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
    
    func testAXSortPriority() {
        let view = VStack {
            Text("title0a").accessibilitySortPriority(0)
            Text("title")
            Text("title0b").accessibilitySortPriority(0)
            Text("title-1").accessibilitySortPriority(-1)
            Text("title+1").accessibilitySortPriority(1)
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title+1"),
          [1]: Text(label: "title0a"),
          [2]: Text(label: "title"),
          [3]: Text(label: "title0b"),
          [4]: Text(label: "title-1"),
        ]
        """)
    }
    
    func testAXAddTraits() {
        let view = Text("title").accessibilityAddTraits([.isHeader, .playsSound, .isKeyboardKey])
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
        let view = Section {
            Text("title")
            Text("title").accessibilityRemoveTraits([.isStaticText])
            Button("title", action: {})
            Button("title", action: {}).accessibilityRemoveTraits([.isButton])
            Image(systemName: "star")
            Image(systemName: "star").accessibilityRemoveTraits([.isImage])
        } header: {
            Text("section_header")
            Text("section_header").accessibilityRemoveTraits([.isHeader])
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(
            label: "section_header",
            traits: .header,
          ),
          [1]: Text(label: "section_header"),
          [2]: Text(label: "title"),
          [3]: AccessibilityNode(label: "title"),
          [4]: Button(label: "title"),
          [5]: AccessibilityNode(label: "title"),
          [6]: Image(label: "Favorite"),
          [7]: AccessibilityNode(label: "Favorite"),
        ]
        """)
    }
    
    func testAXHidden() {
        let view = VStack {
            Text("title")
            Text("ax_hidden(false)").accessibilityHidden(false)
            Text("ax_hidden(true)").accessibilityHidden(true)
            Text("hidden()").hidden()
            Text("opacity(0)").opacity(0)
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title"),
          [1]: Text(label: "ax_hidden(false)"),
        ]
        """)
    }
        
    func testAXRepresentation() {
        let view = Text("title").accessibilityRepresentation { Text("ax_representation") }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "ax_representation"),
        ]
        """)
    }
    
    func testAXChildren() {
        let view = VStack {
            Text("title")
            Text("subtitle")
        }.accessibilityChildren {
            Text("ax_children1")
            Text("ax_children2")
                .accessibilityChildren {
                    Text("ax_children2.1")
                }
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: AccessibilityNode(
            shouldGroupAccessibilityChildren: true,
            navigationStyle: .separate,
            containerType: .semanticGroup,
            accessibilityElements: [
              [0]: Text(label: "ax_children1"),
              [1]: AccessibilityNode(
                label: "ax_children2",
                shouldGroupAccessibilityChildren: true,
                navigationStyle: .combined,
                containerType: .semanticGroup,
                accessibilityElements: [
                  [0]: Text(label: "ax_children2.1"),
                ],
              ),
            ],
          ),
        ]
        """)
    }
    
    func testAXElementCombine() {
        let view = VStack {
            Text("text_title")
            Button("button_title") {}
        }.accessibilityElement(children: .combine)
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Button(label: "text_title"),
        ]
        """)
    }
    
    func testAXElementContain() {
        let view = VStack {
            Text("text_title")
            Button("button_title") {}
        }.accessibilityElement(children: .contain)
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: AccessibilityNode(
            shouldGroupAccessibilityChildren: true,
            navigationStyle: .combined,
            containerType: .semanticGroup,
            accessibilityElements: [
              [0]: Text(label: "text_title"),
              [1]: Button(label: "button_title"),
            ],
          ),
        ]
        """)
    }

    func testAXElementIgnore() {
        let view = VStack {
            Text("text_title")
            Button("button_title") {}
        }.accessibilityElement(children: .ignore)
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: AccessibilityNode(),
        ]
        """)
    }

    func testAXActionUnamed() {
        let view = Text("title").accessibilityAction {}
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Button(label: "title"),
        ]
        """)
    }

    func testAXActionNamed() {
        let view = Text("title").accessibilityAction(named: Text("ax_action_name"), {})
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(
            label: "title",
            customActions: [
              [0]: ax_action_name,
            ],
          ),
        ]
        """)
    }

    func testAXAdjustableAction() {
        let view = Text("title").accessibilityAdjustableAction { _ in }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(
            label: "title",
            traits: .adjustable,
          ),
        ]
        """)
    }

    func testAXRotor() {
        struct Example: View {
            @Namespace var ns
            var body: some View {
                Text("title")
                    .accessibilityRotor(.boldText) {
                        AccessibilityRotorEntry(Text("ax_rotor_entry"), id: ns)
                    }
                    .accessibilityRotor(Text("ax_custom_rotor")) {
                        AccessibilityRotorEntry(Text("ax_rotor_entry"), id: ns)
                    }

            }
        }
        let view = Example()
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(
            label: "title",
            customRotors: [
              [0]: UIAccessibilityCustomRotor(custom: "ax_custom_rotor"),
              [1]: UIAccessibilityCustomRotor(systemRotorType: .boldText),
            ],
          ),
        ]
        """)
    }
    
    func testAXRotorEntry() {
        struct Example: View {
            @Namespace var ns
            var body: some View {
                Text("title")
                    .accessibilityRotorEntry(id: "ax_rotor_id", in: ns)
            }
        }
        let view = Example()
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title"),
        ]
        """)
    }
    
    // MARK: - Not yet supported
    
    func testAXCustomContent() {
        let view = Text("title")
            .accessibilityCustomContent("ax_label1", Text("ax_value1"))
            .accessibilityCustomContent("ax_label2", Text("ax_value2"), importance: .high)
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(
            label: "title",
            customContent: [
              [0]: AXCustomContent(ax_label1: "ax_value1"),
              [1]: AXCustomContent(
                ax_label2: "ax_value2",
                importance: .high,
              ),
            ],
          ),
        ]
        """)
    }
    
    func testAXHeading() {
        let view = HStack {
            Text("title")
            Text("h1").accessibilityHeading(.h1)
            Text("h2").accessibilityHeading(.h2)
            Text("h3").accessibilityHeading(.h3)
            Text("h4").accessibilityHeading(.h4)
            Text("h5").accessibilityHeading(.h5)
            Text("h6").accessibilityHeading(.h6)
            Text("unspecified").accessibilityHeading(.unspecified)
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title"),
          [1]: Text(label: "h1"),
          [2]: Text(label: "h2"),
          [3]: Text(label: "h3"),
          [4]: Text(label: "h4"),
          [5]: Text(label: "h5"),
          [6]: Text(label: "h6"),
          [7]: Text(label: "unspecified"),
        ]
        """)
    }
    
    func testAXShowsLargeContentViewer() {
        let view = Text("title").accessibilityShowsLargeContentViewer { Text("ax_larger_content") }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title"),
        ]
        """)
    }
    
    func testAXRespondsToUserInteraction() {
        let view = VStack {
            Text("title")
            Text(".accessibilityRespondsToUserInteraction()").accessibilityRespondsToUserInteraction()
            Text(".accessibilityRespondsToUserInteraction(true)").accessibilityRespondsToUserInteraction(true)
            Text(".accessibilityRespondsToUserInteraction(flase)").accessibilityRespondsToUserInteraction(false)
        }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title"),
          [1]: Text(label: ".accessibilityRespondsToUserInteraction()"),
          [2]: Text(label: ".accessibilityRespondsToUserInteraction(true)"),
          [3]: Text(label: ".accessibilityRespondsToUserInteraction(flase)"),
        ]
        """)
    }
    
    func testAXTextContentType() {
        let view = Text("title").accessibilityTextContentType(.sourceCode)
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "title"),
        ]
        """)
    }

    func testAX() {
        // .accessibilityActivationPoint
        // .accessibilityLinkedGroup
        // .accessibilityLabeledPair
        // .accessibilityScrollAction
    }
    
    // MARK: -
    
    override func setUp() {
        super.setUp()
        SnapshotTesting.isRecording = true
    }
}
