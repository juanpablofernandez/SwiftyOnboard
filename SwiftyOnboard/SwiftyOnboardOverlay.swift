//
//  customOverlayView.swift
//  SwiftyOnboard
//
//  Created by Jay on 3/26/17.
//  Copyright © 2017 Juan Pablo Fernandez. All rights reserved.
//

import UIKit

public protocol SwiftyOnboardOverlayDelegate{
    
    func onboardOverlay(_ onboardOverlay: SwiftyOnboardOverlay,didClickContinue button: UIButton)
    
    func onboardOverlay(_ onboardOverlay: SwiftyOnboardOverlay,didClickSkip button: UIButton)
}

open class SwiftyOnboardOverlay: UIView {

    public var delegate: SwiftyOnboardOverlayDelegate?
    
    public var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        return pageControl
    }()
    
    public var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(didClickContinue(sender:)), for: .touchUpInside)
        return button
    }()
    
    public var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(didClickSkip(sender:)), for: .touchUpInside)
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
    
    func set(style: SwiftyOnboardStyle) {
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
    
    public func page(count: Int) {
        pageControl.numberOfPages = count
    }
    
    public func currentPage(index: Int) {
        pageControl.currentPage = index
    }
    
    func setUp() {
        self.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.heightAnchor.constraint(equalToConstant: 15).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        pageControl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        pageControl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        self.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20).isActive = true
        continueButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        continueButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        self.addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        skipButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
        skipButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        skipButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
    }
    
    func didClickContinue(sender: UIButton){
        delegate?.onboardOverlay(self, didClickContinue: sender)
    }
    
    func didClickSkip(sender: UIButton){
        delegate?.onboardOverlay(self, didClickSkip: sender)
    }
}
