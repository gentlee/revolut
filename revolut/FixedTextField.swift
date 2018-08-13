//
//  FixedTextField.swift
//  revolut
//
//  Created by Alexander Danilov on 12/08/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import UIKit

class FixedTextField: UITextField {
    override var intrinsicContentSize: CGSize {
        // HACK fix intrinsic content size while editing
        if (self.isEditing) {
            var size = (self.text ?? "").size(attributes: self.typingAttributes)
            size.width += self.leftView?.frame.size.width ?? 0
            return size
        }
    
        return super.intrinsicContentSize
    }
}
