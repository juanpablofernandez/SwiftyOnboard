//
//  CustomOverlay.swift
//  SwiftyOnboardExample
//
//  Created by Jay on 3/27/17.
//  Copyright © 2017 Juan Pablo Fernandez. All rights reserved.
//

import UIKit
import SwiftyOnboard

class CustomOverlay: SwiftyOnboardOverlay {
    
    @IBOutlet weak var skip: UIButton!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var contentControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        buttonContinue.layer.borderColor = UIColor.white.cgColor
        buttonContinue.layer.borderWidth = 1
        buttonContinue.layer.cornerRadius = buttonContinue.bounds.height / 2
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CustomOverlay", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
}
