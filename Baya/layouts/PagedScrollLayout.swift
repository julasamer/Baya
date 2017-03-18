//
//  Created by Joachim Fröstl on 25.11.16.
//  Fixed Layout bug by Markus Riegel on 18.01.2017
//  Copyright © 2016-2017 wag it GmbH. All rights reserved.
//

import Foundation

/**
    A layout that calculates the size of its content layoutable depending on the given frame,
    the number of pages, and an optional gutter. The container will be laid out according to the frame.
 */
struct PagedScrollLayout: Layout {

    var layoutMargins: UIEdgeInsets
    var frame: CGRect
    var orientation: LayoutOptions.Orientation
    var pages: Int
    var gutter: CGFloat

    private var container: PagedScrollLayoutContainer
    private var content: Layoutable

    init(
        content: Layoutable,
        container: PagedScrollLayoutContainer,
        pages: Int,
        gutter: CGFloat = 0,
        orientation: LayoutOptions.Orientation = .horizontal,
        layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {

        self.content = content
        self.container = container
        self.pages = pages
        self.gutter = gutter
        self.orientation = orientation
        self.layoutMargins = layoutMargins
        self.frame = CGRect()
    }

    mutating func layoutWith(frame: CGRect) {
        self.frame = frame

        let containerFrame = CGRect(
            x: frame.minX,
            y: frame.minY,
            width: orientation == .horizontal ? frame.width + gutter : frame.width,
            height: orientation == .vertical ? frame.height + gutter : frame.height)
        container.layoutWith(frame: containerFrame)

        let contentFrame = CGRect(
            x: 0,
            y: 0,
            width: orientation == .horizontal ?
            frame.width * CGFloat(pages) + gutter * CGFloat(pages - 1) : frame.width,
            height: orientation == .vertical ?
            frame.height * CGFloat(pages) + gutter * CGFloat(pages - 1) : frame.height)
        content.layoutWith(frame: contentFrame)

        container.contentSize = CGSize(
            // increase the contentSize for a trailing gutter (which won't be shown).
            width: orientation == .horizontal ? contentFrame.width + gutter : contentFrame.width,
            height: orientation == .vertical ? contentFrame.height + gutter : contentFrame.height)
    }

    func sizeThatFits(_ size: CGSize) -> CGSize {
        // PagedScrollLayout always fits the given size
        return size
    }
}

/**
    Implement this protocol for the paged scroll layout container
 */
protocol PagedScrollLayoutContainer {
    var contentSize: CGSize {get set}
    var bounds: CGRect {get}
    func layoutWith(frame: CGRect) -> Void
}

// MARK: UIKit specific extensions

extension UIScrollView: PagedScrollLayoutContainer {}
