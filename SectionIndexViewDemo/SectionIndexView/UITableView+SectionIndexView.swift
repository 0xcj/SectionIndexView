//
//  UITableView+SectionIndexView.swift
//
//  https://github.com/0xcj/SectionIndexView
//
//
//

import UIKit

//MARK: - SectionIndexViewConfiguration
public class SectionIndexViewConfiguration: NSObject {
    @objc public var tableViewVisibleOffset:  CGFloat = 0
    @objc public var itemSize = CGSize.zero
    @objc public var sectionIndexViewVerticalOffset: CGFloat = 0
    @objc public var isItemIndicatorAlwaysInCenter = false
    @objc public var itemIndicatorHorizontalOffset: CGFloat = 0
    @objc public var sectionIndexViewFrameOffset = UIEdgeInsets.zero
   
}


//MARK: - SectionIndexViewManager
private class SectionIndexViewManager: NSObject, SectionIndexViewDelegate, SectionIndexViewDataSource {
    private struct KVOKey {
        static var context = "SectionIndexViewManagerKVOContext"
        static var contentOffset = "contentOffset"
    }
    private var isOperated = false
    private weak var tableView: UITableView?
    private let indexView: SectionIndexView
    private let items: [SectionIndexViewItem]
    private let configuration: SectionIndexViewConfiguration
    
    
    init(_ tableView: UITableView, _ items: [SectionIndexViewItem], _ configuration: SectionIndexViewConfiguration) {
        self.tableView = tableView
        self.items = items
        self.indexView = SectionIndexView.init()
        self.configuration = configuration
        self.indexView.isItemIndicatorAlwaysInCenter = configuration.isItemIndicatorAlwaysInCenter
        self.indexView.itemIndicatorHorizontalOffset = configuration.itemIndicatorHorizontalOffset
        super.init()
        
        indexView.delegate = self
        indexView.dataSource = self
        self.setLayoutConstraint()
        tableView.addObserver(self, forKeyPath: KVOKey.contentOffset, options: .new, context: &KVOKey.context)
        
    }
    
    deinit {
        self.indexView.removeFromSuperview()
        self.tableView?.removeObserver(self, forKeyPath: KVOKey.contentOffset)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &KVOKey.context, keyPath == KVOKey.contentOffset else { return }
        self.tableViewContentOffsetChange()
    }
    
    
    private func setLayoutConstraint() {
        guard let tableView = self.tableView, let superview = tableView.superview else { return }
        superview.addSubview(self.indexView)
        self.indexView.translatesAutoresizingMaskIntoConstraints = false
        let size = self.configuration.itemSize == .zero ? CGSize.init(width: 20, height: self.items.count * 15) : CGSize.init(width: self.configuration.itemSize.width, height: self.configuration.itemSize.height * CGFloat(self.items.count))
        let topOffset = self.configuration.sectionIndexViewFrameOffset.bottom - self.configuration.sectionIndexViewFrameOffset.top
        let rightOffset = self.configuration.sectionIndexViewFrameOffset.right -  self.configuration.sectionIndexViewFrameOffset.left
        
        let constraints = [
            self.indexView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: topOffset),
            self.indexView.widthAnchor.constraint(equalToConstant: size.width),
            self.indexView.heightAnchor.constraint(equalToConstant: size.height),
            self.indexView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: rightOffset)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func tableViewContentOffsetChange() {
        guard let tableView = self.tableView, !self.indexView.isTouching else { return }
        guard self.isOperated || tableView.isTracking else { return }
        guard let visible = tableView.indexPathsForVisibleRows else { return }
        guard let start = visible.first?.section, let end = visible.last?.section else { return }
        guard let topSection = (start..<end + 1).filter({ section($0, isVisibleIn: tableView) }).first else { return }
        guard let item = self.indexView.item(at: topSection), item.bounds != .zero  else { return }
        guard self.indexView.selectedItem != item else { return }
        
        self.isOperated = true
        self.indexView.deselectCurrentItem()
        self.indexView.selectItem(at: topSection)
    }
    
    private func section(_ section: Int, isVisibleIn tableView: UITableView) -> Bool {
        let rect = tableView.rect(forSection: section)
        return tableView.contentOffset.y + self.configuration.tableViewVisibleOffset < rect.origin.y + rect.size.height
    }
    
    
    //MARK: - SectionIndexViewDelegate, SectionIndexViewDataSource
    public func numberOfItems(in sectionIndexView: SectionIndexView) -> Int {
        return self.items.count
    }

    public func sectionIndexView(_ sectionIndexView: SectionIndexView, itemAt section: Int) -> SectionIndexViewItem {
        return self.items[section]
    }

    public func sectionIndexView(_ sectionIndexView: SectionIndexView, didSelect section: Int) {
        guard let tableView = self.tableView, tableView.numberOfSections > section else { return }
        sectionIndexView.hideCurrentItemIndicator()
        sectionIndexView.deselectCurrentItem()
        sectionIndexView.selectItem(at: section)
        sectionIndexView.showCurrentItemIndicator()
        sectionIndexView.impact()
        self.isOperated = true
        tableView.panGestureRecognizer.isEnabled = false
        if tableView.numberOfRows(inSection: section) > 0 {
            tableView.scrollToRow(at: IndexPath.init(row: 0, section: section), at: .top, animated: false)
        } else {
            tableView.scrollRectToVisible(tableView.rect(forSection: section), animated: false)
        }
    }
    
    public func sectionIndexViewToucheEnded(_ sectionIndexView: SectionIndexView) {
        UIView.animate(withDuration: 0.3) {
            sectionIndexView.hideCurrentItemIndicator()
        }
        self.tableView?.panGestureRecognizer.isEnabled = true
    }
}

//MARK: - UITableView Extension
 public extension UITableView {
    
    private struct SectionIndexViewAssociationKey {
        static var manager = "SectionIndexViewAssociationKeyManager"
    }
  
    private var sectionIndexViewManager: SectionIndexViewManager? {
        set {
            guard newValue != sectionIndexViewManager else { return }
            objc_setAssociatedObject(self, &(SectionIndexViewAssociationKey.manager), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &(SectionIndexViewAssociationKey.manager)) as? SectionIndexViewManager
        }
    }
    
    @objc func sectionIndexView(items: [SectionIndexViewItem]) {
        let configuration = SectionIndexViewConfiguration.init()
        self.sectionIndexView(items: items, configuration: configuration)
    }

    @objc func sectionIndexView(items: [SectionIndexViewItem], configuration: SectionIndexViewConfiguration) {
        assert(self.superview != nil, "call this method after setting tableView's superview")
        self.sectionIndexViewManager = SectionIndexViewManager.init(self, items, configuration)
    }
    
}


