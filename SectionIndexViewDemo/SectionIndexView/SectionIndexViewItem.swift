//
//  SectionIndexViewItem.swift
//
//  https://github.com/0xcj/SectionIndexView
//
//
//

import UIKit


//MARK: - SectionIndexViewItem
public class SectionIndexViewItem: UIView {
    @objc public var isSelected = false
    @objc public var indicator: UIView?
}



//MARK: - SectionIndexViewItemView
public class SectionIndexViewItemView: SectionIndexViewItem {

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
    
    @objc public var selectedMargin: CGFloat = 0
    
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
    
    @objc public init() {
        super.init(frame: CGRect.zero)
        addSubview(selectedView)
        addSubview(imageView)
        addSubview(titleLabel)
        setLayoutConstraint()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    @objc public override var isSelected: Bool {
        didSet {
            self.selectItem(isSelected)
        }
    }
}
