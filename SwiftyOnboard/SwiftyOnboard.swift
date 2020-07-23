//
//  ViewController.swift
//  SwiftyOnboard
//
//  Created by Jay on 3/25/17.
//  Copyright © 2017 Juan Pablo Fernandez. All rights reserved.
//

import UIKit

public protocol SwiftyOnboardDataSource: class {
    
    func swiftyOnboardBackgroundColorFor(_ swiftyOnboard: SwiftyOnboard, atIndex index: Int) -> UIColor?
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int
    func swiftyOnboardViewForBackground(_ swiftyOnboard: SwiftyOnboard) -> UIView?
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage?
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay?
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double)
    
}

public extension SwiftyOnboardDataSource {
    
    func swiftyOnboardBackgroundColorFor(_ swiftyOnboard: SwiftyOnboard,atIndex index: Int)->UIColor?{
        return nil
    }
    
    func swiftyOnboardViewForBackground(_ swiftyOnboard: SwiftyOnboard) -> UIView? {
        return nil
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {}
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        return SwiftyOnboardOverlay()
    }
}

public protocol SwiftyOnboardDelegate: class {
    
    func swiftyOnboard(_ swiftyOnboard: SwiftyOnboard, currentPage index: Int)
    func swiftyOnboard(_ swiftyOnboard: SwiftyOnboard, leftEdge position: Double)
    func swiftyOnboard(_ swiftyOnboard: SwiftyOnboard, tapped index: Int)
    
}

public extension SwiftyOnboardDelegate {
    func swiftyOnboard(_ swiftyOnboard: SwiftyOnboard, currentPage index: Int) {}
    func swiftyOnboard(_ swiftyOnboard: SwiftyOnboard, leftEdge position: Double) {}
    func swiftyOnboard(_ swiftyOnboard: SwiftyOnboard, tapped index: Int) {}
}

public class SwiftyOnboard: UIView, UIScrollViewDelegate {
    
    open weak var dataSource: SwiftyOnboardDataSource? {
        didSet {
            if let color = dataSource?.swiftyOnboardBackgroundColorFor(self, atIndex: 0){
                backgroundColor = color
            }
            dataSourceSet = true
        }
    }
    
    open weak var delegate: SwiftyOnboardDelegate?
    
    fileprivate var containerView: UIScrollView = {
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
    
    fileprivate var dataSourceSet: Bool = false
    fileprivate var pageCount = 0
    fileprivate var overlay: SwiftyOnboardOverlay?
    fileprivate var pages = [SwiftyOnboardPage]()
    
    open var style: SwiftyOnboardStyle = .dark
    open var shouldSwipe: Bool = true
    open var fadePages: Bool = true
    
    
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
    
    fileprivate func setUpContainerView() {
        self.addSubview(containerView)
        self.containerView.frame = self.frame
        containerView.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedPage))
        containerView.addGestureRecognizer(tap)
    }
    
    fileprivate func setBackgroundView() {
        if let dataSource = dataSource {
            if let background = dataSource.swiftyOnboardViewForBackground(self) {
                self.addSubview(background)
                self.sendSubview(toBack: background)
            }
        }
    }
    
    fileprivate func setUpPages() {
        if let dataSource = dataSource {
            pageCount = dataSource.swiftyOnboardNumberOfPages(self)
            for index in 0..<pageCount{
                if let view = dataSource.swiftyOnboardPageForIndex(self, index: index) {
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
    
    fileprivate func setOverlayView() {
        if let dataSource = dataSource {
            if let overlay = dataSource.swiftyOnboardViewForOverlay(self) {
                overlay.page(count: self.pageCount)
                overlay.set(style: style)
                self.addSubview(overlay)
                self.bringSubview(toFront: overlay)
                let viewFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                overlay.frame = viewFrame
                self.overlay = overlay
                self.overlay?.pageControl.addTarget(self, action: #selector(didTapPageControl), for: .allTouchEvents)
            }
        }
    }
    
    @objc internal func tappedPage() {
        let currentpage = Int(getCurrentPosition())
        self.delegate?.swiftyOnboard(self, tapped: currentpage)
    }
    
    fileprivate func getCurrentPosition() -> CGFloat {
        let boundsWidth = containerView.bounds.width
        let contentOffset = containerView.contentOffset.x
        let currentPosition = contentOffset / boundsWidth
        return currentPosition
    }
    
    fileprivate func colorForPosition(_ pos: CGFloat)->UIColor?{
        let percentage: CGFloat = pos - CGFloat(Int(pos))
        
        let currentIndex = Int(pos - percentage)
        
        if currentIndex < pageCount - 1{
            let color1 = dataSource?.swiftyOnboardBackgroundColorFor(self, atIndex: currentIndex)
            let color2 = dataSource?.swiftyOnboardBackgroundColorFor(self, atIndex: currentIndex + 1)
            
            if let color1 = color1,
                let color2 = color2{
                return colorFrom(start: color1, end: color2, percent: percentage)
            }
        }
        return nil
    }
    
    fileprivate func colorFrom(start color1: UIColor, end color2: UIColor, percent: CGFloat)->UIColor{
        func cofd(_ color1: CGFloat,_ color2: CGFloat,_ percent: CGFloat)-> CGFloat{
            let c1 = CGFloat(color1)
            let c2 = CGFloat(color2)
            return (c1 + ((c2 - c1) * percent))
        }
        return UIColor(red: cofd(color1.cgColor.components![0],
                                 color2.cgColor.components![0],
                                 percent),
                       green: cofd(color1.cgColor.components![1],
                                   color2.cgColor.components![1],
                                   percent),
                       blue: cofd(color1.cgColor.components![2],
                                  color2.cgColor.components![2],
                                  percent),
                       alpha: 1)
    }
    
    fileprivate func fadePageTransitions(containerView: UIScrollView, currentPage: Int) {
        for (index,page) in pages.enumerated() {
            page.alpha = 1 - abs(abs(containerView.contentOffset.x) - page.frame.width * CGFloat(index)) / page.frame.width
        }
    }
    
    @objc open func didTapPageControl(_ sender: Any) {
        let pager = sender as! UIPageControl
        let page = pager.currentPage
        self.goToPage(index: page, animated: true)
    }
    
    open var currentPage: Int{
        return Int(getCurrentPosition())
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(getCurrentPosition())
        self.delegate?.swiftyOnboard(self, currentPage: currentPage)
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPosition = Double(getCurrentPosition())
        self.overlay?.currentPage(index: Int(round(currentPosition)))
        if self.fadePages {
            fadePageTransitions(containerView: scrollView, currentPage: Int(getCurrentPosition()))
        }
        
        self.delegate?.swiftyOnboard(self, leftEdge: currentPosition)
        if let overlayView = self.overlay {
            self.dataSource?.swiftyOnboardOverlayForPosition(self, overlay: overlayView, for: currentPosition)
        }
        
        if let color = colorForPosition(CGFloat(currentPosition)) {
            self.backgroundColor = color
        }
    }
    
    open func goToPage(index: Int, animated: Bool) {
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
