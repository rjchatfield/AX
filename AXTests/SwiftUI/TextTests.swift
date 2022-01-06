import SwiftUI
import XCTest
import SnapshotTesting

final class TextTests: XCTestCase {
    
    func testAXLabel() {
        var v: some View {
            Text("title")
                .accessibilityLabel(Text("ax_label"))
        }
        _assertInlineSnapshot(matching: v, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "ax_label")
        ]
        """)
    }
    
    func testExtractionFromSingleViewContainer() {
        let sut = AnyView(Text("Test"))
        let value = AXElement.walk(view: sut).first?.label as? String
        XCTAssertEqual(value, "Test")
    }
    
    func testExtractionFromMultipleViewContainer() {
        let view = HStack { Text("Test"); Text("Test") }
        _assertInlineSnapshot(matching: view, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "Test"),
          [1]: Text(label: "Test")
        ]
        """)
    }
    
//    func testSearch() {
//        let view = AnyView(Text("abc"))
//        XCTAssertEqual(try view.inspect().find(ViewType.Text.self).pathToRoot, "anyView().text()")
//        XCTAssertEqual(try view.inspect().find(text: "abc").pathToRoot, "anyView().text()")
//    }
    
    // MARK: - string()
    
    func testExternalStringValue() {
        let string = "Test"
        let sut = Text(string)
        let value = AXElement.walk(view: sut).first?.label as? String
        XCTAssertEqual(value, string)
    }
    
    func testLocalizableStringNoParams() {
        let sut = Text("Test")
        let value = AXElement.walk(view: sut).first?.label as? String
        XCTAssertEqual(value, "Test")
    }
    
//    func testResourceLocalizationStringNoParams() {
//        let bundle = try Bundle.testResources()
//        let sut = Text("Test", tableName: "Test", bundle: bundle)
//        let text = try sut.inspect().text()
//        let value1 = try text.string(locale: Locale(identifier: "fr"))
//        XCTAssertEqual(value1, "Test")
//        let value2 = try text.string(locale: Locale(identifier: "en"))
//        XCTAssertEqual(value2, "Test_en")
//        let value3 = try text.string(locale: Locale(identifier: "en_AU"))
//        XCTAssertEqual(value3, "Test_en_au")
//        let value4 = try text.string(locale: Locale(identifier: "ru"))
//        XCTAssertEqual(value4, "Тест_ru")
//    }
//    
//    func testLocalizationGlobalDefault() {
//        let bundle = try Bundle.testResources()
//        let sut = Text("Test", tableName: "Test", bundle: bundle)
//        let text = try sut.inspect().text()
//        
//        let value1 = try text.string()
//        XCTAssertEqual(value1, "Test_en")
//        
//        let defaultLocale = Locale.testsDefault
//        Locale.testsDefault = Locale(identifier: "ru")
//        let value2 = try text.string()
//        XCTAssertEqual(value2, "Тест_ru")
//        Locale.testsDefault = defaultLocale
//    }
//    
    func testVerbatimStringNoParams() {
        let sut = Text(verbatim: "Test")
        let value = AXElement.walk(view: sut).first?.label as? String
        XCTAssertEqual(value, "Test")
    }
    
    func testStringWithOneParam() {
        let sut = Text("Test \(12)")
        let value = AXElement.walk(view: sut).first?.label as? String
        XCTAssertEqual(value, "Test 12")
    }
    
    func testStringWithMultipleParams() {
        let sut = Text(verbatim: "Test \(12) \(5.7) \("abc")")
        let value = AXElement.walk(view: sut).first?.label as? String
        XCTAssertEqual(value, "Test 12 5.7 abc")
    }
    
    func testStringWithSpecifier() {
        let sut = Text("\(12.541, specifier: "%.2f")")
        let value = AXElement.walk(view: sut).first?.label as? String
        XCTAssertEqual(value, "12.54")
    }
    
    func testObjectInitialization() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en")
        let sut = Text(NSNumber(value: 12.541), formatter: formatter)
        let value1 = AXElement.walk(view: sut).first?.label as? String
        XCTAssertEqual(value1, "12.54")
        // TODO: ru fails... doesn't use comma
