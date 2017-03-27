//
//  customOverlayView.swift
//  SwiftyOnboard
//
//  Created by Jay on 3/26/17.
//  Copyright © 2017 Juan Pablo Fernandez. All rights reserved.
//

import UIKit

public class SwiftyOnboardOverlay: UIView {

    public var bubbles: UIPageControl = {
        let bubbles = UIPageControl()
        bubbles.currentPage = 0
        bubbles.pageIndicatorTintColor = UIColor.lightGray
        bubbles.currentPageIndicatorTintColor = UIColor.white
        return bubbles
    }()
    
    public var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.contentHorizontalAlignment = .center
        
        return button
    }()
    
    public var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
    
    func setUp() {
        self.addSubview(bubbles)
        bubbles.translatesAutoresizingMaskIntoConstraints = false
        bubbles.heightAnchor.constraint(equalToConstant: 15).isActive = true
        bubbles.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        bubbles.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        bubbles.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        self.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: bubbles.topAnchor, constant: -20).isActive = true
        continueButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        continueButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        self.addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        skipButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
        skipButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        skipButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
    }
}
