//
//  AXTests.swift
//  AXTests
//
//  Created by Robert Chatfield on 17/12/2021.
//

import XCTest
import CustomDump
import ViewInspector
import SwiftUI
import AccessibilitySnapshot
import SnapshotTesting

final class MiscTests: XCTestCase {

    func test1() {
        customDump(v)
    }
    
    func test2() {
        let vc = UIHostingController(rootView: v)
        _assertInlineSnapshot(matching: vc.view!, as: .customDump(maxDepth: 1), with: """
        _UIHostingView(
          _rootView: VStack(…),
          viewGraph: SwiftUI.ViewGraph,
          renderer: DisplayList.ViewRenderer(…),
          eventBindingManager: EventBindingManager(…),
          currentTimestamp: Time(seconds: 0.0),
          propertiesNeedingUpdate: ViewRendererHostProperties(rawValue: 1023),
          isRendering: false,
          accessibilityVersion: DisplayList.Version(value: 0),
          externalUpdateCount: 0,
          disabledBackgroundColor: false,
          allowFrameChanges: true,
          wantsTransparentBackground: false,
          explicitSafeAreaInsets: nil,
          keyboardFrame: nil,
          defaultAddsKeyboardToSafeAreaInsets: nil,
          keyboardSeed: 0,
          isHiddenForReuse: false,
          inheritedEnvironment: nil,
          environmentOverride: nil,
          viewController: UIHostingController(…),
          eventBridge: UIKitEventBindingBridge(…),
          displayLink: nil,
          lastRenderTime: Time(seconds: 0.0),
          canAdvanceTimeAutomatically: true,
          pendingPreferencesUpdate: false,
          nextTimerTime: nil,
          updateTimer: nil,
          colorScheme: nil,
          navigationState: nil,
          deprecatedAlertBridge: DeprecatedAlertBridge(…),
          deprecatedActionSheetBridge: DeprecatedAlertBridge(…),
          sheetBridge: SheetBridge(…),
          focusBridge: FocusBridge(…),
          dragBridge: DragAndDropBridge(…),
          fileImportExportBridge: FileImportExportBridge(…),
          inspectorBridge: UIKitInspectorBridge(…),
          sceneBridge: nil,
          pointerBridge: nil,
          statusBarBridge: UIKitStatusBarBridge(…),
          contextMenuBridge: ContextMenuBridge(…),
          accessibilityEnabled: false,
          shouldUpdateAccessibilityFocus: false,
          largeContentViewerInteractionBridge: UILargeContentViewerInteractionBridge(…),
          scrollTest: nil,
          delegate: nil,
          rootViewDelegate: nil,
          focusedValues: FocusedValues(…),
          currentAccessibilityFocusStore: AccessibilityFocusStore(…),
          observedScene: nil,
          isEnteringForeground: false,
          currentResponderCommands: [:],
          $__lazy_storage_$__forwardingTarget: nil
        )
        """)
        
        _assertInlineSnapshot(matching: vc.view.accessibilityElements!, as: .customDump(maxDepth: 2), with: """
        [
          [0]: AccessibilityNode(
            id: UniqueID(value: 3708),
            version: DisplayList.Version(value: 0),
            children: [],
            bridgedChild: nil,
            parent: AccessibilityNode(…),
            viewRendererHost: _UIHostingView(…),
            attachmentsStorage: […],
            cachedCombinedAttachment: nil,
            platformRotorStorage: [:],
            cachedIsPlaceholder: false,
            focusableAncestor: nil,
            relationshipScope: nil,
            isCell: false
          ),
          [1]: AccessibilityNode(
            id: UniqueID(value: 3765),
            version: DisplayList.Version(value: 0),
            children: […],
            bridgedChild: nil,
            parent: AccessibilityNode(↩︎),
            viewRendererHost: _UIHostingView(↩︎),
            attachmentsStorage: […],
            cachedCombinedAttachment: nil,
            platformRotorStorage: [:],
            cachedIsPlaceholder: false,
            focusableAncestor: nil,
            relationshipScope: nil,
            isCell: false
          ),
          [2]: AccessibilityNode(
            id: UniqueID(value: 3767),
            version: DisplayList.Version(value: 0),
            children: [],
            bridgedChild: nil,
            parent: AccessibilityNode(↩︎),
            viewRendererHost: _UIHostingView(↩︎),
            attachmentsStorage: […],
            cachedCombinedAttachment: nil,
            platformRotorStorage: [:],
            cachedIsPlaceholder: false,
            focusableAncestor: nil,
            relationshipScope: nil,
            isCell: false
          ),
          [3]: AccessibilityNode(
            id: UniqueID(value: 3770),
            version: DisplayList.Version(value: 0),
            children: [],
            bridgedChild: nil,
            parent: AccessibilityNode(↩︎),
            viewRendererHost: _UIHostingView(↩︎),
            attachmentsStorage: […],
            cachedCombinedAttachment: nil,
            platformRotorStorage: [:],
            cachedIsPlaceholder: false,
            focusableAncestor: nil,
            relationshipScope: nil,
            isCell: false
          ),
          [4]: AccessibilityNode(
            id: UniqueID(value: 3771),
            version: DisplayList.Version(value: 0),
            children: [],
            bridgedChild: nil,
            parent: AccessibilityNode(↩︎),
            viewRendererHost: _UIHostingView(↩︎),
            attachmentsStorage: […],
            cachedCombinedAttachment: nil,
            platformRotorStorage: [:],
            cachedIsPlaceholder: false,
            focusableAncestor: nil,
            relationshipScope: nil,
            isCell: false
          ),
          [5]: AccessibilityNode(
            id: UniqueID(value: 3766),
            version: DisplayList.Version(value: 0),
            children: [],
            bridgedChild: nil,
            parent: AccessibilityNode(↩︎),
            viewRendererHost: _UIHostingView(↩︎),
            attachmentsStorage: […],
            cachedCombinedAttachment: nil,
            platformRotorStorage: [:],
            cachedIsPlaceholder: false,
            focusableAncestor: nil,
            relationshipScope: nil,
            isCell: false
          )
        ]
        """)
        
        let ax1 = vc.view.accessibilityElements![0]
        let nsax1 = ax1 as! NSObject
        XCTAssertEqual(try v.inspect().vStack().text(0).string(), "ax_text")
        _assertInlineSnapshot(matching: nsax1, as: .customDump(maxDepth: 1), with: """
        AccessibilityNode(
          id: UniqueID(value: 3708),
          version: DisplayList.Version(value: 0),
          children: [],
          bridgedChild: nil,
          parent: AccessibilityNode(…),
          viewRendererHost: _UIHostingView(…),
          attachmentsStorage: […],
          cachedCombinedAttachment: nil,
          platformRotorStorage: [:],
          cachedIsPlaceholder: false,
          focusableAncestor: nil,
          relationshipScope: nil,
          isCell: false
        )
        """)
        print("NSAX1:")
        _assertInlineSnapshot(matching: nsax1.isAccessibilityElement, as: .customDump, with: """
        true
        """)
        _assertInlineSnapshot(matching: nsax1.accessibilityLabel as Any, as: .customDump, with: """
        "ax_text"
        """)
        _assertInlineSnapshot(matching: nsax1.accessibilityValue as Any, as: .customDump, with: """
        nil
        """)
        _assertInlineSnapshot(matching: nsax1.accessibilityHint as Any, as: .customDump, with: """
        nil
        """)
        _assertInlineSnapshot(matching: nsax1.accessibilityFrame, as: .customDump, with: """
        CGRect(
          origin: CGPoint(
            x: 0.0,
            y: -16.172159830729164
          ),
          size: CGSize(
            width: 0.0,
            height: 0.0
          )
        )
        """)
    }
    
    func test3() {
        _assertInlineSnapshot(matching: v, as: .accessibilityElements, with: """
        [
          [0]: Text(label: "ax_text"),
          [1]: PlatformAccessibilityElement(
            identifier: "section_header_button1_identifier-section_header_button2_identifier",
            label: "section_header_text",
            hint: "section_header_button1_hint, section_header_button2_hint",
            value: "section_header_button2_value",
            traits: .header,
            customActions: [
              [0]: section_header_button1_label,
              [1]: section_header_button2_label
            ]
          ),
          [2]: Button(
            identifier: "ax_button_identifier",
            label: "ax_button_label",
            hint: "ax_button_hint",
            value: "ax_button_value"
          ),
          [3]: Text(label: "ax_label_title"),
          [4]: Image(label: "Forward"),
          [5]: Button(label: "ax_button_1")
        ]
        """)
        _assertInlineSnapshot(matching: v, as: .voiceOver, with: """
        "TODO: voiceOver elements"
        """)
        /*
         TODO: VoiceOver
         [
           [0]: "ax_text",
           [1]: "section_header_text, section_header_button2_value, Header, section_header_button1_hint, section_header_button2_hint", {customActions: [section_header_button1_label, section_header_button2_label]}
           [2]: "ax_button_label, ax_button_value, Button, ax_button_hint",
           [3]: "ax_label_title"
           [4]: "Forward, Image"
           [5]: "ax_button_1, Button"
         ]
         */
    }
    
    func test4() {
        _assertInlineSnapshot(matching: uiView, as: .accessibilityElements, with: """
        [
          [0]: UIView(
            children: [
              [0]: UIView(),
              [1]: UIView(
                children: [
                  [0]: UIButton(
                    identifier: "ax_button_identifier",
                    label: "ax_button_label",
                    hint: "ax_button_hint",
                    value: "ax_button_value",
                    children: [
                      [0]: UIView()
                    ]
                  ),
                  [1]: UIButton(
                    children: [
                      [0]: UIView()
                    ]
                  )
                ]
              )
            ]
          )
        ]
        """)
        _assertInlineSnapshot(matching: uiView, as: .voiceOver, with: """
        "TODO: voiceOver elements"
        """)
    }
    
    func test5() {
        let vc = UIHostingController(rootView: v)
        let parsed = AccessibilityHierarchyParser().parseAccessibilityElements(in: vc.view)
        _assertInlineSnapshot(matching: parsed, as: .customDump, with: """
        []
        """)
    }
    
    func test6() {
        let parsed = AccessibilityHierarchyParser().parseAccessibilityElements(in: uiView)
        _assertInlineSnapshot(matching: parsed, as: .customDump, with: """
        [
          [0]: AccessibilityMarker(
            description: "ax_button_label: ax_button_value",
            hint: "ax_button_hint",
            shape: AccessibilityMarker.Shape.frame(
              CGRect(
                origin: CGPoint(
                  x: 0.0,
                  y: 0.0
                ),
                size: CGSize(
                  width: 0.0,
                  height: 0.0
                )
              )
            ),
            activationPoint: CGPoint(
              x: 0.0,
              y: 0.0
            ),
            usesDefaultActivationPoint: true,
            customActions: [],
            accessibilityLanguage: nil
          ),
          [1]: AccessibilityMarker(
            description: "",
            hint: nil,
            shape: AccessibilityMarker.Shape.frame(
              CGRect(
                origin: CGPoint(
                  x: 0.0,
                  y: 0.0
                ),
                size: CGSize(
                  width: 0.0,
                  height: 0.0
                )
              )
            ),
            activationPoint: CGPoint(
              x: 0.0,
              y: 0.0
            ),
            usesDefaultActivationPoint: true,
            customActions: [],
            accessibilityLanguage: nil
          )
        ]
        """)
    }
    
