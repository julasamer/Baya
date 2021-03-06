//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import Foundation

import XCTest
@testable import Baya

class BayaLinearTests: XCTestCase {
    var l1: TestLayoutable!
    var l2: TestLayoutable!
    var l3: TestLayoutable!
    let layoutRect = CGRect(
        x: 3,
        y: 3,
        width: 300,
        height: 300)
    let spacing: CGFloat = 20

    override func setUp() {
        super.setUp()
        l1 = TestLayoutable(sideLength: 30)
        l2 = TestLayoutable(sideLength: 60)
        l3 = TestLayoutable(sideLength: 90)

        l1.m(8, 7, 4, 40)
        l2.m(20, 13, 11, 4)
        l3.m(3, 15, 8, 1)
    }

    override func tearDown() {
        super.tearDown()
        l1 = nil
        l2 = nil
        l3 = nil
    }

    func testEmptyArray() {
        var layout = [TestLayoutable]()
            .layoutLinearly(orientation: .horizontal)
        layout.startLayout(with: CGRect())
        XCTAssert(true) // Does not crash.
    }

    func testHorizontal() {
        var layout = [l1, l2, l3].layoutLinearly(
            orientation: .horizontal,
            spacing: spacing)
        layout.startLayout(
            with: layoutRect)

        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.origin.x + l1.bayaMargins.left,
                y: layoutRect.origin.y + l1.bayaMargins.top,
                width: l1.width,
                height: l1.height),
            "l1 not matching")
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.origin.x
                    + l1.width
                    + l1.horizontalMargins
                    + spacing
                    + l2.bayaMargins.left,
                y: layoutRect.origin.y + l2.bayaMargins.top,
                width: l2.width,
                height: l2.height),
            "l2 not matching")
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.origin.x
                    + l1.width
                    + l1.horizontalMargins
                    + spacing
                    + l2.width
                    + l2.horizontalMargins
                    + spacing +
                    l3.bayaMargins.left,
                y: layoutRect.origin.y + l3.bayaMargins.top,
                width: l3.width,
                height: l3.height),
            "l3 not matching")
    }
    
    func testHorizontalMatchParent() {
        l1 = TestLayoutable(sideLength: 30, bayaModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l2 = TestLayoutable(sideLength: 60, bayaModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l3 = TestLayoutable(sideLength: 90, bayaModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        var layout = [l1, l2, l3].layoutLinearly(
            orientation: .horizontal,
            spacing: spacing)
        layout.startLayout(with: layoutRect)
        let maxHeight = max(
            l1.height + l1.verticalMargins,
            l2.height + l2.verticalMargins,
            l3.height + l3.verticalMargins)
        
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX
                    + l1.bayaMargins.left,
                y: layoutRect.minY
                    + l1.bayaMargins.top,
                width: l1.width,
                height: maxHeight - l1.verticalMargins))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX
                    + l1.width
                    + l1.horizontalMargins
                    + spacing
                    + l2.bayaMargins.left,
                y: layoutRect.minY
                    - l2.bayaMargins.top,
                width: l2.width,
                height: maxHeight
                    - l2.verticalMargins))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.minX
                    + l1.horizontalMargins
                    + l1.width
                    + spacing
                    + l2.width
                    + l2.horizontalMargins
                    + spacing
                    + l3.bayaMargins.left,
                y: layoutRect.minY
                    + l3.bayaMargins.top,
                width: l3.width,
                height: maxHeight
                    - l3.verticalMargins))
    }

    func testVertical() {
        var layout = [l1, l2, l3].layoutLinearly(
            orientation: .vertical,
            spacing: spacing)
        layout.startLayout(with: layoutRect)

        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX
                    + l1.bayaMargins.left,
                y: layoutRect.minY
                    + l1.bayaMargins.top,
                width: l1.width,
                height: l1.height))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX
                    + l2.bayaMargins.left,
                y: layoutRect.minY
                    + l1.verticalMargins
                    + l1.height
                    + spacing
                    + l2.bayaMargins.top,
                width: l2.width,
                height: l2.height))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.minX + l3.bayaMargins.left,
                y: layoutRect.minY
                    + l1.height
                    + l1.verticalMargins
                    + l2.height
                    + l2.verticalMargins
                    + l3.bayaMargins.top
                    + spacing * 2,
                width: l3.width,
                height: l3.height))
    }
    
    func testVerticalMatchParent() {
        l1 = TestLayoutable(sideLength: 30, bayaModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l2 = TestLayoutable(sideLength: 60, bayaModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        l3 = TestLayoutable(sideLength: 90, bayaModes: BayaLayoutOptions.Modes(width: .matchParent, height: .matchParent))
        var layout = [l1, l2, l3].layoutLinearly(
            orientation: .vertical,
            spacing: spacing)
        layout.startLayout(with: layoutRect)
        
        let maxWidth = max(
            l1.width + l1.horizontalMargins,
            l2.width + l2.horizontalMargins,
            l3.width + l3.horizontalMargins)
        
        XCTAssertEqual(
            l1.frame,
            CGRect(
                x: layoutRect.minX
                    + l1.bayaMargins.left,
                y: layoutRect.minY
                    + l1.bayaMargins.top,
                width: maxWidth
                    - l1.horizontalMargins,
                height: l1.height))
        XCTAssertEqual(
            l2.frame,
            CGRect(
                x: layoutRect.minX
                    + l2.bayaMargins.left,
                y: layoutRect.minY
                    + l1.verticalMargins
                    + l1.height
                    + spacing
                    + l2.bayaMargins.top,
                width: maxWidth
                    - l2.horizontalMargins,
                height: l2.height))
        XCTAssertEqual(
            l3.frame,
            CGRect(
                x: layoutRect.minX
                    + l3.bayaMargins.left,
                y: layoutRect.minY
                    + l1.height
                    + l1.verticalMargins
                    + l2.height
                    + l2.verticalMargins
                    + l3.bayaMargins.top
                    + spacing * 2,
                width: maxWidth
                    - l3.horizontalMargins,
                height: l3.height))
    }

    func testMeasureHorizontal() {
        var layout = [l1, l2, l3].layoutLinearly(
            orientation: .horizontal,
            spacing: spacing)
        let size = layout.sizeThatFits(layoutRect.size)
        let maxHeight = max(
            l1.height + l1.verticalMargins,
            l2.height + l2.verticalMargins,
            l3.height + l3.verticalMargins)

        XCTAssertEqual(
            size,
            CGSize(
            width: l1.width
                + l2.width
                + l3.width
                + spacing * 2
                + l1.horizontalMargins
                + l2.horizontalMargins
                + l3.horizontalMargins,
            height: maxHeight),
            "size does not match")
    }

    func testMeasureVertical() {
        var layout = [l1, l2, l3].layoutLinearly(
            orientation: .vertical,
            spacing: spacing)
        let size = layout.sizeThatFits(layoutRect.size)
        let maxWidth = max(
            l1.width + l1.horizontalMargins,
            l2.width + l2.horizontalMargins,
            l3.width + l3.horizontalMargins)

        XCTAssertEqual(size, CGSize(
            width: maxWidth,
            height: l1.height
                + l2.height
                + l3.height
                + spacing * 2
                + l1.verticalMargins
                + l2.verticalMargins
                + l3.verticalMargins),
            "size does not match")
    }
    
    func testDifferentTypesPossible() {
        let anotherOne = AnotherOne()
        var layout = [l1, anotherOne].layoutLinearly(orientation: .horizontal)
        layout.startLayout(with: layoutRect)
        XCTAssert(true)
    }
}

private class AnotherOne: BayaLayoutable {
    var bayaMargins = UIEdgeInsets.zero
    var frame = CGRect()

    func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 30, height: 30)
    }

    func layoutWith(frame: CGRect) {
        self.frame = frame
    }
}

