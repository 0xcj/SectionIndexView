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
    
    var isSeleted = false
    var image: UIImage? {
        didSet{
            initImageView()
            imageView?.image = image
        }
    }
    var selectedImage: UIImage? {
        didSet{
            initImageView()
            imageView?.highlightedImage = selectedImage
        }
    }
    var title: String? {
        didSet {
            initTitleLabel()
            titleLabel?.text = title
            
        }
    }
    var titleFont: UIFont? {
        didSet {
            initTitleLabel()
            titleLabel?.font = titleFont
        }
    }
    var titleColor: UIColor? {
        didSet{
            initTitleLabel()
            titleLabel?.textColor = titleColor
        }
    }
    var titleSelectedColor: UIColor? {
        didSet{
            initTitleLabel()
            titleLabel?.highlightedTextColor = titleSelectedColor
        }
    }
    
    var selectedColor = UIColor.red {
        didSet {
            selectedView.backgroundColor = selectedColor
        }
    }
    var selectedMargin: CGFloat = 0
    
    private var titleLabel: UILabel?
    private var imageView: UIImageView?
    private var selectedView: UIView
    
    override init(frame: CGRect) {
        selectedView = UIView.init()
        selectedView.backgroundColor = selectedColor
        selectedView.alpha = 0
        
        super.init(frame: frame)
        
        insertSubview(selectedView, at: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        titleLabel?.frame = bounds
        imageView?.frame = bounds
        
        let width = min(bounds.width - selectedMargin, bounds.height - selectedMargin)
        let height = width
        let center = CGPoint.init(x: bounds.width * 0.5, y: bounds.height * 0.5)
        selectedView.frame = CGRect.init(x: 0, y: 0 , width: width, height: height)
        selectedView.center = center
        selectedView.layer.cornerRadius = selectedView.bounds.width * 0.5
    }
    
    func select() {
        isSeleted = true
        titleLabel?.isHighlighted = true
        imageView?.isHighlighted = true
        selectedView.alpha = 1
    }
    
    func deselect() {
        selectedView.alpha = 0
        isSeleted = false
        titleLabel?.isHighlighted = false
        imageView?.isHighlighted = false
    }
    
    private func initTitleLabel() {
        guard titleLabel == nil else { return }
        let label = UILabel.init()
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.textColor = .black
        label.highlightedTextColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        addSubview(label)
        titleLabel = label
    }
    private func initImageView() {
        guard imageView == nil else { return }
        let view = UIImageView.init()
        view.contentMode = .center
        addSubview(view)
        self.imageView = view
    }
}
