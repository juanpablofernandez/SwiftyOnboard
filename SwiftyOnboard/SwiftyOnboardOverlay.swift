//
//  customOverlayView.swift
//  SwiftyOnboard
//
//  Created by Jay on 3/26/17.
//  Copyright © 2017 Juan Pablo Fernandez. All rights reserved.
//

import UIKit

open class SwiftyOnboardOverlay: UIView {
    
    open var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        return pageControl
    }()
    
    open var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    open var skipButton: UIButton = {
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
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
    
    open func set(style: SwiftyOnboardStyle) {
        switch style {
        case .light:
            continueButton.setTitleColor(.white, for: .normal)
            skipButton.setTitleColor(.white, for: .normal)
            pageControl.currentPageIndicatorTintColor = UIColor.white
        case .dark:
            continueButton.setTitleColor(.black, for: .normal)
            skipButton.setTitleColor(.black, for: .normal)
            pageControl.currentPageIndicatorTintColor = UIColor.black
        }
    }
    
    open func page(count: Int) {
        pageControl.numberOfPages = count
    }
    
    open func currentPage(index: Int) {
        pageControl.currentPage = index
    }
    
    func setUp() {
        self.addSubview(pageControl)
        
        let margin = self.layoutMarginsGuide
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.heightAnchor.constraint(equalToConstant: 15).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: -10).isActive = true
        pageControl.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: 10).isActive = true
        pageControl.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: -10).isActive = true
        
        self.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20).isActive = true
        continueButton.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: 10).isActive = true
        continueButton.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: -10).isActive = true
        
        self.addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        skipButton.topAnchor.constraint(equalTo: margin.topAnchor, constant: 10).isActive = true
        skipButton.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: 10).isActive = true
        skipButton.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: -20).isActive = true
    }
    
}
