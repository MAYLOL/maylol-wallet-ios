//
//  MLGuideView.swift
//  GuideSwift
//
//  Created by 安跃超 on 2018/9/16.
//  Copyright © 2018年 安跃超. All rights reserved.
//

import UIKit

class MLGuideView: UIView {
    private var pageViews: [UIView] = []
    private var scrollView: UIScrollView?
    var swipeToExit = true

    // MARK: initialize with frame and pages
    init(frame: CGRect, pages: [UIView]) {
        super.init(frame: frame)

        if !pages.isEmpty {
            pageViews = pages
            setupScrollView()
        }
    }
    // MARK: set up scrollView
    private func setupScrollView() {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: CGFloat(pageViews.count) * self.bounds.width, height: 0)

        for (index, page) in pageViews.enumerated() {
            var rect = page.frame
            rect.origin.x = self.bounds.width * CGFloat(index)
            page.frame = rect
            scrollView.addSubview(page)
        }
        self.addSubview(scrollView)
        self.scrollView = scrollView
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UIScrollViewDelegate
extension MLGuideView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int((scrollView.contentOffset.x + scrollView.bounds.width/2) / self.bounds.width)

        UIView.animate(withDuration: 0.5) {

            if index == self.pageViews.count - 1 {
            }else if index == self.pageViews.count && self.swipeToExit {
                self.removeFromSuperview()
            } else {
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / self.bounds.width)

        if index == pageViews.count - 1  && swipeToExit {
            self.alpha = (CGFloat(pageViews.count) * self.bounds.width - scrollView.contentOffset.x)/self.bounds.width
        }
    }
}
