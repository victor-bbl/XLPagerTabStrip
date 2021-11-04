//  BarView.swift
//  XLPagerTabStrip ( https://github.com/xmartlabs/XLPagerTabStrip )
//
//  Copyright (c) 2017 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

open class BarView: UIView {

    open lazy var selectedBar: UIView = { [unowned self] in
        let selectedBar = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        selectedBar.layer.cornerRadius = 3
        return selectedBar
    }()

    var optionsCount = 1 {
        willSet(newOptionsCount) {
            if newOptionsCount <= selectedIndex {
                selectedIndex = optionsCount - 1
            }
        }
        didSet{
            for index in 1...optionsCount{
                let view = UIView(frame: CGRect(x: (self.frame.size.width/CGFloat(optionsCount))*CGFloat(index-1),
                                                y: 0,
                                                width: (self.frame.size.width/CGFloat(optionsCount))*0.9,
                                                height: self.frame.size.height))
                view.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.2784313725, blue: 0.5529411765, alpha: 1)
                view.layer.cornerRadius = 3
                addSubview(view)
            }
            addSubview(selectedBar)
        }
    }
    var selectedIndex = 0

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        addSubview(selectedBar)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
//        addSubview(selectedBar)
    }

    // MARK: - Helpers

    private func updateSelectedBarPosition(with animation: Bool) {
        var frame = selectedBar.frame
        frame.size.width = (self.frame.size.width / CGFloat(optionsCount)) * 0.9
        frame.origin.x = (self.frame.size.width / CGFloat(optionsCount)) * CGFloat(selectedIndex)
        if animation {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.selectedBar.frame = frame
            })
        } else {
            selectedBar.frame = frame
        }
    }

    open func moveTo(index: Int, animated: Bool) {
        selectedIndex = index
        updateSelectedBarPosition(with: animated)
    }

    open func move(fromIndex: Int, toIndex: Int, progressPercentage: CGFloat) {
        selectedIndex = (progressPercentage > 0.5) ? toIndex : fromIndex

        var newFrame = selectedBar.frame
        newFrame.size.width = frame.size.width / CGFloat(optionsCount) * 0.9
        var fromFrame = newFrame
        fromFrame.origin.x = (frame.size.width / CGFloat(optionsCount)) * CGFloat(fromIndex)
        var toFrame = newFrame
        toFrame.origin.x = (frame.size.width / CGFloat(optionsCount)) * CGFloat(toIndex)
        var targetFrame = fromFrame
        targetFrame.origin.x += (toFrame.origin.x - targetFrame.origin.x) * CGFloat(progressPercentage)
        selectedBar.frame = targetFrame
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateSelectedBarPosition(with: false)
    }
}
