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


//MARK: - SectionIndexViewItem
@objc public protocol SectionIndexViewItem where Self: UIView {
    
    /// A Boolean value indicating whether the `Item` is in the selected state.
    /// If the item’s `isSelected` were `false`, SectionIndexView would set `true`  when  touch inside the item’s bounds.
    /// If the item’s `isSelected` were `true`, SectionIndexView would set `false`  when  touch outside the item’s bounds.
    var isSelected: Bool { get set }
    
    /// Item’s indicator.
    /// When item is in the selected state, indicator will show, otherwise hide.
    var indicator: UIView? { get set }
}

//MARK: - SectionIndexViewItemView

/// SectionIndexViewItemView is a kind of SectionIndexViewItem
///
///   ┌─┐
///   │ A│-------> Item (SectionIndexViewItem)
///   └─┘
///
public class SectionIndexViewItemView: UIView, SectionIndexViewItem {
    @objc public var isSelected: Bool = false {
        didSet {
            self.selectItem(isSelected)
        }
    }
    @objc public var indicator: UIView?

    @objc public var image: UIImage? {
        set { imageView.image = newValue }
        get { imageView.image }
    }
    @objc public var selectedImage: UIImage? {
        set { imageView.highlightedImage = newValue }
        get { imageView.highlightedImage }
    }
    @objc public var title: String? {
        set { titleLabel.text = newValue }
        get { titleLabel.text }
    }
    @objc public var titleFont: UIFont {
        set { titleLabel.font = newValue }
        get { titleLabel.font }
    }
    @objc public var titleColor: UIColor {
        set { titleLabel.textColor = newValue }
        get { titleLabel.textColor }
    }
    @objc public var titleSelectedColor: UIColor? {
        set { titleLabel.highlightedTextColor = newValue }
        get { titleLabel.highlightedTextColor }
    }
    
    @objc public var selectedColor: UIColor? {
        set { selectedView.backgroundColor = newValue }
        get { selectedView.backgroundColor }
    }
        
    private let titleLabel: UILabel = {
        let label = UILabel.init()
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = #colorLiteral(red: 0.3005631345, green: 0.3005631345, blue: 0.3005631345, alpha: 1)
        label.highlightedTextColor = #colorLiteral(red: 0, green: 0.5291740298, blue: 1, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    
    private let imageView: UIImageView = {
        let v = UIImageView.init()
        v.contentMode = .center
        return v
    }()
    
    private let selectedView: UIView = {
        let v = UIView.init()
        v.backgroundColor = .clear
        v.isHidden = true
        return v
    }()
    
    @objc public required init() {
        super.init(frame: .zero)
        addSubview(selectedView)
        addSubview(imageView)
        addSubview(titleLabel)
        setLayoutConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutConstraint() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.heightAnchor.constraint(equalTo: titleLabel.widthAnchor)
        ])
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectedView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            selectedView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            selectedView.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            selectedView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])
    }
    
    private func selectItem(_ select: Bool) {
        if selectedView.layer.cornerRadius == 0, selectedView.bounds.width > 0 {
            selectedView.layer.cornerRadius = selectedView.bounds.width * 0.5
        }
        titleLabel.isHighlighted = select
        imageView.isHighlighted = select
        selectedView.isHidden = !select
    }
}
