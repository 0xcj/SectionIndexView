//
//  ViewController.swift
//  SectionIndexViewDemo
//
//  Created by 陈健 on 2018/3/13.
//  Copyright © 2018年 ChenJian. All rights reserved.
//

import UIKit

@objc enum SectionIndexViewItemPreviewType: Int {
    case `default`
    case rect
    case circle
    case drip
    case empty
}


class SectionIndexViewItemPreview: UIView {
    
    var titleColor: UIColor? {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    var titleFont: UIFont? {
        didSet {
            titleLabel.font = titleFont
        }
    }
    var color: UIColor? {
        didSet {
            switch type {
            case .default?, .rect? :
                titleLabel.backgroundColor = color
            case .circle? :
                titleLabel.layer.borderColor = color?.cgColor
            case .drip? :
                shapeLayer?.fillColor = color?.cgColor
            default:
                break
            }
        }
    }
    
    private var type: SectionIndexViewItemPreviewType?
    private var titleLabel = UILabel.init()
    private var shapeLayer: CAShapeLayer?
    
    convenience init(title: String?) {
        self.init(title: title, type: .default)
    }
    
    convenience init(title: String?, type: SectionIndexViewItemPreviewType) {
        self.init(title: title, type: type, image: nil)
    }
    
    convenience init(title: String?, type:SectionIndexViewItemPreviewType, image: UIImage?) {
        self.init()
        
        self.type = type
        
        if image != nil {
            let imageView = UIImageView.init(frame: bounds)
            imageView.image = image
            imageView.contentMode = .center
            addSubview(imageView)
        }
        
        titleLabel.frame = bounds
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 35)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        
        switch type {
        case .default:
            titleLabel.backgroundColor = #colorLiteral(red: 0.7881487012, green: 0.7882850766, blue: 0.7881400585, alpha: 1)
            titleLabel.layer.cornerRadius = titleLabel.frame.size.width * 0.5
            titleLabel.layer.masksToBounds = true
            titleLabel.shadowColor = .darkGray
            titleLabel.shadowOffset = CGSize.init(width: 1, height: 1)
            addSubview(titleLabel)
        case .rect:
            titleLabel.backgroundColor = #colorLiteral(red: 0.002085188171, green: 0.8053717613, blue: 0.8079184294, alpha: 1)
            titleLabel.layer.masksToBounds = true
            titleLabel.layer.cornerRadius = 5
            addSubview(titleLabel)
        case .circle:
            titleLabel.backgroundColor = .clear
            titleLabel.textColor = #colorLiteral(red: 0.002085188171, green: 0.8053717613, blue: 0.8079184294, alpha: 1)
            titleLabel.layer.cornerRadius = titleLabel.frame.size.width * 0.5
            titleLabel.layer.borderWidth = 5
            titleLabel.layer.borderColor = #colorLiteral(red: 0.002085188171, green: 0.8053717613, blue: 0.8079184294, alpha: 1)
            addSubview(titleLabel)
        case .drip:
            let view = UIView.init(frame: bounds)
            
            let shapeLayer = CAShapeLayer.init()
            shapeLayer.frame = bounds
            shapeLayer.fillColor = #colorLiteral(red: 0.7881487012, green: 0.7882850766, blue: 0.7881400585, alpha: 1)
            let path = UIBezierPath.init(arcCenter: CGPoint.init(x: bounds.width * 0.5, y: bounds.height * 0.5), radius: bounds.width * 0.5, startAngle:CGFloat(Double.pi * 0.25), endAngle: CGFloat(Double.pi * 1.75 ), clockwise: true)
            path.addLine(to: CGPoint.init(x: bounds.width + 10, y: bounds.height * 0.5))
            path.close()
            shapeLayer.path = path.cgPath
            view.layer.addSublayer(shapeLayer)
            self.shapeLayer = shapeLayer
            view.addSubview(titleLabel)
            addSubview(view)
        case .empty:
            break
        }
    }
    
    init() {
        super.init(frame: CGRect.init(x: 0, y: 0, width: 54, height: 54))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


