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
    
    func swiftyOnboardViewForOverlay(swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        return SwiftyOnboardOverlay()
    }
}

public protocol SwiftyOnboardDelegate: class {
    
    func swiftyOnboard(swiftyOnboard: SwiftyOnboard, currentPage index: Int)
    func swiftyOnboard(swiftyOnboard: SwiftyOnboard, leftEdge position: Double)
    func swiftyOnboard(swiftyOnboard: SwiftyOnboard, tapped index: Int)
    
}

public extension SwiftyOnboardDelegate {
    func swiftyOnboard(swiftyOnboard: SwiftyOnboard, currentPage index: Int) {}
    func swiftyOnboard(swiftyOnboard: SwiftyOnboard, leftEdge position: Double) {}
    func swiftyOnboard(swiftyOnboard: SwiftyOnboard, tapped index: Int) {}
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
    private var pages = [SwiftyOnboardPage]()
    private var style: SwiftyOnboardStyle = .dark
    
    public var shouldSwipe: Bool = true
    public var fadePages: Bool = true
    
    
    public init(frame: CGRect, style: SwiftyOnboardStyle = .dark) {
        super.init(frame: frame)
        self.style = style
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
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
    
    private func setUpContainerView() {
        self.addSubview(containerView)
        self.containerView.frame = self.frame
        containerView.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedPage))
        containerView.addGestureRecognizer(tap)
    }
    
    private func setBackgroundView() {
        if let dataSource = dataSource {
            if let background = dataSource.swiftyOnboardViewForBackground(swiftyOnboard: self) {
                self.addSubview(background)
                self.sendSubview(toBack: background)
            }
        }
    }
    
    private func setUpPages() {
        if let dataSource = dataSource {
            pageCount = dataSource.swiftyOnboardNumberOfPages(swiftyOnboard: self)
            for index in 0..<pageCount{
                if let view = dataSource.swiftyOnboardPageForIndex(swiftyOnboard: self, index: index) {
                    self.contentMode = .scaleAspectFit
                    view.set(style: style)
                    containerView.addSubview(view)
                    var viewFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                    viewFrame.origin.x = self.frame.width * CGFloat(index)
                    view.frame = viewFrame
                    self.pages.append(view)
                }
            }
            containerView.contentSize = CGSize(width: self.frame.width * CGFloat(pageCount), height: self.frame.height)
        }
    }
    
    private func setOverlayView() {
        if let dataSource = dataSource {
            if let overlay = dataSource.swiftyOnboardViewForOverlay(swiftyOnboard: self) {
                overlay.page(count: self.pageCount)
                overlay.set(style: style)
                self.addSubview(overlay)
                self.bringSubview(toFront: overlay)
                let viewFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                overlay.frame = viewFrame
                self.overlay = overlay
            }
        }
    }
    
    internal func tappedPage() {
        let currentpage = Int(getCurrentPosition())
        self.delegate?.swiftyOnboard(swiftyOnboard: self, tapped: currentpage)
    }
    
    private func getCurrentPosition() -> CGFloat {
        let boundsWidth = containerView.bounds.width
        let contentOffset = containerView.contentOffset.x
        let currentPosition = contentOffset / boundsWidth
        return currentPosition
    }
    
    private func fadePageTransitions(containerView: UIScrollView, currentPage: Int) {
        //Shorter Solution:
        for (index,page) in pages.enumerated() {
            page.alpha = 1 - abs(abs(containerView.contentOffset.x) - page.frame.width * CGFloat(index)) / page.frame.width
        }

//        let diffFromCenter: CGFloat = abs(containerView.contentOffset.x - (CGFloat(currentPage)) * self.frame.size.width)
//        let currentPageAlpha: CGFloat = 1.0 - diffFromCenter / self.frame.size.width
//        let sidePagesAlpha: CGFloat = diffFromCenter / self.frame.size.width
//        //NSLog(@"%f",currentPageAlpha);
//        pages[currentPage].alpha = currentPageAlpha
//        if currentPage > 0 {
//            pages[currentPage - 1].alpha = sidePagesAlpha
//        }
//        if currentPage < pages.count - 1 {
//            pages[currentPage + 1].alpha = sidePagesAlpha
//        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(getCurrentPosition())
        self.delegate?.swiftyOnboard(swiftyOnboard: self, currentPage: currentPage)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPosition = Double(getCurrentPosition())
        self.overlay?.currentPage(index: Int(round(currentPosition)))
        if self.fadePages {
            fadePageTransitions(containerView: scrollView, currentPage: Int(getCurrentPosition()))
        }
        
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

public enum SwiftyOnboardStyle {
    case light
    case dark
}
