//
//  disagnableButton.swift
//  weatherApp3
//
//  Created by Alperen Kavuk on 28.03.2023.
//

import UIKit

@IBDesignable class DisignableButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue  }
        get { return layer.cornerRadius }
    }
   
    @IBInspectable var borderWidth: CGFloat {
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }
    
   
    @IBInspectable var borderColor: CGColor {
        set { layer.borderColor = newValue}
        get { return layer.borderColor! }
    }
}
