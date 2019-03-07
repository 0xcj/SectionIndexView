//
//  ViewController.swift
//  SectionIndexViewDemo
//
//  Created by 陈健 on 2018/3/13.
//  Copyright © 2018年 ChenJian. All rights reserved.
//

import UIKit

//MARK: - ZLSectionIndexViewItem
class SectionIndexViewItem: UIView {
    
    @objc var isSeleted = false
    @objc var image: UIImage? {
        didSet{
            imageView.image = image
        }
    }
    @objc var selectedImage: UIImage? {
        didSet{
            imageView.highlightedImage = selectedImage
        }
    }
    @objc var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    @objc var titleFont: UIFont? {
        didSet {
            titleLabel.font = titleFont
        }
    }
    @objc var titleColor: UIColor? {
        didSet{
            titleLabel.textColor = titleColor
        }
    }
    @objc var titleSelectedColor: UIColor? {
        didSet{
            titleLabel.highlightedTextColor = titleSelectedColor
        }
    }
    
    @objc var selectedColor = UIColor.red {
        didSet {
            selectedView.backgroundColor = selectedColor
        }
    }
    
    @objc var selectedMargin: CGFloat = 0
    
    private var titleLabel: UILabel = {
        let label = UILabel.init()
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.textColor = .black
        label.highlightedTextColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let v = UIImageView.init()
        v.contentMode = .center
        return v
    }()
    
    private var selectedView: UIView
    
    override init(frame: CGRect) {
        selectedView = UIView.init()
        selectedView.backgroundColor = selectedColor
        selectedView.alpha = 0
        
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(titleLabel)
        insertSubview(selectedView, at: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        titleLabel.frame = bounds
        imageView.frame = bounds
        
        let width = min(bounds.width - selectedMargin, bounds.height - selectedMargin)
        let height = width
        let center = CGPoint.init(x: bounds.width * 0.5, y: bounds.height * 0.5)
        selectedView.frame = CGRect.init(x: 0, y: 0 , width: width, height: height)
        selectedView.center = center
        selectedView.layer.cornerRadius = selectedView.bounds.width * 0.5
    }
    
    @objc func select() {
        isSeleted = true
        titleLabel.isHighlighted = true
        imageView.isHighlighted = true
        selectedView.alpha = 1
    }
    
    @objc func deselect() {
        selectedView.alpha = 0
        isSeleted = false
        titleLabel.isHighlighted = false
        imageView.isHighlighted = false
    }
}
