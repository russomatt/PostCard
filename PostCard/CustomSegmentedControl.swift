//
//  CustomSegmentedControl.swift
//  PostCard
//
//  Created by Matthew Russo on 6/20/17.
//  Copyright © 2017 Olya Danylova. All rights reserved.
//

import UIKit

@IBDesignable class CustomSegmentedControl: UIControl {
    
    private var labels = [UILabel]()
    var thumbView = UIView()
    var thumbViewBorder = UIView()
    
    var items: [String] = ["Received", "Sent"] {
        didSet {
            setUpLabels()
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
    }
    
    required init?(coder : NSCoder) {
        super.init(coder: coder)
        
        setUpView()
    }
    
    func setUpView() {

        setUpLabels()

        insertSubview(thumbView, at: 1)
        thumbView.insertSubview(thumbViewBorder, at: 0)
    }
    
    func setUpLabels() {

        for label in labels {
            label.removeFromSuperview()
        }

        labels.removeAll(keepingCapacity: true)
        
        for index in 1...items.count {

            let label = UILabel(frame: CGRect.zero)

            label.text = items[index - 1]
            label.textAlignment = .center
            label.textColor = UIColor(red:0.30, green:0.30, blue:0.30, alpha:1.0)
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.text = label.text?.uppercased()
            let attributedString = NSMutableAttributedString(string: label.text!)
            attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.5), range: NSRange(location: 0, length: Int(Double(attributedString.length) - 1.5)))
            label.attributedText = attributedString

            self.addSubview(label)
            labels.append(label)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var selectedFrame = self.bounds
        let newWidth = CGFloat(selectedFrame.size.width) / CGFloat(items.count)
        selectedFrame.size.width = newWidth
        let labelHeight: CGFloat = self.bounds.height
        let labelWidth: CGFloat = self.bounds.width / CGFloat(labels.count)

        let borderYPosn = CGFloat(labelHeight - 5)
        thumbViewBorder.frame = CGRect(x: 0, y: borderYPosn, width: labelWidth, height: 5)
        thumbViewBorder.backgroundColor = UIColor(red:0.30, green:0.30, blue:0.30, alpha:1.0)

        thumbView.frame = selectedFrame
        thumbView.backgroundColor = UIColor.clear
        
        for index in 0...labels.count - 1 {
            let label = labels[index]
            let yPosn = CGFloat(0)
            let xPosn = CGFloat(index) * labelWidth
            label.frame = CGRect(x: xPosn, y: yPosn, width: labelWidth, height: labelHeight)
        }
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        var calculatedIndex : Int?
        
        for(index, item) in labels.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    func displayNewSelectedIndex() {
        let label = labels[selectedIndex]
        let labelWidth = label.frame.size.width
        let labelHeight = label.frame.size.height
        let borderYPosn = CGFloat(labelHeight - 5)

        
        thumbViewBorder.frame = CGRect(x: 0, y: borderYPosn, width: labelWidth, height: 5)
        thumbViewBorder.backgroundColor = UIColor(red:0.30, green:0.30, blue:0.30, alpha:1.0)
        self.thumbView.frame = label.frame
    }

}
 
