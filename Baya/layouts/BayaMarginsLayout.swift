//
// Copyright (c) 2016-2017 wag it GmbH.
// License: MIT
//

import Foundation

/**
    This Layout should only be used on Layoutables whose margins cannot be controlled otherwise, 
    for example the root view of an UIViewController.
    Mirrors the child's layoutModes and frame.
 */
internal struct BayaMarginsLayout: BayaLayout {
    public var layoutModes: BayaLayoutOptions.Modes {
        return element.layoutModes
    }
    public var frame: CGRect {
        return element.frame
    }
    public var layoutMargins: UIEdgeInsets
    private var element: BayaLayoutable
    
    init(
        element: BayaLayoutable,
        layoutMargins: UIEdgeInsets) {
        self.element = element
        self.layoutMargins = layoutMargins
    }

    public mutating func layoutWith(frame: CGRect) {
        element.layoutWith(frame: frame)
    }

    public mutating func sizeThatFits(_ size: CGSize) -> CGSize {
        return element.sizeThatFitsWithMargins(size)
    }
}

internal extension BayaLayoutable {
    /// Disregards the element's margins and substitutes them with the margins passed as parameter. 
    /// Useful when the element's margins cannot be controlled otherwise, which is the case for the root view of an UIViewController.
    /// - parameter layoutMargins: The layout's margins.
    /// - returns: A BayaMarginsLayout.
    func layoutWithMargins(layoutMargins: UIEdgeInsets) -> BayaMarginsLayout {
        return BayaMarginsLayout(
            element: self,
            layoutMargins: layoutMargins)
    }
}

extension UIViewController {
    /// Enables full control over the root view's margins by wrapping the it in a BayaMarginsLayout. 
    /// The layoutMargins of UIViewController's root view are managed by the system, and cannot be changed.
    /// To prevent unwanted layout behavior, use this function
    /// - parameter layoutMargins: The desired layoutMargins around the view.
    /// - returns: A BayaMarginsLayout containing the ViewController's root view.
    public func getRootViewAsLayoutable(with layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) -> BayaLayoutable {
        return view.layoutWithMargins(layoutMargins: layoutMargins)
    }
}