//        formatter.locale = Locale(identifier: "ru")
//        let value2 = AXElement.walk(view: sut).first?.label as? String
//        XCTAssertEqual(value2, "12,54")
    }
    
    func testObjectInterpolation() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en")
        let sut = Text("\(NSNumber(value: 12.541), formatter: formatter)")
        let value = AXElement.walk(view: sut).first?.label as? String
        XCTAssertEqual(value, "12.54")
    }
    
    func testReferenceConvertibleInitialization() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-ss"
        let date = Date(timeIntervalSinceReferenceDate: 123)
        let sut = Text(date, formatter: formatter)
        let value = AXElement.walk(view: sut).first?.label as? String
        XCTAssertEqual(value, formatter.string(from: date))
    }
    
    func testReferenceConvertibleInterpolation() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-ss"
        let date = Date(timeIntervalSinceReferenceDate: 123)
        let sut = Text("\(date, formatter: formatter)")
        let value = AXElement.walk(view: sut).first?.label as? String
        XCTAssertEqual(value, formatter.string(from: date))
    }
    
    func testDateStyleInitialization() {
        let date = Date().advanced(by: 601)
        let sut = Text(date, style: .timer)
        let value = AXElement.walk(view: sut).first?.label as? String
        XCTAssertEqual(value, "10:00") // Not sure is if this deterministic
    }
    
    func testDateIntervalInitialization() {
        let date1 = Date(timeIntervalSinceReferenceDate: 123)
        let date2 = Date(timeIntervalSinceReferenceDate: 123456)
        let sut1 = Text(date1...date2)
        let value1 = AXElement.walk(view: sut1).first?.label as? String
        XCTAssertEqual(value1, "Jan 1 – Jan 2") // Not sure is if this deterministic
        let interval = DateInterval(start: date1, end: date2)
        let sut2 = Text(interval)
        let value2 = AXElement.walk(view: sut2).first?.label as? String
        XCTAssertEqual(value2, "Jan 1 – Jan 2")
    }
    
    func testTextInterpolation() {
        let sut = Text("abc \(Text("xyz").bold()) \(Text("qwe"))")
        let value = AXElement.walk(view: sut).first?.label as? String
        XCTAssertEqual(value, "abc xyz qwe")
    }
    
    func testImageInterpolation() {
        let sut = Text("abc \(Image(systemName: "chevron.right"))")
        let value = AXElement.walk(view: sut).first?.label as? String
        XCTAssertEqual(value, "abc ￼") // Note: contains invisible char
    }
    
    func testCustomTextInterpolation() {
        let sut = Text("abc \(braces: "test")")
        let value = AXElement.walk(view: sut).first?.label as? String
        XCTAssertEqual(value, "abc [test]")
    }
    
    func testConcatenatedTexts() {
        let sut = Text("Test") + Text("Abc").bold() + Text(verbatim: "123")
        let value = AXElement.walk(view: sut).first?.label as? String
        XCTAssertEqual(value, "TestAbc123")
    }
    
//    func testImageExtraction() {
//        guard #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
//        else { throw XCTSkip() }
//        let image1 = Image("abc").antialiased(true)
//        let image2 = Image("def").resizable()
//        let image3 = Image("xyz")
//        let sut = Text("Text \(image1) \(Text(image2))") + Text("\(42, specifier: "%d") \(image3)")
//        let images = try sut.inspect().text().images()
//        XCTAssertEqual(images, [image1, image2, image3])
//        let string = AXElement.walk(view: sut).first?.label as? String
//        XCTAssertEqual(string, "Text ￼ ￼42 ￼") // Note: contains invisible chars
//        let sut2 = Text(Date()...Date())
//        XCTAssertEqual(try sut2.inspect().text().images(), [])
//        let sut3 = Text("abc")
//        XCTAssertEqual(try sut3.inspect().text().images(), [])
//    }
    
    // MARK: -
    
    override func setUp() {
        super.setUp()
        SnapshotTesting.isRecording = true
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
extension LocalizedStringKey.StringInterpolation {
    mutating func appendInterpolation(braces: String) {
        appendLiteral("[\(braces)]")
    }
}
