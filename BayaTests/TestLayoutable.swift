//
// Copyright (c) 2017 wag it GmbH.
// License: MIT
//

import Foundation
import Baya

class TestLayoutable: BayaLayoutable {
    var frame = CGRect()
    var layoutMargins = UIEdgeInsets.zero

    func sizeThatFits(_ size: CGSize) -> CGSize {
        return size
    }

    func layoutWith(frame: CGRect) {
        self.frame = frame
    }

    func m(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) {
        layoutMargins = UIEdgeInsets(
            top: top,
            left: left,
            bottom: bottom,
            right: right)
    }
}
