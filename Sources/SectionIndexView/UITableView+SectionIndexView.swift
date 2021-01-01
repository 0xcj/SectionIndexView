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

//MARK: - SectionIndexViewConfiguration
public final class SectionIndexViewConfiguration: NSObject {
    
    /// Configure this property to assure `SectionIndexView` has correct scrolling when your navigationBar not hidden and  UITableView  use ` contentInsetAdjustmentBehavior`  or ` automaticallyAdjustsScrollViewInsets`  to adjust content.
    /// This value should equal to UITableView’s adjustment content inset.
    ///
    ///         let frame = CGRect.init(x: 0, y: 0, width: width, height: height)
    ///         let tableView = UITableView.init(frame: frame, style: .plain)
    ///
    ///         let navBarHeight = navigationController.navigationBar.frame.height
    ///         let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    ///
    ///         let configuration = SectionIndexViewConfiguration.init()
    ///         configuration.adjustedContentInset = navBarHeight + statusBarHeight
    ///         tableView.sectionIndexView(items: items, configuration: configuration)
    /// Default is 0.
    @objc public var adjustedContentInset: CGFloat = 0
    
    /// Configure the `item` size.
    /// Default is CGSize.init(width: 20, height: 15).
    @objc public var itemSize = CGSize.init(width: 20, height: 15)
    
    /// Configure the` indicator` always in centerY of `SectionIndexView`.
    /// Default is false.
    @objc public var isItemIndicatorAlwaysInCenterY = false
    
    /// Configure the `indicator` horizontal offset.
    /// Default is -20.
    @objc public var itemIndicatorHorizontalOffset: CGFloat = -20
    
    /// Configure the `SectionIndexView’s` location.
    /// Default is UIEdgeInsets.zero.
    @objc public var sectionIndexViewOriginInset = UIEdgeInsets.zero
   
}

//MARK: - UITableView Extension

public extension UITableView {
    
    /// Set sectionIndexView.
    /// - Parameter items: items for sectionIndexView.
    @objc func sectionIndexView(items: [SectionIndexViewItem]) {
        let configuration = SectionIndexViewConfiguration.init()
        self.sectionIndexView(items: items, configuration: configuration)
    }
    
    /// Set sectionIndexView.
    /// - Parameters:
    ///   - items: items for sectionIndexView.
    ///   - configuration: configuration for sectionIndexView.
    @objc func sectionIndexView(items: [SectionIndexViewItem], configuration: SectionIndexViewConfiguration) {
        assert(self.superview != nil, "Call this method after setting tableView's superview.")
        self.sectionIndexViewManager = SectionIndexViewManager.init(self, items, configuration)
    }
}

private extension UITableView {
    private struct SectionIndexViewAssociationKey {
        static var manager = "SectionIndexViewAssociationKeyManager"
    }
    private var sectionIndexViewManager: SectionIndexViewManager? {
        set {
            objc_setAssociatedObject(self, &(SectionIndexViewAssociationKey.manager), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &(SectionIndexViewAssociationKey.manager)) as? SectionIndexViewManager
        }
    }
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
        self.indexView.isItemIndicatorAlwaysInCenterY = configuration.isItemIndicatorAlwaysInCenterY
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
        let size = CGSize.init(width: self.configuration.itemSize.width, height: self.configuration.itemSize.height * CGFloat(self.items.count))
        let topOffset = self.configuration.sectionIndexViewOriginInset.bottom - self.configuration.sectionIndexViewOriginInset.top
        let rightOffset = self.configuration.sectionIndexViewOriginInset.right -  self.configuration.sectionIndexViewOriginInset.left
        
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
        guard !(self.indexView.selectedItem?.isEqual(item) ?? false) else { return }
        self.isOperated = true
        self.indexView.deselectCurrentItem()
        self.indexView.selectItem(at: topSection)
    }
    
    private func section(_ section: Int, isVisibleIn tableView: UITableView) -> Bool {
        let rect = tableView.rect(forSection: section)
        return tableView.contentOffset.y + self.configuration.adjustedContentInset < rect.origin.y + rect.size.height
    }
    
    //MARK: - SectionIndexViewDelegate, SectionIndexViewDataSource
    public func numberOfScetions(in sectionIndexView: SectionIndexView) -> Int {
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