    func test7() {
        let view = Text("Hello world").accessibilityHeading(.h1)
        let vc = UIHostingController(rootView: view)
        let element = vc.view.accessibilityElements![0]
        _assertInlineSnapshot(matching: element, as: .customDump(maxDepth: 1), with: """
        AccessibilityNode(
          id: UniqueID(value: 4127),
          version: DisplayList.Version(value: 0),
          children: [],
          bridgedChild: nil,
          parent: AccessibilityNode(…),
          viewRendererHost: _UIHostingView(…),
          attachmentsStorage: […],
          cachedCombinedAttachment: nil,
          platformRotorStorage: [:],
          cachedIsPlaceholder: false,
          focusableAncestor: nil,
          relationshipScope: nil,
          isCell: false
        )
        """)
        let obj = element as! NSObject
        let selectors = obj.allSelectors
//            .filter { $0.starts(with: "accessibility") }
            .sorted()
        _assertInlineSnapshot(matching: selectors, as: .dump, with: """
        ▿ 101 elements
          - ".cxx_destruct"
          - "_accessibilityAutomationType"
          - "_accessibilityBoundsForRange:"
          - "_accessibilityClassName"
          - "_accessibilityDataSeriesGridlinePositionsForAxis:"
          - "_accessibilityDataSeriesIncludesTrendlineInSonification"
          - "_accessibilityDataSeriesMaximumValueForAxis:"
          - "_accessibilityDataSeriesMinimumValueForAxis:"
          - "_accessibilityDataSeriesName"
          - "_accessibilityDataSeriesSonificationDuration"
          - "_accessibilityDataSeriesSupportsSonification"
          - "_accessibilityDataSeriesSupportsSummarization"
          - "_accessibilityDataSeriesTitleForAxis:"
          - "_accessibilityDataSeriesType"
          - "_accessibilityDataSeriesUnitLabelForAxis:"
          - "_accessibilityDataSeriesValueDescriptionForPosition:axis:"
          - "_accessibilityDataSeriesValuesForAxis:"
          - "_accessibilityExpandedStatus"
          - "_accessibilityHeadingLevel"
          - "_accessibilityIsChartElement"
          - "_accessibilityIsRTL"
          - "_accessibilityMaxValue"
          - "_accessibilityMediaAnalysisElement"
          - "_accessibilityMinValue"
          - "_accessibilityNumberValue"
          - "_accessibilityRoleDescription"
          - "_accessibilityScrollToVisible"
          - "_accessibilityUpdateContainerElementReferencesIfNeededForNewElements:"
          - "_accessibilityUserDefinedLinkedUIElements"
          - "_accessibilityUserTestingChildren"
          - "_accessibilityUserTestingParent"
          - "_accessibilityUserTestingVisibleAncestor"
          - "accessibilityActivate"
          - "accessibilityActivationPoint"
          - "accessibilityAttributedHint"
          - "accessibilityAttributedLabel"
          - "accessibilityAttributedUserInputLabels"
          - "accessibilityAttributedValue"
          - "accessibilityChartDescriptor"
          - "accessibilityContainer"
          - "accessibilityContainerType"
          - "accessibilityCustomActions"
          - "accessibilityCustomContent"
          - "accessibilityCustomRotors"
          - "accessibilityDecrement"
          - "accessibilityElementCount"
          - "accessibilityElementDidBecomeFocused"
          - "accessibilityElementDidLoseFocus"
          - "accessibilityElements"
          - "accessibilityElementsHidden"
          - "accessibilityFrame"
          - "accessibilityHint"
          - "accessibilityIdentifier"
          - "accessibilityIncrement"
          - "accessibilityLabel"
          - "accessibilityLanguage"
          - "accessibilityNavigationStyle"
          - "accessibilityPath"
          - "accessibilityPerformEscape"
          - "accessibilityPerformMagicTap"
          - "accessibilityRespondsToUserInteraction"
          - "accessibilityRowRange"
          - "accessibilityScroll:"
          - "accessibilityTextualContext"
          - "accessibilityTraits"
          - "accessibilityURL"
          - "accessibilityUserInputLabels"
          - "accessibilityValue"
          - "accessibilityViewIsModal"
          - "dealloc"
          - "description"
          - "init"
          - "isAccessibilityElement"
          - "setAccessibilityActivationPoint:"
          - "setAccessibilityAttributedHint:"
          - "setAccessibilityAttributedLabel:"
          - "setAccessibilityAttributedUserInputLabels:"
          - "setAccessibilityAttributedValue:"
          - "setAccessibilityChartDescriptor:"
          - "setAccessibilityContainerType:"
          - "setAccessibilityCustomActions:"
          - "setAccessibilityCustomContent:"
          - "setAccessibilityCustomRotors:"
          - "setAccessibilityElements:"
          - "setAccessibilityElementsHidden:"
          - "setAccessibilityFrame:"
          - "setAccessibilityHint:"
          - "setAccessibilityIdentifier:"
          - "setAccessibilityLabel:"
          - "setAccessibilityLanguage:"
          - "setAccessibilityNavigationStyle:"
          - "setAccessibilityPath:"
          - "setAccessibilityRespondsToUserInteraction:"
          - "setAccessibilityTextualContext:"
          - "setAccessibilityTraits:"
          - "setAccessibilityUserInputLabels:"
          - "setAccessibilityValue:"
          - "setAccessibilityViewIsModal:"
          - "setIsAccessibilityElement:"
          - "setShouldGroupAccessibilityChildren:"
          - "shouldGroupAccessibilityChildren"
        """)
        
        if obj.responds(to: Selector(("_accessibilityHeadingLevel"))) {
//            XCTAssertNotNil(obj.perform(Selector(("_accessibilityHeadingLevel")))?.takeRetainedValue())
            // FAILS!
        }
    }

    // MARK: -
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        SnapshotTesting.isRecording = true
    }
    
    var v: some View {
        VStack {
//        List {
//        LazyVStack {
            Text("ax_text")
            Section {
                Button("ax_button_1") {}
                    .accessibilitySortPriority(-1) // after everything
                
                /*
                 ax_button_label, ax_button_value, Button, ax_button_hint
                 */
                Button("ax_button_2") {}
                    .accessibilityLabel("ax_button_label")
                    .accessibilityIdentifier("ax_button_identifier")
                    .accessibilityHint(Text("ax_button_hint"))
                    .accessibilityValue(Text("ax_button_value").bold())
                Button("ax_button_3_hidden") {}
                    .accessibilityHidden(true)
                
                /*
                 ```
                 Text(label: "ax_label_title")
                 ```
                 
                 No image is good
                 TODO: But should we avoid calling this "Text" just because it is .staticText?
                 */
                Label("ax_label_title", systemImage: "chevron.down")
                
                Image(systemName: "chevron.right")
                
                /*
                 Interestingly `TextField` is exposed as a `UITextField`
                 
                 - <UITextField: 0x13d014000; frame = (0 0; 0 0); opaque = NO; text = 'ax_textfield_text'; placeholder = ax_textfield_text; borderStyle = None; background = <_UITextFieldNoBackgroundProvider: 0x6000027c48e0: textfield=<UITextField 0x13d014000>>; layer = <CALayer: 0x6000025bcb40>> #0
                 */
//                TextField("ax_textfield_title", text: .constant("ax_textfield_text"), prompt: Text("ax_textfield_text"))
            } header: {
                HStack {
                    Text("section_header_text")
                    Button("section_header_button1") {}
                        .accessibilityLabel("section_header_button1_label")
                        .accessibilityIdentifier("section_header_button1_identifier")
                        .accessibilityHint(Text("section_header_button1_hint"))
                        .accessibilityValue(Text("section_header_button1_value").bold())
                    Button("section_header_button2") {}
                        .accessibilityLabel("section_header_button2_label")
                        .accessibilityIdentifier("section_header_button2_identifier")
                        .accessibilityHint(Text("section_header_button2_hint"))
                        .accessibilityValue(Text("section_header_button2_value").bold())
                }
                .accessibilityElement(children: .combine)
            }
        }
    }
    
    var uiView: UIView {
        let label = UILabel()
        label.text = "ax_text"
        let button1 = UIButton()
        button1.setTitle("ax_button_1", for: .normal)
        let button2 = UIButton(type: .system)
        button2.setTitle("ax_button_2", for: .normal)
        button2.accessibilityLabel = "ax_button_label"
        button2.accessibilityIdentifier = "ax_button_identifier"
        button2.accessibilityHint = "ax_button_hint"
        button2.accessibilityValue = "ax_button_value"
        let button3 = UIButton()
        button2.setTitle("ax_button_3_hidden", for: .normal)
        let section = UIStackView(arrangedSubviews: [
            // Section Header?
            button1,
            button2,
            button3,
        ])
        section.accessibilityElements = [button2, button1]
        let view = UIStackView(arrangedSubviews: [
            label,
            section,
        ])
        view.frame = CGRect(x: 0, y: 0, width: 300, height: 3000)
        view.sizeToFit()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        return view
    }
}

extension NSObject {
    var allSelectors: [String] {
        var mc: UInt32 = 0
        let mcPointer: UnsafeMutablePointer<UInt32> = withUnsafeMutablePointer(to: &mc) { $0 }
        let mlist: UnsafeMutablePointer<Method> = class_copyMethodList(object_getClass(self), mcPointer)!
        return (0..<Int(mc)).map { (i: Int) -> String in
            String(format: "%s", arguments: [
                sel_getName(method_getName(mlist[i]))
            ])
        }
    }
}

