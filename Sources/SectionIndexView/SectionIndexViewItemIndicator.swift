//
// https://github.com/0xcj/SectionIndexView
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


///  ┌─────────────────┐
///  │                                                             │
///  │                                                  ┌─┐│              ┌─┐
///  │                                                  │A ││              │A │        ┌─┐
///  │                                                  ├─┤│              ├─┤       │ A │-------> Item (SectionIndexViewItem)
///  │                                                  │B ││              │B │       └─┘
///  │                                                  ├─┤│              ├─┤
///  │                                                  │C ││              │C │
///  │                                                  ├─┤│              ├─┤
///  │                                                  │D ││              │D │
///  │                                                  ├─┤│              ├─┤
///  │                                                  │E ││              │E │--------------------------->  SectionIndexView
///  │                  ┌─┐                     ├─┤│              ├─┤
///  │                  │G │                     │F ││              │F │
///  │                  └─┘                     ├─┤│              ├─┤
///  │                     │                         │G ││              │G │
///  │                     │                         ├─┤│              ├─┤
///  │                     ⇩                         │H ││              │H │
///  │           Indicator (UIView)          ├─┤│              ├─┤
///  │                                                  │ I  ││             │ I  │
///  │                                                  ├─┤│             ├─┤
///  │                                                  │J  ││             │J  │
///  │                                                  ├─┤│             ├─┤
///  │                                                  │K ││             │K │
///  │                                                  └─┘│             └─┘
///  │                                                             │
///  │                                                             │
///  │                                                             │
///  └─────────────────┘

#if canImport(UIKit)

import UIKit

#endif

/// SectionIndexViewItemIndicator is a kind of Indicator
///               ┌─┐
///               │G │
///               └─┘
///                 │
///                 │
///                 ⇩
///           Indicator (UIView)
///
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
    
    private override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    private init() {
        fatalError("init has not been implemented")
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


