//
//  SectionIndexView.swift
//
//  https://github.com/0xcj/SectionIndexView
//
//
//

import UIKit

public let SectionIndexViewTouchesOccurredNotification = "SectionIndexViewTouchesOccurredNotification"
public let SectionIndexViewTouchesEndedNotification = "SectionIndexViewTouchesEndedNotification"

//MARK: - SectionIndexViewDataSource

@objc public protocol SectionIndexViewDataSource: NSObjectProtocol {
    @objc func numberOfItems(in sectionIndexView: SectionIndexView) -> Int
    @objc func sectionIndexView(_ sectionIndexView: SectionIndexView, itemAt section: Int) -> SectionIndexViewItem
}

//MARK: - SectionIndexViewDelegate

@objc public protocol SectionIndexViewDelegate: NSObjectProtocol {
    @objc func sectionIndexView(_ sectionIndexView: SectionIndexView, didSelect section: Int)
    @objc func sectionIndexViewToucheEnded(_ sectionIndexView: SectionIndexView)
}


//MARK: - SectionIndexView
public class SectionIndexView: UIView {

    @objc public weak var dataSource: SectionIndexViewDataSource? { didSet { reloadData() } }
    @objc public weak var delegate: SectionIndexViewDelegate?
        
    @objc public var itemIndicatorHorizontalOffset: CGFloat = 0
    @objc public var isItemIndicatorAlwaysInCenter = false
    
    @objc public private(set) var selectedItem: SectionIndexViewItem?
    @objc public private(set) var isTouching = false
    
    @available(iOS 10.0, *)
    private lazy var generator: UIImpactFeedbackGenerator = {
        return UIImpactFeedbackGenerator.init(style: .light)
    }()
        
    private var items = [SectionIndexViewItem]()
    private var itemLayoutConstraints = [SectionIndexViewItem: [NSLayoutConstraint]]()
    
            
    // MARK: - Func
    
    @objc public func reloadData() {
        for item in items {
            item.removeFromSuperview()
            item.indicator?.removeFromSuperview()
            item.isHidden = false
        }
        items.removeAll()
        loadView()
    }
    
    private func loadView() {
        guard let numberOfItems = dataSource?.numberOfItems(in: self) else { return }
        items = Array(0..<numberOfItems).compactMap { dataSource?.sectionIndexView(self, itemAt: $0)}
        setItemsLayoutConstraint()
    }
     
    private func setItemsLayoutConstraint() {
        guard !items.isEmpty else { return }
        let heightMultiplier = CGFloat(1) / CGFloat(items.count)
        for (i, item) in items.enumerated() {
            item.translatesAutoresizingMaskIntoConstraints = false
            addSubview(item)
            if let oldConstraints = itemLayoutConstraints[item] {
                NSLayoutConstraint.deactivate(oldConstraints)
            }
            let constraints = [
                item.leadingAnchor.constraint(equalTo: leadingAnchor),
                item.trailingAnchor.constraint(equalTo: trailingAnchor),
                item.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightMultiplier),
                item.topAnchor.constraint(equalTo: i == 0 ? topAnchor : items[i - 1].bottomAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
            itemLayoutConstraints[item] = constraints
        }
    }
    
    @objc public func item(at section: Int) -> SectionIndexViewItem? {
        guard section >= 0, section < items.count else { return nil }
        return items[section]
    }
    
    @objc public func impact() {
        guard #available(iOS 10.0, *) else { return }
        generator.prepare()
        generator.impactOccurred()
    }
    
    @objc public func selectItem(at section: Int) {
        guard let item = item(at: section) else { return }
        item.isSelected = true
        selectedItem = item
    }
    
    @objc public func deselectCurrentItem() {
        selectedItem?.isSelected = false
        selectedItem = nil
    }
    
    @objc public func showCurrentItemIndicator() {
        guard let selectedItem = selectedItem, let indicator = selectedItem.indicator else { return }
        if indicator.superview == nil {
            let centerY = selectedItem.center.y
            let x = -(indicator.bounds.width * 0.5 + 20 - itemIndicatorHorizontalOffset)
            let y = isItemIndicatorAlwaysInCenter ? (bounds.height - selectedItem.bounds.height) * 0.5 : centerY
            indicator.center = CGPoint.init(x: x, y: y)
            addSubview(indicator)
        } else {
            indicator.alpha = 1
        }
    }
    
    @objc public func hideCurrentItemIndicator() {
        self.selectedItem?.indicator?.alpha = 0
    }
    
    
    // MARK: -  Touches handle
    private func point(_ point: CGPoint, isIn view: UIView) -> Bool {
        return point.y <= (view.frame.origin.y + view.frame.size.height) && point.y >= view.frame.origin.y
    }
    
    private func getSectionBy(_ touches: Set<UITouch>) -> Int? {
        guard let touch = touches.first else { return nil }
        let p = touch.location(in: self)
        return items.enumerated().filter { point(p, isIn: $0.element) }.compactMap { $0.offset }.first
    }
    
    private func touchesOccurred(_ touches: Set<UITouch>) {
        isTouching = true
        guard let section = getSectionBy(touches) else { return }
        guard let item = item(at: section), selectedItem != item else { return }
        delegate?.sectionIndexView(self, didSelect: section)
        NotificationCenter.default.post(name: NSNotification.Name.init(SectionIndexViewTouchesOccurredNotification), object: section)
    }
    
    private func touchesEnded() {
        delegate?.sectionIndexViewToucheEnded(self)
        NotificationCenter.default.post(name: NSNotification.Name.init(SectionIndexViewTouchesEndedNotification), object: nil)
        isTouching = false
    }
    
    
    // MARK: - UIView TouchesEvent
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesOccurred(touches)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesOccurred(touches)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded()
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded()
    }
}



