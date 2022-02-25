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

//        let view = UIStackView()
//        view.addArrangedSubview(label1)
//        view.addArrangedSubview(label2)
//        view.addArrangedSubview(label3)
//        view.addArrangedSubview(label4)
//        view.addArrangedSubview(label5)

        let view = UIView()
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        label3.translatesAutoresizingMaskIntoConstraints = false
        label4.translatesAutoresizingMaskIntoConstraints = false
        label5.translatesAutoresizingMaskIntoConstraints = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label1.topAnchor.constraint(equalTo: view.topAnchor),
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor),
            label3.topAnchor.constraint(equalTo: label2.bottomAnchor),
            label4.topAnchor.constraint(equalTo: label3.bottomAnchor),
            label5.topAnchor.constraint(equalTo: label4.bottomAnchor),
            view.bottomAnchor.constraint(greaterThanOrEqualTo: label5.bottomAnchor),
            
//            label1.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            label2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            label3.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            label4.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            label5.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            label1.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label3.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label4.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label5.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            label1.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
            label2.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
            label3.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
            label4.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
            label5.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
            
            view.heightAnchor.constraint(equalToConstant: 500),
            view.widthAnchor.constraint(equalToConstant: 300),
        ])
        
        view.backgroundColor = .systemGray

//        view.axis = .vertical
//        view.distribution = .equalSpacing
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
