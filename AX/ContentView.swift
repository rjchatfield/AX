//
//  ContentView.swift
//  AX
//
//  Created by Robert Chatfield on 17/12/2021.
//

import SwiftUI

struct UI: UIViewRepresentable {
    func makeUIView(context: Context) -> UIButton {
        let v = UIButton()
        v.setTitle("text_goes_here", for: .normal) 
        return v
    }
    func updateUIView(_ uiView: UIButton, context: Context) {}
}

struct ContentView: View {
    var body: some View {
//        UI()
        Toggle("title", isOn: .constant(true))
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
