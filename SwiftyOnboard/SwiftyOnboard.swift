//
//  ViewController.swift
//  SwiftyOnboard
//
//  Created by Jay on 3/25/17.
//  Copyright © 2017 Juan Pablo Fernandez. All rights reserved.
//

import UIKit

public protocol SwiftyOnboardDataSource: class {
    
    func swiftyOnboardNumberOfPages(swiftyOnboard: SwiftyOnboard) -> Int
    func swiftyOnboardViewForBackground(swiftyOnboard: SwiftyOnboard) -> UIView?
    func swiftyOnboardPageForIndex(swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage?
    func swiftyOnboardViewForOverlay(swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay?
    func swiftyOnboardOverlayForPosition(swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double)
    
}

public extension SwiftyOnboardDataSource {
    
    func swiftyOnboardViewForBackground(swiftyOnboard: SwiftyOnboard) -> UIView? {
        return nil
    }
    
    func swiftyOnboardOverlayForPosition(swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {}
}

public protocol SwiftyOnboardDelegate: class {
    
    func swiftyOnboard(swiftyOnboard: SwiftyOnboard, currentPage index: Int)
    func swiftyOnboard(swiftyOnboard: SwiftyOnboard, leftEdge position: Double)
    
}

public extension SwiftyOnboardDelegate {
    func swiftyOnboard(swiftyOnboard: SwiftyOnboard, currentPage index: Int) {}
    func swiftyOnboard(swiftyOnboard: SwiftyOnboard, leftEdge position: Double) {}
}

public class SwiftyOnboard: UIView, UIScrollViewDelegate {
    
    public weak var dataSource: SwiftyOnboardDataSource? {
        didSet {
            dataSourceSet = true
        }
    }
    
    public var delegate: SwiftyOnboardDelegate?
    
    private var containerView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isUserInteractionEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        return scrollView
    }()
    
    private var dataSourceSet: Bool = false
    private var pageCount = 0
    private var overlay: SwiftyOnboardOverlay?
    public var shouldSwipe: Bool = true
    
    private func loadView() {
        setBackgroundView()
        setUpContainerView()
        setUpPages()
        setOverlayView()
        containerView.isScrollEnabled = shouldSwipe
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if dataSourceSet {
            loadView()
            dataSourceSet = false
        }
    }
    
    private func setUpPages() {
        if let dataSource = dataSource {
            pageCount = dataSource.swiftyOnboardNumberOfPages(swiftyOnboard: self)
            
            for index in 0..<pageCount{
                let view = dataSource.swiftyOnboardPageForIndex(swiftyOnboard: self, index: index)
                self.contentMode = .scaleAspectFit
                containerView.addSubview(view!)
                var viewFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                viewFrame.origin.x = self.frame.width * CGFloat(index)
                view?.frame = viewFrame
            }
            containerView.contentSize = CGSize(width: self.frame.width * CGFloat(pageCount), height: self.frame.height)
        }
    }
    
    private func setBackgroundView() {
        if let dataSource = dataSource {
            if let background = dataSource.swiftyOnboardViewForBackground(swiftyOnboard: self) {
                self.addSubview(background)
                self.sendSubview(toBack: background)
            }
        }
    }
    
    private func setOverlayView() {
        if let dataSource = dataSource {
            if let overlay = dataSource.swiftyOnboardViewForOverlay(swiftyOnboard: self) {
                self.addSubview(overlay)
                self.bringSubview(toFront: overlay)
                let viewFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                overlay.frame = viewFrame
                self.overlay = overlay
            }
        }
    }
    
    private func setUpContainerView() {
        //Scroll View Setup:
        self.addSubview(containerView)
        self.containerView.frame = self.frame
        containerView.delegate = self
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.width
        let currentContent = scrollView.contentOffset.x
        let currentPage = Int(currentContent / width)
        self.delegate?.swiftyOnboard(swiftyOnboard: self, currentPage: currentPage)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let boundsWidth = scrollView.bounds.width
        let contentOffsetX = scrollView.contentOffset.x
        let currentPosition = Double(contentOffsetX / boundsWidth)
        self.delegate?.swiftyOnboard(swiftyOnboard: self, leftEdge: currentPosition)
        if let overlayView = self.overlay {
            self.dataSource?.swiftyOnboardOverlayForPosition(swiftyOnboard: self, overlay: overlayView, for: currentPosition)
        }
    }
    
    public func goToPage(index: Int, animated: Bool) {
        if index < self.pageCount {
            let index = CGFloat(index)
            containerView.setContentOffset(CGPoint(x: index * self.frame.width, y: 0), animated: animated)
        }
    }
}
