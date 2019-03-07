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
    
    @objc var titleColor: UIColor? {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    @objc var titleFont: UIFont? {
        didSet {
            titleLabel.font = titleFont
        }
    }
    @objc var color: UIColor? {
        didSet {
            switch type {
            case .default, .rect :
                titleLabel.backgroundColor = color
            case .circle :
                titleLabel.layer.borderColor = color?.cgColor
            case .drip :
                shapeLayer.fillColor = color?.cgColor
            default:
                break
            }
        }
    }
    
    private var type: SectionIndexViewItemPreviewType = .default
    
    private lazy var titleLabel: UILabel = {
        let lab = UILabel.init()
        lab.frame = bounds
        lab.textColor = .white
        lab.font = UIFont.boldSystemFont(ofSize: 35)
        lab.adjustsFontSizeToFitWidth = true
        lab.textAlignment = .center
        return lab
    }()
    
    private lazy var shapeLayer: CAShapeLayer = {
        let x = bounds.width * 0.5
        let y = bounds.height * 0.5
        let radius = bounds.width * 0.5
        let startAngle = CGFloat(Double.pi * 0.25)
        let endAngle = CGFloat(Double.pi * 1.75 )
        
        let path = UIBezierPath.init(arcCenter: CGPoint.init(x: x, y: y), radius: radius, startAngle:startAngle, endAngle: endAngle, clockwise: true)
        
        let lineX = x * 2 + 10
        let lineY = y
        path.addLine(to: CGPoint.init(x: lineX, y: lineY))
        path.close()
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.frame = bounds
        shapeLayer.fillColor = #colorLiteral(red: 0.7881487012, green: 0.7882850766, blue: 0.7881400585, alpha: 1)
        shapeLayer.path = path.cgPath
        return shapeLayer
    }()
    
    private lazy var dripView: UIView = {
        let view = UIView.init(frame: bounds)
        view.layer.addSublayer(shapeLayer)
        view.addSubview(titleLabel)
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let v = UIImageView.init(frame: bounds)
        v.contentMode = .center
        return v
    }()
    
     init(title: String? = nil, type:SectionIndexViewItemPreviewType = .default, image: UIImage? = nil) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: 54, height: 54))
        if let image = image {
            addSubview(imageView)
            imageView.image = image
        }
        self.type = type
        setPreview(title: title)
    }
    
    private func setPreview(title: String?) {
        titleLabel.text = title
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
            addSubview(dripView)
        case .empty:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


