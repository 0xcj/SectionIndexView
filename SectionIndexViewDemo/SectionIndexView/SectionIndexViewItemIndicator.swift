//
//  SectionIndexViewItemIndicator.swift
//
//  https://github.com/0xcj/SectionIndexView
//
//
//

import UIKit
            
public class SectionIndexViewItemIndicator: UIView {
    @objc public var titleColor = UIColor.white {
        didSet { titleLabel.textColor = titleColor }
    }
    
    @objc public var titleFont = UIFont.boldSystemFont(ofSize: 35) {
        didSet { titleLabel.font = titleFont }
    }
    
    @objc public var indicatorBackgroundColor = #colorLiteral(red: 0.7841793895, green: 0.7883495688, blue: 0.7922672629, alpha: 1) {
        didSet { shapeLayer.fillColor = indicatorBackgroundColor.cgColor }
    }
    
    private lazy var titleLabel: UILabel = {
        let lab = UILabel.init()
        lab.frame = bounds
        lab.textColor = titleColor
        lab.backgroundColor = .clear
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
        
        let lineX = x * 2 + bounds.width * 0.2
        let lineY = y
        path.addLine(to: CGPoint.init(x: lineX, y: lineY))
        path.close()
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.frame = bounds
        shapeLayer.fillColor = indicatorBackgroundColor.cgColor
        shapeLayer.path = path.cgPath
        return shapeLayer
    }()
    
    @objc public convenience init(title: String) {
        let size = CGSize.init(width: 50, height: 50)
        self.init(size: size, title: title)
    }
    
    @objc public init(size: CGSize, title: String) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        layer.addSublayer(shapeLayer)
        addSubview(titleLabel)
        titleLabel.text = title
    }
    
    private init() {
        fatalError("init has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