/*
 //
 //     Generated by class-dump 3.5 (64 bit).
 //
 //  Copyright (C) 1997-2019 Steve Nygard.
 //

 #import <objc/NSObject.h>

 @interface NSObject (UIAccessibilityElementTraversal)
 + (id)accessibilityBundles;
 + (void)accessibilityInitializeBundle;
 + (long long)_accessibilityUnitTestingOrientation;
 + (_Bool)_accessibilityHasUnitTestingOrientation;
 + (void)_accessibilityUnsetUnitTestingOrientation;
 + (void)_accessibilitySetUnitTestingOrientation:(long long)arg1;
 + (id)_accessibilityTextChecker;
 + (void)_accessibilityClearProcessedClasses:(id)arg1;
 + (void)_accessibilityUndoAttributedDecisionCaching:(id)arg1;
 + (void)_accessibilityUpdateOpaqueFocusStateForTechnology:(id)arg1 oldElement:(id)arg2 newElement:(id)arg3;
 - (_Bool)_accessibilityShouldUseSupplementaryViews;
 - (_Bool)_accessibilityShouldBeProcessed:(id)arg1;
 - (_Bool)_accessibilityHasVisibleFrame;
 - (long long)_accessibilityCompareGeometryForViewOrDictionary:(id)arg1;
 - (id)_accessibilityViewChildrenWithOptions:(id)arg1;
 - (_Bool)_accessibilityEnumerateSiblingsWithParent:(id *)arg1 options:(id)arg2 usingBlock:(CDUnknownBlockType)arg3;
 - (void)_handleSupplementaryViewIfNeededWithOrderedChildrenContainer:(id *)arg1 childOfOrderedChildrenContainer:(id *)arg2 headerIndex:(unsigned long long *)arg3 footerIndex:(unsigned long long *)arg4;
 - (id)_accessibilityParentFromOrderedChildrenContainer:(id)arg1;
 - (void)_accessibilityEnumerateSiblingsFromOrderedChildrenContainer:(id)arg1 fromChildAtIndex:(long long)arg2 headerIndex:(long long)arg3 footerIndex:(long long)arg4 isMovingForward:(_Bool)arg5 usingBlock:(CDUnknownBlockType)arg6;
 - (_Bool)_accessibilityAppendOrderedChildLeafDescendantsToArray:(id)arg1 count:(unsigned long long)arg2 shouldStopAtRemoteElement:(_Bool)arg3 options:(id)arg4 treeLogger:(id)arg5;
 - (id)_accessibilityLeafDescendantsWithCount:(unsigned long long)arg1 shouldStopAtRemoteElement:(_Bool)arg2 options:(id)arg3 treeLogger:(id)arg4;
 - (id)_accessibilityLeafDescendantsWithCount:(unsigned long long)arg1 shouldStopAtRemoteElement:(_Bool)arg2 options:(id)arg3;
 - (id)_accessibilityLeafDescendantsWithCount:(unsigned long long)arg1 options:(id)arg2;
 - (id)_accessibilityLeafDescendantsWithOptions:(id)arg1;
 - (void)_accessibilityTraverseTreeWithLogger:(id)arg1 shouldStopAtRemoteElement:(_Bool)arg2 options:(id)arg3;
 - (void)_accessibilityTraverseTreeWithLogger:(id)arg1 options:(id)arg2;
 - (id)_accessibilityTreeAsStringWithOptions:(id)arg1;
 - (id)_accessibilityTreeAsString;
 - (id)_accessibilityElementsInDirectionWithCount:(unsigned long long)arg1 options:(id)arg2;
 - (void)accessibilitySetUserDefinedOpaqueElementScrollsContentIntoView:(id)arg1;
 - (id)accessibilityUserDefinedOpaqueElementScrollsContentIntoView;
 - (id)accessibilityUserDefinedSize;
 - (id)accessibilityUserDefinedNotFirstElement;
 - (id)accessibilityUserDefinedServesAsFirstElement;
 - (id)accessibilityUserDefinedIsMainWindow;
 - (id)accessibilityUserDefinedWindowVisible;
 - (id)isAccessibilityUserDefinedScrollAncestor;
 - (_Bool)_accessibilityUseContextlessPassthroughForDrag;
 - (id)_accessibilityAddToDragSessionCustomAction;
 - (id)_accessibilityDropPointDescriptorDictionaryRepresentations;
 - (id)_accessibilityAllDropPointDescriptors;
 - (id)_accessibilityDragSourceDescriptorDictionaryRepresentations;
 - (id)_accessibilityAllDragSourceDescriptors;
 - (id)_accessibilityFilterInteractionLocationDescriptorsForVisible:(id)arg1;
 - (_Bool)_accessibilityRealtimeHasUnread;
 - (_Bool)_accessibilityRealtimeCompleted;
 - (_Bool)accessibilityIsMediaPlaying;
 - (_Bool)accessibilityIsAttachmentElement;
 - (id)_accessibilityCustomActionGroupIdentifier;
 - (_Bool)_accessibilityIsDraggableElementAttribute;
 - (_Bool)_accessibilityHasDragDestinations;
 - (_Bool)_accessibilityHasDragSources;
 - (_Bool)_accessibilityScannerShouldUseActivateInPointMode;
 - (_Bool)_accessibilityShouldPerformIncrementOrDecrement;
 - (void)_accessibilityPostPasteboardTextForOperation:(id)arg1;
 - (void)_accessibilityIgnoreNextPostPasteboardTextOperation:(id)arg1;
 - (void)_accessibilityPostAnnouncement:(id)arg1;
 - (void)_accessibilityPostNotificationHelper:(id)arg1;
 - (void)accessibilityPostNotification:(unsigned int)arg1 withObject:(id)arg2 afterDelay:(double)arg3;
 - (void)_accessibilityHandleATFocused:(_Bool)arg1 assistiveTech:(id)arg2;
 - (void)_accessibilityIgnoreNextNotification:(unsigned int)arg1;
 - (void)_accessibilityAnnouncementComplete:(id)arg1;
 - (id)_accessibilityRecentlyActivatedApplicationBundleIdentifiers;
 - (void)_accessibilityRemoveRecentlyActivatedBundleIdFromSwitcher:(id)arg1;
 - (void)_accessibilityAddRecentlyActivatedBundleIdFromSwitcher:(id)arg1;
 - (_Bool)_accessibilityApplicationIsRTL;
 - (_Bool)_accessibilityIsRTL;
 - (id)_accessibilitySupportedLanguages;
 - (_Bool)accessibilityRequired;
 - (long long)_accessibilityMapFeatureType;
 - (float)_accessibilityDistanceFromEndOfRoad:(struct CGPoint)arg1 forAngle:(float)arg2;
 - (float)_accessibilityDistance:(struct CGPoint)arg1 forAngle:(float)arg2 toRoad:(id)arg3;
 - (id)_accessibilityMapsExplorationDecreaseVerbosity;
 - (id)_accessibilityMapsExplorationIncreaseVerbosity;
 - (id)_accessibilityMapsExplorationCurrentIntersectionDescription;
 - (id)_accessibilityMapsExplorationCurrentLocation;
 - (id)_accessibilityMapsExplorationCurrentRoadsWithAngles;
 - (void)_accessibilityMapsExplorationEnd;
 - (void)_accessibilityMapsExplorationContinueWithVertexIndex:(unsigned long long)arg1;
 - (void)_accessibilityMapsExplorationBeginFromCurrentElement;
 - (void)_accessibilityMapsExplorationBegin;
 - (void)_accessibilityMapsExplorationRecordTouchpoint:(struct CGPoint)arg1;
 - (id)_accessibilityUpcomingRoadsForPoint:(struct CGPoint)arg1 forAngle:(float)arg2;
 - (id)_accessibilityMapDetailedInfoAtPoint:(struct CGPoint)arg1;
 - (_Bool)_accessibilityRoadContainsTrackingPoint:(struct CGPoint)arg1;
 - (id)_axDebugTraits;
 - (id)_axSuperviews;
 - (id)_accessibilityApplicationSemanticContext;
 - (id)_accessibilitySemanticContextForElement:(id)arg1;
 - (id)_accessibilitySemanticContext;
 - (_Bool)_accessibilitySupportsSemanticContext;
 - (id)_accessibilityString:(id)arg1 withSpeechHint:(id)arg2;
 - (_Bool)_accessibilityLanguageOverriddesUser;
 - (id)accessibilitySpeechHint;
 - (id)_accessibilityWebAreaURL;
 - (id)accessibilityURL;
 - (id)accessibilityDatetimeValue;
 - (_Bool)_accessibilityShouldApplySemanticGroupContainerType;
 - (id)_accessibilityUserTestingActionIdentifiers;
 - (_Bool)_accessibilityPerformUserTestingAction:(id)arg1;
 - (id)_accessibilityUserTestingActions;
 - (id)_accessibilityUserTestingVisibleAncestor;
 - (_Bool)_accessibilityHitTestsStatusBar;
 - (long long)_accessibilityVerticalSizeClass;
 - (long long)_accessibilityHorizontalSizeClass;
 - (id)_accessibilityAutomaticIdentifier;
 - (unsigned long long)_accessibilityDatePickerComponentType;
 - (long long)_accessibilityPickerType;
 - (struct CGRect)_accessibilityGesturePracticeRegion;
 - (id)_accessibilityDateTimePickerValues;
 - (_Bool)_accessibilityWebViewIsLoading;
 - (id)_accessibilityActiveURL;
 - (_Bool)_accessibilityWebSearchResultsActive;
 - (id)accessibilityPopupValue;
 - (_Bool)accessibilityHasPopup;
 - (_Bool)accessibilityIsComboBox;
 - (void)_accessibilityIncreaseSelection:(id)arg1;
 - (_Bool)_accessibilityIsRealtimeElement;
 - (id)accessibilityExpandedTextValue;
 - (id)accessibilitySortDirection;
 - (id)accessibilityInvalidStatus;
 - (_Bool)_accessibilityBackingElementIsValid;
 - (long long)_accessibilityIndexForPickerString:(id)arg1;
 - (void)_accessibilityDecreaseSelection:(id)arg1;
 - (id)_accessibilityUserTestingVisibleSections;
 - (id)_accessibilityUserTestingVisibleCells;
 - (struct CGPoint)_accessibilityMaxScrubberPosition;
 - (struct CGPoint)_accessibilityMinScrubberPosition;
 - (_Bool)_accessibilityDismissAlternativeKeyPicker;
 - (_Bool)_accessibilityDispatchKeyboardAction:(id)arg1;
 - (_Bool)_accessibilityActivateKeyboardDeleteKey;
 - (_Bool)_accessibilityHandwritingSendCarriageReturn;
 - (_Bool)_accessibilityActivateKeyboardReturnKey;
 - (id)_accessibilityAlternativesForTextAtPosition:(unsigned long long)arg1;
 - (_Bool)_accessibilityInsertTextWithAlternatives:(id)arg1;
 - (void)_accessibilityInsertText:(id)arg1;
 - (void)_accessibilityInsertText:(id)arg1 atPosition:(long long)arg2;
 - (void)_accessibilityReplaceCharactersAtCursor:(unsigned long long)arg1 withString:(id)arg2;
 - (_Bool)_accessibilityReplaceTextInRange:(struct _NSRange)arg1 withString:(id)arg2;
 - (id)_accessibilityHandwritingAttributeLanguage;
 - (_Bool)_accessibilityHandwritingAttributeAcceptsContractedBraille;
 - (_Bool)_accessibilityHandwritingAttributeShouldPlayKeyboardSecureClickSound;
 - (_Bool)_accessibilityHandwritingAttributeShouldEchoCharacter;
 - (_Bool)_accessibilityHasDeletableText;
 - (unsigned long long)_accessibilityHandwritingAttributeAllowedCharacterSets;
 - (unsigned long long)_accessibilityHandwritingAttributeAllowedCharacterSetsForKeyboardType:(long long)arg1;
 - (unsigned long long)_accessibilityHandwritingAttributePreferredCharacterSet;
 - (unsigned long long)_accessibilityHandwritingAttributePreferredCharacterSetForKeyboardType:(long long)arg1;
 - (_Bool)_accessibilityRequiresLaTeXInput;
 - (id)_accessibilityHandwritingAttributes;
 - (_Bool)_accessibilitySupportsHandwriting;
 - (id)_accessibilityTextHandlingAncestorMatchingBlock:(CDUnknownBlockType)arg1;
 - (id)_accessibilityHandwritingAncestor;
 - (_Bool)_accessibilityCanAppearInContextMenuPreview;
 - (id)_accessibilityContextMenuActionForElement:(id)arg1;
 - (_Bool)_accessibilityDelegateCanShowContextMenuForInteraction:(id)arg1 atLocation:(struct CGPoint)arg2;
 - (_Bool)_accessibilityCanShowContextMenuForInteraction:(id)arg1 atLocation:(struct CGPoint)arg2;
 - (id)_accessibilityElementForTextInsertionAndDeletion;
 - (_Bool)_accessibilitySupportsTextInsertionAndDeletion;
 - (id)accessibilityNextTextNavigationElement;
 - (id)accessibilityPreviousTextNavigationElement;
 - (void)_accessibilityPostValueChangedNotificationWithChangeType:(struct __CFString *)arg1;
 - (void)_accessibilityPostValueChangedNotificationWithInsertedText:(id)arg1;
 - (void)_accessibilityPostValueChangedNotificationWithChangeType:(struct __CFString *)arg1 insertedText:(id)arg2;
 - (id)_accessibilityAttributedValueForRange:(struct _NSRange *)arg1;
 - (void)_accessibilityAddMispellingsToAttributedString:(id)arg1;
 - (void)_accessibilitySetNavigationControllerInset:(struct UIEdgeInsets)arg1;
 - (void)_accessibilityConvertStyleAttributesToAccessibility:(id)arg1;
 - (void)_accessibilitySetValue:(id)arg1;
 - (_Bool)_accessibilityIncreaseLayoutBounds;
 - (void)_accessibilitySetIncreaseLayoutBounds:(_Bool)arg1;
 - (_Bool)_accessibilityActivateParagraphInTextViewRange:(struct _NSRange)arg1;
 - (id)_accessibilityContextDrawingAnnotations;
 - (void)_accessibilitySetContextDrawingAnnotations:(id)arg1;
 - (_Bool)_accessibilityTextViewShouldBreakUpParagraphs;
 - (void)_accessibilitySetTextViewShouldBreakUpParagraphs:(_Bool)arg1;
 - (void)_accessibilitySetTextViewIgnoresValueChanges:(_Bool)arg1;
 - (_Bool)_accessibilityTextViewIgnoresValueChanges;
 - (id)_accessibilityTextChecker;
 - (_Bool)_accessibilitySupportsRangeForLineNumber;
 - (_Bool)_accessibilitySupportsFrameForRange;
 - (id)_accessibilityValueForRange:(struct _NSRange *)arg1;
 - (_Bool)__accessibilityReadAllOnFocus;
 - (_Bool)_accessibilityReadAllOnFocus;
 - (id)_accessibilityMarkerLineEndsForMarkers:(id)arg1;
 - (id)_accessibilityMarkersForRange:(struct _NSRange)arg1;
 - (id)_accessibilityMarkersForPoints:(id)arg1;
 - (id)accessibilityLabelForRange:(struct _NSRange *)arg1;
 - (struct CGRect)_accessibilityTextCursorFrame;
 - (void)_setAccessibilityPhotoDescription:(id)arg1;
 - (id)_accessibilityPhotoDescription;
 - (_Bool)_accessibilityKeyboardSupportsGestureMode;
 - (_Bool)_accessibilityBookShowsDualPages;
 - (_Bool)_accessibilityKeyboardKeyAllowsTouchTyping;
 - (_Bool)_accessibilityShouldAnnounceFontInfo;
 - (id)_accessibilityPageContent;
 - (void)_accessibilitySetCurrentWordInPageContext:(id)arg1;
 - (_Bool)_accessibilityIncludeDuringContentReading;
 - (long long)accessibilityLineNumberForPoint:(struct CGPoint)arg1;
 - (id)accessibilityPageContent;
 - (struct CGPoint)_accessibilityVisibleScrollArea:(_Bool)arg1;
 - (_Bool)_accessibilityReadAllContinuesWithScroll;
 - (id)_accessibilityDOMAttributes;
 - (void)_accessibilityMoveSelectionToMarker:(id)arg1;
 - (id)_accessibilityTextMarkerForPosition:(long long)arg1;
 - (struct _NSRange)_accessibilitySelectedNSRangeForObject;
 - (id)_accessibilityTextMarkerRangeForSelection;
 - (struct _NSRange)_accessibilityRangeForTextMarker:(id)arg1;
 - (id)_accessibilityFilenameForAttachmentCID:(id)arg1;
 - (id)_accessibilityPageTextMarkerRange;
 - (id)_accessibilityTextMarkerRange;
 - (id)_accessibilityPreviousMarker:(id)arg1;
 - (id)_accessibilityNextMarker:(id)arg1;
 - (id)_accessibiltyAvailableKeyplanes;
 - (id)_accessibilityElementStoredUserLabel;
 - (id)_accessibilityLineEndMarker:(id)arg1;
 - (id)_accessibilityMarkerForPoint:(struct CGPoint)arg1;
 - (id)_accessibilityLineStartMarker:(id)arg1;
 - (struct CGRect)_accessibilityBoundsForRange:(struct _NSRange)arg1;
 - (struct _NSRange)_accessibilityRangeForLineNumberAndColumn:(id)arg1;
 - (id)_accessibilityLineNumberAndColumnForPoint:(struct CGPoint)arg1;
 - (long long)_accessibilityLineStartPosition;
 - (long long)_accessibilityLineEndPosition;
 - (struct _NSRange)_accessibilitySelectedTextRange;
 - (void)_accessibilitySetSelectedTextRange:(struct _NSRange)arg1;
 - (_Bool)_accessibilityTriggerDictationFromPath:(id)arg1;
 - (id)_accessibilityDataDetectorScheme:(struct CGPoint)arg1;
 - (struct _NSRange)_accessibilityRangeForLineNumber:(long long)arg1;
 - (struct CGRect)_accessibilityFrameForRange:(struct _NSRange)arg1;
 - (struct CGRect)accessibilityFrameForLineNumber:(long long)arg1;
 - (id)accessibilityContentForLineNumber:(long long)arg1;
 - (unsigned long long)_accessibilityPositionInDirection:(long long)arg1 offset:(unsigned long long)arg2 forPosition:(unsigned long long)arg3;
 - (struct _NSRange)_accessibilityLineRangeForPosition:(unsigned long long)arg1;
 - (id)_accessibilityObjectForTextMarker:(id)arg1;
 - (id)accessibilityArrayOfTextForTextMarkers:(id)arg1;
 - (id)accessibilityStringForTextMarkers:(id)arg1;
 - (struct CGRect)accessibilityBoundsForTextMarkers:(id)arg1;
 - (void)_accessibilityDetectAnimationsNonActive;
 - (void)_accessibilitySetAnimationsInProgress:(_Bool)arg1;
 - (_Bool)_accessibilityAnimationsInProgress;
 - (void)_accessibilityUnregister;
 - (void)_cleanupRotorCache;
 - (void)_accessibilityCleanupContainerElementReferences;
 - (void)__accessibilityUnregister:(void *)arg1 shouldRelease:(_Bool)arg2;
 - (id)accessibilityAssistiveTechnologyFocusedIdentifiers;
 - (_Bool)accessibilityElementIsFocused;
 - (_Bool)_accessibilityShouldReleaseAfterUnregistration;
 - (void)accessibilityElementDidLoseFocus;
 - (void)accessibilityElementDidBecomeFocused;
 - (id)_accessibilityLoadAccessibilityInformationSupplementaryItems;
 - (void)_accessibilityLoadAccessibilityInformation;
 - (void)_accessibilityPlayKeyboardClickSound;
 - (void)_accessibilityPlaySystemSound:(int)arg1;
 - (void)_accessibilitySetIsTourGuideRunning:(_Bool)arg1;
 - (_Bool)_accessibilityMapsExplorationIsPending;
 - (_Bool)_accessibilityMapsExplorationIsActive;
 - (_Bool)_accessibilityIsTourGuideRunning;
 - (void)_accessibilitySetCameraIrisOpen:(_Bool)arg1;
 - (_Bool)_accessibilityCameraIrisOpen;
 - (_Bool)_accessibilityBasePerformOrbGesture:(long long)arg1;
 - (_Bool)_accessibilityPerformOrbGesture:(long long)arg1;
 - (_Bool)_accessibilityHasTextOperations;
 - (id)_accessibilityTextOperations;
 - (void)_accessibilitySpeak;
 - (void)_accessibilitySpeakSpellOut;
 - (void)_accessibilitySpeakSentence;
 - (void)_accessibilityRedo;
 - (void)_accessibilityUndo;
 - (void)_accessibilityUnderline;
 - (void)_accessibilityItalic;
 - (void)_accessibilityBold;
 - (void)_accessibilityShare;
 - (void)_accessibilityDefine;
 - (void)_accessibilityReplace;
 - (void)_accessibilityDelete;
 - (void)_accessibilitySelect;
 - (void)_accessibilityCopy;
 - (void)_accessibilityCut;
 - (void)_accessibilitySelectAll;
 - (void)_accessibilityPaste;
 - (_Bool)_accessibilityPerformEscape;
 - (id)_accessibilityCustomRotorResultHelper:(id)arg1 array:(id)arg2;
 - (_Bool)_accessibilityTextOperationAction:(id)arg1;
 - (void)accessibilityDecreaseTrackingDetail;
 - (void)accessibilityIncreaseTrackingDetail;
 - (void)accessibilityZoomOutAtPoint:(struct CGPoint)arg1;
 - (void)accessibilityZoomInAtPoint:(struct CGPoint)arg1;
 - (_Bool)_accessibilityPerformCustomActionWithIdentifier:(id)arg1;
 - (_Bool)accessibilityPerformCustomAction:(long long)arg1;
 - (void)_accessibilitySetCurrentGesture:(id)arg1;
 - (_Bool)_accessibilityEndUndoableTextInsertion;
 - (_Bool)_accessibilityBeginUndoableTextInsertion;
 - (id)_accessibilityTextViewTextOperationResponder;
 - (_Bool)accessibilityEditOperationAction:(id)arg1;
 - (id)accessibilityMenuActions;
 - (void)_accessibilitySetApplicationOrientation:(long long)arg1;
 - (long long)_accessibilityApplicationOrientation;
 - (_Bool)_accessibilityIsFrameOutOfBoundsConsideringScrollParents:(_Bool)arg1;
 - (struct CGRect)_axFrameForBoundsCheck:(_Bool)arg1;
 - (id)_axOutermostScrollParent;
 - (struct CGRect)_axScreenBoundsForBoundsCheck;
 - (_Bool)_accessibilityUseWindowBoundsForOutOfBoundsChecking;
 - (_Bool)_accessibilityIsFrameOutOfBounds;
 - (_Bool)_accessibilityOverridesInvalidFrames;
 - (id)_accessibilitySortPriorityContainer;
 - (_Bool)_accessibilityIsSortPriorityContainer;
 - (void)_accessibilitySetIsSortPriorityContainer:(_Bool)arg1;
 - (long long)_accessibilitySortPriority;
 - (void)_accessibilitySetSortPriority:(long long)arg1;
 - (struct CGRect)_accessibilityCompareFrameForScrollParent:(id)arg1 frame:(struct CGRect)arg2 fromOrientation:(long long)arg3 toOrientation:(long long)arg4;
 - (id)_accessibilityScrollParentForComparingByXAxis;
 - (_Bool)_accessibilityOnlyComparesByXAxis;
 - (struct CGRect)_accessibilityContentFrame;
 - (void)_accessibilitySetVisibleContentInset:(struct UIEdgeInsets)arg1;
 - (struct UIEdgeInsets)_accessibilityVisibleContentInset;
 - (struct CGAffineTransform)_accessibilityJailTransform;
 - (id)_accessibilityCirclePathBasedOnBoundsWidth;
 - (id)_accessibilityDisplayPathForScreenPath:(id)arg1;
 - (struct CGPoint)_accessibilityDisplayPointForSceneReferencePoint:(struct CGPoint)arg1;
 - (struct CGRect)_accessibilityDisplayRectForSceneReferenceRect:(struct CGRect)arg1;
 - (id)_accessibilityConvertSystemBoundedPathToContextSpace:(id)arg1;
 - (struct CGPoint)_accessibilityConvertSystemBoundedScreenPointToContextSpace:(struct CGPoint)arg1;
 - (struct CGRect)_accessibilityConvertSystemBoundedScreenRectToContextSpace:(struct CGRect)arg1;
 - (struct CGRect)_accessibilityVisibleFrame;
 - (long long)accessibilityCompareGeometry:(id)arg1;
 - (long long)_accessibilityOrientationForCompareGeometryForApplication:(id)arg1;
 - (void)_accessibilitySortElementsUsingGeometry:(id)arg1;
 - (id)_accessibilityGeometrySortedElements:(id)arg1;
 - (struct CGRect)_accessibilityFrameForSorting;
 - (struct CGRect)_accessibilityChildrenUnionContentFrame;
 - (_Bool)_accessibilityUsesChildrenFramesForSorting;
 - (struct CGRect)_handleRotatingFrame:(struct CGRect)arg1 fromOrientation:(long long)arg2 toOrientation:(long long)arg3;
 - (long long)_accessibilityCompareElement:(id)arg1 toElement:(id)arg2;
 - (long long)_accessibilitySortPriorityWithReturningElement:(id *)arg1;
 - (_Bool)_accessibilityOverridesInvisibility;
 - (void)_accessibilitySetOverridesInvisibility:(_Bool)arg1;
 - (double)_accessibilityAllowedGeometryOverlapX;
 - (double)_accessibilityAllowedGeometryOverlap;
 - (void)_accessibilitySetAllowedGeometryOverlap:(double)arg1;
 - (void)setAccessibilitySize:(struct CGSize)arg1;
 - (id)_accessibilityScannerElementsGrouped:(_Bool)arg1 shouldIncludeNonScannerElements:(_Bool)arg2;
 - (id)_accessibilityOrderedChildrenContainerWithinViews:(id)arg1;
 - (id)_accessibilityOrderedChildrenContainer;
 - (_Bool)_accessibilityShouldScrollRemoteParent;
 - (id)_accessibilityRemoteParent;
 - (id)_accessibilityVisibleElements;
 - (id)_accessibilityAuditIssuesWithOptions:(id)arg1;
 - (void)_accessibilitySetAuditIssueDict:(id)arg1;
 - (id)_accessibilityControlDescendantWithAction:(SEL)arg1;
 - (id)_accessibilityControlDescendantWithTarget:(id)arg1;
 - (id)_accessibilityFindUnsortedDescendantsPassingTest:(CDUnknownBlockType)arg1;
 - (id)_accessibilityFindUnsortedSubviewDescendantsPassingTest:(CDUnknownBlockType)arg1;
 - (id)_accessibilityFindSubviewDescendantsPassingTest:(CDUnknownBlockType)arg1;
 - (id)_accessibilityFindSubviewDescendant:(CDUnknownBlockType)arg1;
 - (id)_accessibilityFindDescendant:(CDUnknownBlockType)arg1;
 - (id)_accessibilityFindAncestor:(CDUnknownBlockType)arg1 startWithSelf:(_Bool)arg2;
 - (void)accessibilityEnumerateAncestorsUsingBlock:(CDUnknownBlockType)arg1;
 - (id)_accessibilityFindAXDescendants:(CDUnknownBlockType)arg1 byAddingElements:(CDUnknownBlockType)arg2;
 - (id)_accessibilityFindAnyAXDescendant:(CDUnknownBlockType)arg1 byAddingElements:(CDUnknownBlockType)arg2;
 - (id)_accessibilityAncestorIsAccessibilityElementsHidden;
 - (id)_accessibilityAncestorIsKindOf:(Class)arg1;
 - (id)_accessibilityViewAncestorIsKindOf:(Class)arg1;
 - (id)_accessibilityFindViewAncestor:(CDUnknownBlockType)arg1 startWithSelf:(_Bool)arg2;
 - (_Bool)_accessibilityIsDescendantOfElement:(id)arg1;
 - (_Bool)_accessibilityIsViewDescendantOfElement:(id)arg1;
 - (id)accessibilityViewWithIdentifier:(id)arg1;
 - (id)_accessibilityUnignoredDescendant;
 - (_Bool)_accessibilityHasDescendantOfType:(Class)arg1;
 - (id)_accessibilityDescendantOfType:(Class)arg1;
 - (id)_accessibilityVisibleOpaqueElements;
 - (id)_accessibilitySearchSubtreesAfterChildElement:(id)arg1 direction:(long long)arg2 searchType:(long long)arg3 allowOutOfBoundsChild:(_Bool)arg4 range:(struct _NSRange)arg5 shouldScrollToVisible:(_Bool)arg6;
 - (id)_accessibilityFocusAbsoluteLastOpaqueElementForTechnology:(id)arg1;
 - (id)_accessibilityFocusAbsoluteFirstOpaqueElementForTechnology:(id)arg1;
 - (_Bool)_accessibilityOpaqueScrollViewSupportsLastResortScrollBeyondBounds;
 - (id)_accessibilitySortedElementsWithin;
 - (void)_accessibilityOpaqueElementScrollToDirection:(long long)arg1;
 - (id)_accessibilityFindElementInDirection:(long long)arg1 searchType:(long long)arg2 allowOutOfBoundsChild:(_Bool)arg3 startingTouchContainer:(id)arg4;
 - (id)_accessibilityFindElementInDirection:(long long)arg1 searchType:(long long)arg2 allowOutOfBoundsChild:(_Bool)arg3;
 - (void)_accessibilityOpaqueElementScrollCleanup;
 - (double)_accessibilityLeftOpaqueScrollViewContentOffsetLimit;
 - (double)_accessibilityRightOpaqueScrollViewContentOffsetLimit;
 - (struct CGPoint)_accessibilityOffsetForOpaqueElementDirection:(long long)arg1;
 - (void)_accessibilityScrollOpaqueElementIntoView:(long long)arg1 previousScroller:(id)arg2;
 - (_Bool)_accessibilityOpaqueElementScrollsContentIntoView;
 - (void)_accessibilitySetOpaqueElementScrollsContentIntoView:(_Bool)arg1;
 - (id)_accessibilityMoveFocusToNextOpaqueElementForTechnology:(id)arg1 direction:(long long)arg2 searchType:(long long)arg3 range:(struct _NSRange)arg4 shouldScrollToVisible:(_Bool)arg5;
 - (id)_accessibilityMoveFocusToNextOpaqueElementForTechnology:(id)arg1 direction:(long long)arg2 searchType:(long long)arg3 range:(struct _NSRange)arg4;
 - (id)_accessibilityOpaqueHeaderElementInDirection:(long long)arg1 childElement:(id)arg2;
 - (id)_accessibilityLastOpaqueElement;
 - (id)_accessibilityFirstOpaqueElementForFocus;
 - (id)_accessibilityFirstOpaqueElement;
 - (id)_accessibilityOpaqueElementParent;
 - (_Bool)isAccessibilityOpaqueElementProvider;
 - (void)_accessibilitySetWantsOpaqueElementProviders:(_Bool)arg1;
 - (_Bool)_accessibilityWantsOpaqueElementProviders;
 - (void)_accessibilitySetShouldIgnoreOpaqueElementProviders:(_Bool)arg1;
 - (_Bool)_accessibilityShouldIgnoreOpaqueElementProviders;
 - (void)_accessibilitySetContainerToStopVisibilityCheck:(id)arg1;
 - (id)_accessibilityContainerToStopVisibilityCheck;
 - (void)setIsAccessibilityOpaqueElementProvider:(_Bool)arg1;
 - (_Bool)_accessibilityDidSetOpaqueElementProvider;
 - (void)_accessibilitySetPagingEnabled:(_Bool)arg1;
 - (id)_accessibilityPagingEnabled;
 - (void)_accessibilitySetAllowedPagingOverlap:(double)arg1;
 - (id)_accessibilityAllowedPagingOverlap;
 - (void)_accessibilitySetScrollAcrossPageBoundaries:(_Bool)arg1;
 - (_Bool)_accessibilityScrollAcrossPageBoundaries;
 - (_Bool)_accessibilityRetainsCustomRotorActionSetting;
 - (id)_accessibilityElementsForSearchParameter:(id)arg1;
 - (id)accessibilityTitleElement;
 - (id)_accessibilityHeaderElement;
 - (_Bool)_accessibilityDescendantElementAtIndexPathIsValid:(id)arg1;
 - (_Bool)_accessibilityShouldAvoidScrollingCollectionViewCells;
 - (_Bool)_accessibilitySortCollectionViewLogically;
 - (void)_accessibilityDidChangeSonificationPlaybackPosition:(double)arg1;
 - (_Bool)_accessibilityDataSeriesIncludesTrendlineInSonification;
 - (_Bool)_accessibilityDataSeriesSupportsSonification;
 - (_Bool)_accessibilityDataSeriesSupportsSummarization;
 - (id)_accessibilityDataSeriesValueDescriptionForPosition:(double)arg1 axis:(long long)arg2;
 - (id)_accessibilityDataSeriesCategoryLabelsForAxis:(long long)arg1;
 - (id)_accessibilityDataSeriesGridlinePositionsForAxis:(long long)arg1;
 - (id)_accessibilityDataSeriesMaximumValueForAxis:(long long)arg1;
 - (id)_accessibilityDataSeriesMinimumValueForAxis:(long long)arg1;
 - (id)_accessibilityDataSeriesUnitLabelForAxis:(long long)arg1;
 - (id)_accessibilityDataSeriesTitleForAxis:(long long)arg1;
 - (double)_accessibilityDataSeriesSonificationDuration;
 - (long long)_accessibilityDataSeriesType;
 - (id)_accessibilityDataSeriesValuesForAxis:(long long)arg1;
 - (id)_accessibilityDataSeriesName;
 - (void)_fkaMoveRight;
 - (void)_fkaMoveLeft;
 - (void)_fkaMoveDown;
 - (void)_fkaMoveUp;
 - (_Bool)_accessibilityHandlesTabKey;
 - (_Bool)_accessibilityShouldIncludeArrowKeyCommandsForDirectionalFocusMovement;
 - (_Bool)_accessibilityKeyCommandsShouldOverrideKeyCommands;
 - (id)_accessibilityKeyCommands;
 - (_Bool)_accessibilityIsFKARunningForFocusItem;
 - (long long)_accessibilityInterfaceOrientationForScreenCoordinates;
 - (_Bool)_accessibilityIsUsingRemoteParentActivateAction;
 - (id)_accessibilityElementCommunityIdentifier;
 - (_Bool)_accessibilityIsIsolatedWindow;
 - (_Bool)_accessibilityIsAccessibilityUIServer;
 - (_Bool)_accessibilityIsInternationalKeyboardKey;
 - (_Bool)_accessibilityAllowsAlternativeCharacterActivation;
 - (id)_accessibilityInputIdentifierForKeyboard;
 - (id)_accessibilityRetrieveImagePathLabel:(id)arg1;
 - (id)_accessibilityStatusBar;
 - (unsigned int)_accessibilityDisplayId;
 - (id)_accessibilityApplicationWindowContextIDs;
 - (unsigned int)_accessibilityContextId;
 - (id)_accessibilityParentView;
 - (id)_accessibilityWindow;
 - (_Bool)_accessibilityUsesSpecialKeyboardDismiss;
 - (id)_accessibilityRemoteApplication;
 - (void)_accessibilityRegisterForDictationLifecycleNotifications;
 - (id)_accessibilityApplication;
 - (void)_setAccessibilityTableCellUsesDetailTextAsValue:(_Bool)arg1;
 - (_Bool)_accessibilityTableCellUsesDetailTextAsValue;
 - (_Bool)_accessibilityAlternateActionForURL:(id)arg1;
 - (id)_accessibilityHitTestingObscuredScreenAllowedViews;
 - (id)_accessibilityObscuredScreenAllowedViews;
 - (void)_accessibilityChangeToKeyplane:(id)arg1;
 - (id)_accessibilityKeyboardKeyForString:(id)arg1;
 - (id)_accessibilityCellWithRowIndex:(long long)arg1 column:(long long)arg2 containingView:(id)arg3;
 - (_Bool)_accessibilityRespectsTableScrollEnabledFlag;
 - (_Bool)_accessibilityKeyboardKeyHasSignificantAlternateActions;
 - (_Bool)_accessibilityHasVariantKeys;
 - (id)_accessibilityVariantKeys;
 - (_Bool)_accessibilityDidDeleteTableViewCell;
 - (_Bool)_accessibilityCanDeleteTableViewCell;
 - (_Bool)_accessibilityContainedByTableLogicIsEnabledOutsideOfWebContext;
 - (_Bool)_accessibilityCanDismissPopoverController:(id)arg1;
 - (id)_accessibilityNotificationSummary:(unsigned long long)arg1;
 - (unsigned long long)_accessibilityNotificationCount;
 - (_Bool)_accessibilityIsAwayAlertElementNew;
 - (_Bool)_accessibilityIsAwayAlertElement;
 - (void)_accessibilitySwitchOrderedChildrenFrom:(id)arg1;
 - (void)_accessibilityJumpToTableIndex:(id)arg1;
 - (_Bool)_accessibilityLoadURL:(id)arg1;
 - (void)_accessibilityFindSearchResult:(_Bool)arg1 withString:(id)arg2;
 - (_Bool)_accessibilityIsInCollectionCell;
 - (_Bool)_accessibilityIsInTableCell;
 - (_Bool)_accessibilityIsTableCell;
 - (id)_accessibilityResponderElement;
 - (_Bool)_accessibilityServesAsFirstResponder;
 - (id)_accessibilityCollectionViewCellContentSubviews;
 - (id)_accessibilityTableViewCellContentSubviews;
 - (void)_accessibilitySetAdditionalElements:(id)arg1;
 - (id)_accessibilityAdditionalElements;
 - (void)_accessibilitySetUserDefinedAdditionalElements:(id)arg1;
 - (id)_accessibilityUserDefinedAdditionalElements;
 - (id)_accessibilitySupplementaryFooterViews;
 - (id)_accessibilitySupplementaryHeaderViews;
 - (_Bool)_accessibilityIsFirstElementForFocus;
 - (struct _NSRange)accessibilityColumnRange;
 - (unsigned long long)_accessibilityRowCount;
 - (_Bool)_accessibilityShouldIncludeRowRangeInElementDescription;
 - (struct _NSRange)_accessibilityRowRange;
 - (struct _NSRange)_accessibilityColumnRange;
 - (unsigned long long)_accessibilityColumnCount;
 - (void)_accessibilitySetRowRange:(struct _NSRange)arg1;
 - (struct _NSRange)accessibilityRowRange;
 - (id)_accessibilityParentCollectionView;
 - (id)_accessibilityParentTableView;
 - (struct _NSRange)_accessibilityIndexPathAsRange;
 - (id)_accessibilityIndexPath;
 - (_Bool)_accessibilityKeyboardIsContinuousPathAvailable;
 - (_Bool)_accessibilityKeyboardIsContinuousPathTracking;
 - (id)accessibilityDataTableCellElementForRow:(unsigned long long)arg1 column:(unsigned long long)arg2;
 - (id)accessibilityElementForRow:(unsigned long long)arg1 andColumn:(unsigned long long)arg2;
 - (void)_accessibilitySetContextDescriptors:(id)arg1;
 - (id)_accessibilityContextDescriptors;
 - (id)_accessibilityAllContextDescriptors;
 - (_Bool)_accessibilityCanBeFirstResponder;
 - (_Bool)_accessibilityCanBeFirstResponderWhenNotAnElement;
 - (_Bool)_accessibilityShouldSuppressCustomActionsHint;
 - (_Bool)_accessibilityIsRemoteElement;
 - (id)_accessibilityPreferredScrollActions;
 - (id)_accessibilityTraitsInspectorHumanReadable;
 - (id)_accessibilityTraitsAsHumanReadableStrings:(unsigned long long)arg1;
 - (unsigned long long)_accessibilityInheritedTraits;
 - (_Bool)_accessibilityShouldInheritTraits;
 - (id)_accessibilityRetrieveLocalizedStringTableName;
 - (id)_accessibilityRetrieveLocalizationBundlePath;
 - (id)_accessibilityRetrieveLocalizationBundleID;
 - (id)_accessibilityRetrieveLocalizedStringKey;
 - (id)_getAccessibilityAttributedString;
 - (void)_iosAccessibilitySetValue:(id)arg1 forAttribute:(long long)arg2;
 - (id)_iosAccessibilityAttributeValue:(long long)arg1;
 - (long long)_accessibilityReinterpretVoiceOverCommand:(long long)arg1;
 - (struct CGRect)accessibilityElementRect;
 - (struct CGRect)_accessibilityFocusableFrameForZoom;
 - (id)__accessibilityRetrieveFrameOrPathDelegate;
 - (double)_accessibilityMagnifierZoomLevel;
 - (id)_accessibilityTextualContext;
 - (id)_iosAccessibilityAttributeValue:(long long)arg1 forParameter:(id)arg2;
 - (id)_accessibilityProcessElementsInDirection:(long long)arg1 forParameter:(id)arg2;
 - (id)_accessibilityProcessChildrenForParameter:(id)arg1;
 - (id)_accessibilityGroupedParent;
 - (id)_accessibilityElementHelp;
 - (void)_accessibilitySetElementHelp:(id)arg1;
 - (_Bool)_accessibilityIsGroupedParent;
 - (id)_accessibilityAXAttributedUserInputLabelsIncludingFallbacks;
 - (id)_accessibilityAXAttributedUserInputLabels;
 - (id)_accessibilityAXAttributedHint;
 - (id)_accessibilityAXAttributedValue;
 - (id)_accessibilityAXAttributedLabel;
 - (id)_accessibilityPotentiallyAttributedValueForNonAttributedSelector:(SEL)arg1 attributedSelector:(SEL)arg2;
 - (void)_accessibilityWarmPrefersNonAttributedLabelValueHintCache;
 - (_Bool)_accessibilityPrefersNonAttributedHint;
 - (_Bool)_accessibilityPrefersNonAttributedValue;
 - (_Bool)_accessibilityPrefersNonAttributedLabel;
 - (_Bool)_accessibilityPrefersNonAttributedAttributeWithOverrideSelector:(SEL)arg1 nonAttributedSelector:(SEL)arg2 attributedSelector:(SEL)arg3;
 - (_Bool)_accessibilityAlwaysNo;
 - (_Bool)_accessibilityAlwaysYes;
 - (CDUnknownFunctionPointerType)impOrNullForSelector:(SEL)arg1;
 - (SEL)_accessibilityPotentiallyAttributedSelectorForNonAttributedSelector:(SEL)arg1 attributedSelector:(SEL)arg2;
 - (_Bool)_accessibilityOverridesPotentiallyAttributedAPISelector:(SEL)arg1;
 - (_Bool)_accessibilitySpeakThisIgnoresAccessibilityElementStatus;
 - (id)_accessibilityPostProcessValueForAutomation:(id)arg1;
 - (id)_accessibilityProcessedLabelAttribute;
 - (id)_accessibilitySpeakThisString;
 - (id)_accessibilitySpeakThisStringValue;
 - (void)_accessibilitySetIsSpeakThisElement:(_Bool)arg1;
 - (_Bool)_accessibilityIsSpeakThisElement;
 - (void)_accessibilityRawSetIsSpeakThisElement:(id)arg1;
 - (id)_accessibilityRawIsSpeakThisElement;
 - (void)_accessibilitySetRoleDescription:(id)arg1;
 - (id)_accessibilityRoleDescription;
 - (id)_accessibilityEquivalenceTag;
 - (id)_accessibilityBriefLabel;
 - (_Bool)_accessibilityIsStrongPasswordField;
 - (_Bool)_accessibilityUseElementAtPositionAfterActivation;
 - (_Bool)_accessibilityUpdatesOnActivationAfterDelay;
 - (double)_accessibilityDelayBeforeUpdatingOnActivation;
 - (void)_setAccessibilityUpdatesOnActivationAfterDelay:(_Bool)arg1;
 - (id)_accessibilityVisibleItemInList;
 - (id)_accessibilityFirstVisibleItem;
 - (id)_accessibilityCustomActionNamesAndIdentifiers;
 - (id)_accessibilityPublicCustomRotors;
 - (void)_addPublicRotorsToArray:(id)arg1 forElement:(id)arg2;
 - (id)_accessibilityPublicCustomRotorName:(id)arg1;
 - (_Bool)_accessibilityPublicCustomRotorVisibleInTouchRotor:(id)arg1;
 - (id)_accessibilityHeaderElementsForRow:(unsigned long long)arg1;
 - (id)accessibilityHeaderElementsForRow:(unsigned long long)arg1;
 - (id)_accessibilityHeaderElementsForColumn:(unsigned long long)arg1;
 - (id)accessibilityHeaderElementsForColumn:(unsigned long long)arg1;
 - (id)_accessibilityPublicCustomRotorIdForSystemType:(id)arg1;
 - (long long)_accessibilityCustomRotorTypeForString:(id)arg1;
 - (id)_accessibilityRotorTypeStringForCustomRotor:(long long)arg1;
 - (id)_accessibilityPerformPublicCustomRotorSearch:(id)arg1 searchDirection:(long long)arg2 currentItem:(id)arg3;
 - (id)_accessibilityNextElementsForSpeakThis;
 - (id)_accessibilitySpeakThisLeafDescendants;
 - (id)_accessibilityFirstElementsForSpeakThis;
 - (id)_accessibilityFirstElement;
 - (id)_accessibilityFirstElementForFocus;
 - (void)_setAccessibilityIsNotFirstElement:(_Bool)arg1;
 - (_Bool)_accessibilityIsNotFirstElement;
 - (void)_setAccessibilityServesAsFirstElement:(_Bool)arg1;
 - (_Bool)_accessibilityServesAsFirstElement;
 - (_Bool)_accessibilityIsStarkElement;
 - (_Bool)_accessibilityIsVisibleByCompleteHitTest;
 - (struct CGPoint)_accessibilityVisiblePointHitTestingAnyElement:(_Bool)arg1;
 - (struct CGPoint)_accessibilityVisiblePoint;
 - (struct CGRect)accessibilityVisibleContentRect;
 - (_Bool)_accessibilityVisiblePointHonorsScreenBounds;
 - (id)_accessibilityImageData;
 - (_Bool)_accessibilityTouchContainerShouldOutputBraille;
 - (_Bool)accessibilitySupportsTextSelection;
 - (id)_accessibilityTouchContainerStartingWithSelf:(_Bool)arg1;
 - (id)_accessibilityTouchContainer;
 - (_Bool)_accessibilityIsMap;
 - (_Bool)_accessibilityIsGuideElement;
 - (void)_accessibilitySetUserDefinedIsGuideElement:(_Bool)arg1;
 - (_Bool)_accessibilityUserDefinedIsGuideElement;
 - (_Bool)_accessibilityIsTouchContainer;
 - (void)_accessibilityAddTrait:(unsigned long long)arg1;
 - (void)_accessibilityRemoveTrait:(unsigned long long)arg1;
 - (id)_accessibilityCustomActions;
 - (id)_retrieveCustomActionsForElement:(id)arg1;
 - (_Bool)_accessibilityPerformLegacyCustomAction:(id)arg1;
 - (id)_privateAccessibilityCustomActions;
 - (void)_accessibilitySetPrivateCustomActionsElement:(id)arg1;
 - (id)_accessibilityPrivateCustomActionsElement;
 - (_Bool)_accessibilityIsDictating;
 - (id)_accessibilitySoftwareMimicKeyboard;
 - (_Bool)_accessibilityIsSoftwareKeyboardMimic;
 - (id)_accessibilityAccessibleAncestor;
 - (id)_accessibilityStringForLabelKeyValues:(id)arg1;
 - (id)_accessibilityWatchAutoSpeakElements;
 - (id)_accessibilityAccessibleDescendants;
 - (id)_accessibilityActiveKeyboard;
 - (id)_accessibilityInternalTextLinkCustomRotors;
 - (id)_accessibilityInternalTextLinks;
 - (unsigned long long)accessibilityARIAColumnCount;
 - (unsigned long long)accessibilityARIARowCount;
 - (unsigned long long)accessibilityColumnCount;
 - (unsigned long long)accessibilityRowCount;
 - (unsigned long long)accessibilityARIAColumnIndex;
 - (unsigned long long)accessibilityARIARowIndex;
 - (_Bool)_accessibilityCanDisplayMultipleControllers;
 - (struct CGRect)_accessibilityDirectInteractionFrame;
 - (_Bool)_accessibilityBannerIsSticky;
 - (id)_accessibilityCurrentStatus;
 - (id)_accessibilityViewController;
 - (_Bool)_accessibilityOverridesInstructionsHint;
 - (_Bool)_accessibilityOpaqueElementProvider;
 - (unsigned long long)accessibilityBlockquoteLevel;
 - (id)accessibilityFlowToElements;
 - (_Bool)_accessibilityShouldAvoidAnnouncing;
 - (_Bool)_accessibilityLastHitTestNearBorder;
 - (id)_accessibilityBundleIdentifier;
 - (id)accessibilityMathEquation;
 - (_Bool)_accessibilityIsMathTouchExplorationView;
 - (_Bool)_accessibilityShouldSpeakMathEquationTrait;
 - (id)accessibilityMathMLSource;
 - (id)accessibilitySecondaryLabel;
 - (float)_accessibilityActivationDelay;
 - (_Bool)_accessibilityIsUserInteractionEnabled;
 - (_Bool)_allowCustomActionHintSpeakOverride;
 - (_Bool)_accessibilitySupportsMultipleCustomRotorTitles;
 - (id)_accessibilityAppSwitcherApps;
 - (id)_accessibilityLaunchableApps;
 - (id)_accessibilityContainerTypes;
 - (_Bool)_accessibilityHasBadge;
 - (_Bool)_accessibilityIsInFolder;
 - (_Bool)_accessibilityIsInAppSwitcher;
 - (_Bool)_accessibilityAlwaysSpeakTableHeaders;
 - (_Bool)_accessibilityIsTitleElement;
 - (_Bool)_accessibilityIsLastSiblingForType:(unsigned long long)arg1;
 - (_Bool)_accessibilityIsFirstSiblingForType:(unsigned long long)arg1;
 - (_Bool)_accessibilityIsLastSibling;
 - (_Bool)_accessibilityIsFirstSibling;
 - (_Bool)_accessibilitySiblingWithAncestor:(id)arg1 isFirst:(_Bool)arg2 isLast:(_Bool)arg3;
 - (_Bool)_accessibilitySiblingWithAncestor:(id)arg1 isFirst:(_Bool)arg2 isLast:(_Bool)arg3 sawAXElement:(_Bool *)arg4;
 - (id)_accessibilityAncestorForSiblingsWithType:(unsigned long long)arg1;
 - (id)_axAncestorTypes;
 - (unsigned long long)axContainerTypeFromUIKitContainerType:(long long)arg1;
 - (_Bool)_accessibilityElementShouldBeInvalid;
 - (_Bool)_accessibilityCanPerformEscapeAction;
 - (_Bool)_accessibilitySupportsActivateAction;
 - (_Bool)_accessibilityAlwaysOrderedFirst;
 - (id)_accessibilitySupportGesturesAttributes;
 - (id)accessibilityLinkedElement;
 - (id)accessibilityPlaceholderValue;
 - (_Bool)_accessibilitySupportsDirectioOrbManipulation;
 - (id)_accessibilityHorizontalScrollBarElement;
 - (_Bool)_accessibilityIsScrollBarIndicator;
 - (long long)_accessibilityOrientation;
 - (id)_accessibilityVerticalScrollBarElement;
 - (id)_accessibilityUserDefinedGuideElementHeaderText;
 - (void)_setAccessibilityGuideElementHeaderText:(id)arg1;
 - (id)_accessibilityRetieveHeaderElementText;
 - (id)_accessibilityGuideElementHeaderText;
 - (id)_accessibilityUserDefinedLinkedUIElements;
 - (void)_setAccessibilityLinkedUIElements:(id)arg1;
 - (id)_accessibilityLinkedUIElements;
 - (id)_accessibilityRetrieveLinkedUIElementsFromContainerChain;
 - (id)accessibilityHeaderElements;
 - (_Bool)_accessibilityCanPerformAction:(int)arg1;
 - (_Bool)__accessibilitySupportsSecondaryActivateAction;
 - (id)_accessibilityHeadingLevel;
 - (_Bool)__accessibilitySupportsActivateAction;
 - (void)_accessibilitySetShouldPreventOpaqueScrolling:(_Bool)arg1;
 - (_Bool)_accessibilityShouldPreventOpaqueScrolling;
 - (id)_accessibilitySwipeIslandIdentifier;
 - (id)_accessibilitySwipeIsland;
 - (void)_accessibilityUpdateContainerElementReferencesIfNeededForNewElements:(id)arg1;
 - (void)_accessibilitySetLastElementsUpdatedWithContainerElementReferences:(id)arg1;
 - (id)_accessibilityLastElementsUpdatedWithContainerElementReferences;
 - (id)_accessibilityElements;
 - (id)_accessibilityGuideElementInDirection:(_Bool)arg1;
 - (id)_accessibilityContainerInDirection:(_Bool)arg1;
 - (id)_accessibilityContainingParentForOrdering;
 - (_Bool)_accessibilityHasOrderedChildren;
 - (void)accessibilityEnumerateContainerElementsUsingBlock:(CDUnknownBlockType)arg1;
 - (void)accessibilityEnumerateContainerElementsWithOptions:(unsigned long long)arg1 usingBlock:(CDUnknownBlockType)arg2;
 - (_Bool)accessibilityShouldEnumerateContainerElementsArrayDirectly;
 - (void)_accessibilityResetContainerElements;
 - (_Bool)_accessibilityUsesScrollParentForOrdering;
 - (void)_accessibilitySetUsesScrollParentForOrdering:(_Bool)arg1;
 - (_Bool)_accessibilityServesAsContainingParentForOrdering;
 - (id)_accessibilityContainerForAccumulatingCustomRotorItems;
 - (id)accessibilityContainerElements;
 - (struct CGRect)_accessibilityMediaAnalysisFrame;
 - (unsigned int)_accessibilityEffectiveMediaAnalysisOptions;
 - (unsigned int)_accessibilityMediaAnalysisOptions;
 - (void)_accessibilitySetUserDefinedMediaAnalysisOptions:(id)arg1;
 - (id)_accessibilityUserDefinedMediaAnalysisOptions;
 - (_Bool)_accessibilityFrameSupportsMediaAnalysis;
 - (double)_accessibilityViewAlpha;
 - (double)_accessibilityFontSize;
 - (double)_accessibilityZoomScale;
 - (id)_accessibilityParentForFindingScrollParent;
 - (id)_accessibilityScrollParent;
 - (_Bool)_accessibilityScrollDownPage;
 - (_Bool)_accessibilityScrollUpPage;
 - (_Bool)_accessibilityScrollPreviousPage;
 - (_Bool)_accessibilityScrollNextPage;
 - (_Bool)_accessibilityScrollRightPage;
 - (_Bool)_accessibilityScrollLeftPage;
 - (SEL)_accessibilityScrollSelectorForDirection:(long long)arg1;
 - (_Bool)_accessibilityScrollPageInDirection:(long long)arg1 shouldSendScrollFailed:(_Bool)arg2;
 - (_Bool)_accessibilityTryScrollWithSelector:(SEL)arg1 shouldSendScrollFailed:(_Bool)arg2;
 - (void)_accessibilitySendPageScrollFailedIfNecessary;
 - (_Bool)_accessibilityHandlePublicScroll:(long long)arg1;
 - (struct CGPoint)_accessibilityScrollRectToVisible:(struct CGRect)arg1;
 - (void)_accessibilityScrollToPoint:(struct CGPoint)arg1;
 - (_Bool)_animateScrollViewWithMachPort:(unsigned int)arg1 amount:(double)arg2 point:(struct CGPoint)arg3;
 - (_Bool)_accessibilitySavePhotoLabel:(id)arg1;
 - (_Bool)_accessibilityShouldAttemptScrollToFrameOnParentView;
 - (_Bool)_accessibilityBaseScrollToVisible;
 - (_Bool)_accessibilityViewControllerShouldPreventScrollToVisibleForElement:(id)arg1;
 - (_Bool)_accessibilityScrollToVisible;
 - (_Bool)_accessibilityScrollToVisibleForNextElementRetrieval:(long long)arg1;
 - (_Bool)_accessibilityShowContextMenu;
 - (struct CGPoint)_accessibilityContentOffset;
 - (_Bool)_accessibilityCanScrollInAtLeastOneDirection;
 - (id)_accessibilityTabBarAncestor;
 - (id)_accessibililtyLabelForTabBarButton:(id)arg1;
 - (_Bool)_accessibilityIsInTabBar;
 - (void)_axSetCachedHasTabBarAncestor:(id)arg1;
 - (id)_axCachedHasTabBarAncestor;
 - (_Bool)_accessibilityIsScrollable;
 - (unsigned long long)_accessibilityNativeTraits;
 - (_Bool)_accessibilityIsEscapable;
 - (_Bool)_accessibilityIterateParentsForTestBlock:(CDUnknownBlockType)arg1;
 - (id)_accessibilityScrollAncestorForSelector:(SEL)arg1 alwaysAllowRefreshAction:(_Bool)arg2;
 - (_Bool)_accessibilityUpdatesSwitchMenu;
 - (double)_accessibilityVisibleItemDenominator;
 - (id)_accessibilityScrollAncestorForSelector:(SEL)arg1;
 - (id)_accessibilityScrollStatus;
 - (_Bool)_accessibilityElementVisibilityAffectsLayout;
 - (_Bool)_accessibilityShouldSpeakScrollStatusOnEntry;
 - (void)setIsAccessibilityScrollAncestor:(_Bool)arg1;
 - (id)_accessibilityScrollAncestor;
 - (struct CGPoint)__accessibilityVisibleScrollArea:(_Bool)arg1;
 - (void)_accessibilityIterateScrollParentsUsingBlock:(CDUnknownBlockType)arg1 includeSelf:(_Bool)arg2;
 - (void)_accessibilityIterateScrollParentsUsingBlock:(CDUnknownBlockType)arg1;
 - (id)_accessibilityTextFieldText;
 - (id)_accessibilityResponderChainForKeyWindow;
 - (id)_accessibilityResponderChainForWindow:(id)arg1;
 - (id)_accessibilityFirstResponderForWindow:(id)arg1;
 - (id)_accessibilityFirstResponderForKeyWindow;
 - (_Bool)_accessibilityRepresentsInfiniteCollection;
 - (long long)_accessibilityExpandedStatus;
 - (id)accessibilityLinkRelationshipType;
 - (_Bool)_accessibilityIsPressed;
 - (_Bool)_accessibilitySupportsPressedState;
 - (_Bool)_accessibilityIsWebDocumentView;
 - (_Bool)_accessibilityShouldUseViewHierarchyForFindingScrollParent;
 - (_Bool)accessibilityScrollToTopSupported;
 - (_Bool)accessibilityScrollUpPageSupported;
 - (_Bool)accessibilityScrollDownPageSupported;
 - (_Bool)accessibilityScrollRightPageSupported;
 - (_Bool)accessibilityScrollLeftPageSupported;
 - (_Bool)_accessibilityScrollToFrame:(struct CGRect)arg1 forView:(id)arg2;
 - (_Bool)_accessibilityIsScrollAncestor;
 - (_Bool)_accessibilityScrollingEnabled;
 - (void)_accessibilitySetScrollingEnabled:(_Bool)arg1;
 - (void)_accessibilitySetUserDefinedScrollingEnabled:(id)arg1;
 - (id)_accessibilityUserDefinedScrollingEnabled;
 - (long long)_accessibilityPageIndex;
 - (long long)_accessibilityPageCount;
 - (_Bool)accessibilityScrollLeftPage;
 - (_Bool)accessibilityScrollRightPage;
 - (_Bool)accessibilityScrollDownPage;
 - (_Bool)accessibilityScrollUpPage;
 - (struct CGRect)accessibilityFrameForScrolling;
 - (struct _NSRange)_accessibilityRawRangeForUITextRange:(id)arg1;
 - (id)_accessibilityTextRangeFromNSRange:(struct _NSRange)arg1;
 - (struct _NSRange)_accessibilityTextInputElementRangeAsNSRange;
 - (id)_accessibilityTextInputElementRange;
 - (id)_accessibilityTextInputElement;
 - (void)_setAccessibilityIsMainWindow:(_Bool)arg1;
 - (_Bool)_accessibilityCanBeConsideredAsMainWindow;
 - (_Bool)_accessibilityIsMainWindow;
 - (void)_setAccessibilityWindowVisible:(_Bool)arg1;
 - (_Bool)_accessibilityWindowVisible;
 - (void)_setAccessibilityEncodedHierarchyData:(id)arg1;
 - (id)_accessibilityEncodedHierarchyData;
 - (_Bool)_accessibilitySelfFoundByHitTesting;
 - (id)_accessibilityBaseHitTest:(struct CGPoint)arg1 withEvent:(id)arg2;
 - (_Bool)_accessibilityAllowOutOfBoundsHitTestAtPoint:(struct CGPoint)arg1 withEvent:(id)arg2;
 - (id)_accessibilityHitTestSupplementaryViews:(id)arg1 point:(struct CGPoint)arg2 withEvent:(id)arg3;
 - (id)_accessibilityHitTestSupplementaryViews:(struct CGPoint)arg1 event:(id)arg2;
 - (id)_accessibilityHitTestAdditionalElements:(struct CGPoint)arg1 event:(id)arg2;
 - (id)_accessibilityHitTest:(struct CGPoint)arg1 withEvent:(id)arg2;
 - (void)_accessibilitySetShouldHitTestFallBackToNearestChild:(_Bool)arg1;
 - (_Bool)_accessibilityHitTestShouldFallbackToNearestChild;
 - (id)_accessibilityFuzzyHitTestElements;
 - (_Bool)_accessibilityHitTestReverseOrder;
 - (_Bool)accessibilityStartStopToggle;
 - (_Bool)_accessibilitySecondaryActivate;
 - (void)accessibilityDecrement;
 - (void)accessibilityIncrement;
 - (id)accessibilityHitTest:(struct CGPoint)arg1;
 - (void)accessibilitySetValue:(id)arg1 forAttribute:(long long)arg2;
 - (_Bool)accessibilityPerformAction:(int)arg1 withValue:(id)arg2 fencePort:(unsigned int)arg3;
 - (id)accessibilityAttributeValue:(long long)arg1 forParameter:(id)arg2;
 - (id)accessibilityAttributeValue:(long long)arg1;
 - (void)_accessibilityAutoscrollScrollToBottom;
 - (void)_accessibilityAutoscrollScrollToTop;
 - (void)_accessibilityDecreaseAutoscrollSpeed;
 - (void)_accessibilityIncreaseAutoscrollSpeed;
 - (void)_accessibilityPauseAutoscrolling;
 - (void)_accessibilityAutoscrollInDirection:(unsigned long long)arg1;
 - (_Bool)_accessibilityIsAutoscrolling;
 - (unsigned long long)_accessibilityAvailableAutoscrollDirections;
 - (id)_accessibilityAutoscrollTarget;
 - (void)_accessibilitySetAutoscrollTarget:(id)arg1;
 - (id)_accessibilityProxyView;
 - (id)_accessibilityProxyViewAncestorWhenMissingWindow;
 - (_Bool)_accessibilityApplicationHandleButtonAction:(int)arg1;
 - (id)_accessibilitySiriContentElementsWithSemanticContext;
 - (id)_accessibilityElementsWithSemanticContext:(id)arg1;
 - (id)_accessibilitySupplementaryHeaderViewAtIndexPath:(id)arg1;
 - (id)_accessibilityAncestorFocusParcel;
 - (id)_accessibilityExtendedLabelForFocusParcelWithLabel:(id)arg1;
 - (unsigned long long)_accessibilityFocusParcelChildrenCount:(unsigned long long)arg1;
 - (_Bool)_accessibilityIsFocusParcel;
 - (id)_accessibilityTextForSubhierarchyIncludingHeaders:(_Bool)arg1 focusableItems:(_Bool)arg2 exclusions:(id)arg3 classExclusions:(id)arg4;
 - (id)_accessibilityTextForSubhierarchyIncludingHeaders:(_Bool)arg1 focusableItems:(_Bool)arg2 exclusions:(id)arg3;
 - (id)_accessibilitySubviews;
 - (_Bool)_isAccessibilityExplorerElement;
 - (id)_accessibilitySortExplorerElements:(id)arg1;
 - (unsigned long long)_accessibilityExplorerElementReadPriority;
 - (id)_accessibilityFrameDelegate;
 - (id)_accessibilitySiriContentNativeFocusableElements;
 - (id)_accessibilityNativeFocusableElements:(id)arg1 matchingBlock:(CDUnknownBlockType)arg2;
 - (id)_accessibilityNativeFocusableElements:(id)arg1 withQueryString:(id)arg2;
 - (id)_accessibilityNativeFocusableElements:(id)arg1;
 - (id)_accessibilityExplorerElements;
 - (_Bool)_accessibilityIsContainedByVideoElement;
 - (_Bool)_accessibilityIsContainedByPreferredNativeFocusElement;
 - (_Bool)_accessibilityAllowsActivationWithoutBeingNativeFocused;
 - (id)_accessibilityNativeFocusElement;
 - (id)_accessibilityRetrieveHeaderElements;
 - (void)_accessibilityShowEditingHUD;
 - (int)_accessibilityRemotePid;
 - (_Bool)_accessibilityHandlesRemoteFocusMovement;
 - (void)_accessibilitySetFocusOnElement:(_Bool)arg1;
 - (_Bool)_accessibilityMoveFocusWithHeading:(unsigned long long)arg1 toElementMatchingQuery:(id)arg2;
 - (_Bool)_accessibilityHandleDefaultActionForNativeFocusedElement;
 - (_Bool)_accessibilityMoveFocusWithHeading:(unsigned long long)arg1;
 - (_Bool)_accesibilityIsTopMostDrawsFocusRingWhenChildrenFocused;
 - (_Bool)_drawsFocusRingWhenChildrenFocused;
 - (_Bool)_accessibilityAllowsFocusToLeaveViaHeading:(unsigned long long)arg1;
 - (void)_axSetLastFocusedChild:(id)arg1;
 - (id)_axGetLastFocusedChild;
 - (_Bool)_accessibilityDrawsFocusRingWhenChildrenFocused;
 - (id)_accessibilityNativeFocusAncestor;
 - (_Bool)_accessibilityShouldSpeakExplorerElementsAfterFocus;
 - (_Bool)_accessibilityShouldIgnoreSoundForFailedMoveAttempt;
 - (_Bool)_accessibilityNativeFocusPreferredElementIsValid;
 - (_Bool)_accessibilityShouldBeExplorerElementWithoutSystemFocus;
 - (id)_accessibilityNativeFocusPreferredElement;
 - (_Bool)_accessibilityCanBecomeNativeFocused;
 - (_Bool)_accessibilitySetNativeFocus;
 - (_Bool)_accessibilityShouldSetNativeFocusWhenATVFocused;
 - (_Bool)_accessibilityViewHierarchyHasNativeFocus;
 - (_Bool)_accessibilityFullscreenVideoViewIsVisible;
 - (_Bool)_accessibilityUIKitHasNativeFocus;
 - (_Bool)_accessibilityHasNativeFocus;
 - (id)_accessibilitySiblingViewsForViews:(id)arg1;
 - (id)_accessibilitySpeakThisViews;
 - (id)_accessibilitySpeakThisViewController;
 - (id)_accessibilitySpeakThisPreferredUnderlineColor;
 - (id)_accessibilitySpeakThisPreferredHighlightColor;
 - (_Bool)_accessibilitySpeakThisCanBeHighlighted;
 - (_Bool)_accessibilitySpeakThisShouldOnlyIncludeVisibleElements;
 - (_Bool)_accessibilitySpeakThisShouldScrollTextRects;
 - (id)_accessibilityTextRectsForRange:(id)arg1 singleTextRect:(struct CGRect *)arg2;
 - (id)_accessibilityTextRectsForSpeakThisStringRange:(struct _NSRange)arg1;
 - (id)_accessibilityTextRectsForSpeakThisStringRange:(struct _NSRange)arg1 string:(id)arg2;
 - (id)_accessibilitySpeakThisElementsAndStrings;
 - (unsigned long long)_accessibilitySpeakThisMaximumNumberOfElements;
 - (void)_accessibilitySetIgnoreDelegate:(_Bool)arg1;
 - (_Bool)_accessibilityIgnoreDelegate;
 - (_Bool)_accessibilityMimicsTextInputResponder;
 - (_Bool)_iosAccessibilityPerformAction:(int)arg1 withValue:(id)arg2 fencePort:(unsigned int)arg3;
 - (_Bool)_accessibilityActivateDragWithDescriptorDictionary:(id)arg1 forServiceName:(id)arg2;
 - (id)dragDescriptorMatchingDictionary:(id)arg1;
 - (struct CGRect)_accessibilityScreenRectForSceneReferenceRect:(struct CGRect)arg1;
 - (struct CGPoint)_accessibilityScreenPointForSceneReferencePoint:(struct CGPoint)arg1;
 - (_Bool)_accessibilityHandleMagicTap;
 - (_Bool)_accessibilityHandleMagicTapForPronunciation;
 - (void)_setAccessibilityActivateParagraphInTextViewRangeBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityFrameForSortingBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityCustomActionsBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityIsRealtimeElementBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityPerformEscapeBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityActivateBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityIncrementBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityDecrementBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityGuideElementHeaderTextBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityLinkedUIElementsBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityElementsBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityHeaderElementsBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityNavigationStyleBlock:(CDUnknownBlockType)arg1;
 - (void)_setShouldGroupAccessibilityChildrenBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityViewIsModalBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityElementsHiddenBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityLanguageBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityActivationPointBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityPathBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityFrameBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityTraitsBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityAdditionalTraitsBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityValueBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityHintBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityIdentifierBlock:(CDUnknownBlockType)arg1;
 - (void)_setAccessibilityLabelBlock:(CDUnknownBlockType)arg1;
 - (void)_setIsAccessibilityElementBlock:(CDUnknownBlockType)arg1;
 - (void *)_accessibilityGetBlockForAttribute:(long long)arg1;
 - (void)_accessibilitySetBlock:(void *)arg1 forAttribute:(long long)arg2;
 - (void)_accessibilityRemoveActionBlockForKey:(unsigned int)arg1;
 - (void)_accessibilityRemoveAllActionBlocks;
 - (void)_accessibilityActionBlock:(CDUnknownBlockType *)arg1 andValue:(id *)arg2 forKey:(unsigned int)arg3;
 - (_Bool)_accessibilityHasActionBlockForKey:(unsigned int)arg1;
 - (_Bool)_accessibilityInternalHandleStartStopToggle;
 - (void)_accessibilitySetActionBlock:(CDUnknownBlockType)arg1 withValue:(id)arg2 forKey:(unsigned int)arg3;
 - (void)_accessibilitySetScannerActivateBehavior:(long long)arg1;
 - (long long)_accessibilityScannerActivateBehavior;
 - (void)_accessibilitySetScannerGroupTraits:(unsigned long long)arg1;
 - (void)_accessibilitySetIsScannerGroup:(_Bool)arg1;
 - (unsigned long long)_accessibilityScannerGroupTraits;
 - (_Bool)_accessibilityIsScannerGroup;
 - (id)_accessibilityGroupIdentifier;
 - (unsigned long long)_accessibilityScanningBehaviorTraits;
 - (_Bool)_accessibilityShouldBeScannedIfAncestorCanScroll;
 - (long long)_accessibilityCollectionViewItemsPerRow;
 - (_Bool)_accessibilityTreatCollectionViewRowsAsScannerGroups;
 - (id)_accessibilityScannerGroupElements;
 - (void)_accessibilityProcessScannerGroupElementPieces:(id)arg1;
 - (void)_accessibilitySetIsScannerElement:(_Bool)arg1;
 - (_Bool)_accessibilityIsScannerElement;
 - (_Bool)_accessibilitySupportsContentSizeCategory:(id)arg1;
 - (id)_axElementsDescription;
 - (void)_accessibilityElementsDescriptionProcess:(id)arg1 tabCount:(long long)arg2;
 - (void)_accessibilityDidReuseOpaqueElementView:(id)arg1;
 - (id)_accessibilityReusableViewForOpaqueElement:(id)arg1;
 - (id)_accessibilityCurrentlyFocusedElementForTechnology:(id)arg1;
 - (void)_accessibilityUpdateFocusState:(id)arg1 forFocusedElement:(id)arg2;
 - (void)_accessibilityDidFocusOnOpaqueElement:(id)arg1 technology:(id)arg2;
 - (id)_accessibilityFocusStatePerTechnology;
 - (id)_accessibilityUserTestingSnapshot;
 - (id)_accessibilityUserTestingSnapshotWithOptions:(id)arg1;
 - (id)_accessibilityUserTestingSnapshotAncestorsWithAttributes:(id)arg1 maxDepth:(unsigned long long)arg2 maxChildren:(unsigned long long)arg3 maxArrayCount:(unsigned long long)arg4 honorsModalViews:(_Bool)arg5;
 - (id)_accessibilityUserTestingSnapshotDescendantsWithAttributes:(id)arg1 maxDepth:(unsigned long long)arg2 maxChildren:(unsigned long long)arg3 maxArrayCount:(unsigned long long)arg4 honorsModalViews:(_Bool)arg5;
 - (_Bool)_accessibilityUserTestingIsElementClassAcceptable;
 - (id)_accessibilityUserTestingChildren;
 - (_Bool)_accessibilityFauxTableViewCellsDisabled;
 - (void)_setAccessibilityFauxTableViewCellsDisabled:(_Bool)arg1;
 - (_Bool)_accessibilityFauxCollectionViewCellsDisabled;
 - (void)_setAccessibilityFauxCollectionViewCellsDisabled:(_Bool)arg1;
 - (id)_accessibilityUserTestingChildrenWithRange:(struct _NSRange)arg1;
 - (long long)_accessibilityUserTestingChildrenCount;
 - (id)_accessibilityUserTestingSupplementaryViews:(_Bool)arg1;
 - (id)_accessibilityAncestry;
 - (id)_accessibilityUserTestingParent;
 - (id)_accessibilityUserTestingElementType;
 - (double)_accessibilityMaxValue;
 - (double)_accessibilityMinValue;
 - (id)_accessibilityAbsoluteValue;
 @property(nonatomic, setter=_setAccessibilityAutomationType:) unsigned long long _accessibilityAutomationType;
 - (id)_accessibilityUserTestingElementBaseType;
 - (id)_accessibilityUserTestingElementAttributes;
 - (_Bool)_accessibilityUserTestingIsContinuityButton;
 - (id)_accessibilityKeyboardKeyEnteredString;
 - (_Bool)_accessibilityUserTestingIsRightNavButton;
 - (_Bool)_accessibilityUserTestingIsBackNavButton;
 - (void)_accessibilitySetUserTestingIsPreferredButton:(_Bool)arg1;
 - (void)_accessibilitySetUserTestingIsDestructiveButton:(_Bool)arg1;
 - (void)_accessibilitySetUserTestingIsCancelButton:(_Bool)arg1;
 - (void)_accessibilitySetUserTestingIsDefaultButton:(_Bool)arg1;
 - (_Bool)_accessibilityUserTestingIsPreferredButton;
 - (_Bool)_accessibilityUserTestingIsDestructiveButton;
 - (_Bool)_accessibilityUserTestingIsCancelButton;
 - (_Bool)_accessibilityUserTestingIsDefaultButton;
 - (_Bool)accessibilityExpandMathEquation:(id)arg1;
 - (id)_accessibilityTextStylingCustomRotor:(long long)arg1;
 - (struct _NSRange)_accessibilityMisspelledWordIn:(id)arg1 searchRange:(struct _NSRange)arg2 next:(_Bool)arg3;
 - (id)_accessibilityAttributedTextRetrieval;
 - (CDUnknownBlockType)_accessibilityAttributeMatcher:(long long)arg1;
 - (CDUnknownBlockType)_accessibilityColorChangeMatch;
 - (CDUnknownBlockType)_accessibilityFontChangeMatch;
 - (CDUnknownBlockType)_accessibilityStyleChangeMatch;
 - (CDUnknownBlockType)_accessibilityPlainTextMatch;
 - (CDUnknownBlockType)_accessibilityBoldTextMatch;
 - (CDUnknownBlockType)_accessibilityItalicTextMatch;
 - (CDUnknownBlockType)_accessibilityUnderlineTextMatch;
 - (id)_accessibilityNextTextRangeUsingTextStyling:(id)arg1 attributeMatch:(CDUnknownBlockType)arg2;
 - (id)_accessibilityCommonStylingRotors;
 @end
 */
