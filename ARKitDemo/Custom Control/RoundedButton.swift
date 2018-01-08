//
//  RoundedButton.swift
//  ARKitDemo
//
//  Created by Vincent Villalta on 1/8/18.
//  Copyright © 2018 Vincent Villalta. All rights reserved.
//

import UIKit
@IBDesignable
open class RoundedButton: UIButton {

    
    @IBInspectable
    public var cornerRadius: CGFloat = 2.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable
    public var shadowColor: UIColor = .white {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
            self.layer.shadowRadius = 4.0
            self.layer.shadowOpacity = 0.8
            self.layer.shadowOffset = .zero
            self.layer.masksToBounds = false
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

}
