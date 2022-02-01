//
//  ContentView.swift
//  AX
//
//  Created by Robert Chatfield on 17/12/2021.
//

import SwiftUI

struct UI: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
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

        view.axis = .vertical
        view.distribution = .equalSpacing
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct ContentView: View {
    var body: some View {
        UI()
//        VStack {
////        List {
////        LazyVStack {
//            Text("ax_text")
//            Section {
//                Button("ax_button_1") {}
//                    .accessibilitySortPriority(-1) // after everything
//
//                /*
//                 ax_button_label, ax_button_value, Button, ax_button_hint
//                 */
//                Button("ax_button_2") {}
//                    .accessibilityLabel("ax_button_label")
//                    .accessibilityIdentifier("ax_button_identifier")
//                    .accessibilityHint(Text("ax_button_hint"))
//                    .accessibilityValue(Text("ax_button_value").bold())
//                Button("ax_button_3_hidden") {}
//                    .accessibilityHidden(true)
//
//                /*
//                 ```
//                 Text(label: "ax_label_title")
//                 ```
//
//                 No image is good
//                 TODO: But should we avoid calling this "Text" just because it is .staticText?
//                 */
//                Label("ax_label_title", systemImage: "chevron.down")
//
//                Image(systemName: "chevron.right")
//
//                /*
//                 Interestingly `TextField` is exposed as a `UITextField`
//
//                 - <UITextField: 0x13d014000; frame = (0 0; 0 0); opaque = NO; text = 'ax_textfield_text'; placeholder = ax_textfield_text; borderStyle = None; background = <_UITextFieldNoBackgroundProvider: 0x6000027c48e0: textfield=<UITextField 0x13d014000>>; layer = <CALayer: 0x6000025bcb40>> #0
//                 */
////                TextField("ax_textfield_title", text: .constant("ax_textfield_text"), prompt: Text("ax_textfield_text"))
//            } header: {
//                HStack {
//                    Text("section_header_text")
//                    Button("section_header_button1") {}
//                        .accessibilityLabel("section_header_button1_label")
//                        .accessibilityIdentifier("section_header_button1_identifier")
//                        .accessibilityHint(Text("section_header_button1_hint"))
//                        .accessibilityValue(Text("section_header_button1_value").bold())
//                    Button("section_header_button2") {}
//                        .accessibilityLabel("section_header_button2_label")
//                        .accessibilityIdentifier("section_header_button2_identifier")
//                        .accessibilityHint(Text("section_header_button2_hint"))
//                        .accessibilityValue(Text("section_header_button2_value").bold())
//                }
//                .accessibilityElement(children: .combine)
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
