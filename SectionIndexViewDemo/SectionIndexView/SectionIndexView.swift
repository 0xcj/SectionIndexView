//
//  ViewController.swift
//  SectionIndexViewDemo
//
//  Created by 陈健 on 2018/3/13.
//  Copyright © 2018年 ChenJian. All rights reserved.
//

import UIKit


//MARK: - SectionIndexViewDataSource

@objc protocol SectionIndexViewDataSource: AnyObject {
    func numberOfItemViews(in sectionIndexView: SectionIndexView) -> Int
    
    func sectionIndexView(_ sectionIndexView: SectionIndexView, itemViewAt section: Int) -> SectionIndexViewItem
    
    @objc optional func sectionIndexView(_ sectionIndexView: SectionIndexView, itemPreviewFor section: Int) -> SectionIndexViewItemPreview
}

//MARK: - SectionIndexViewDelegate

@objc protocol SectionIndexViewDelegate: AnyObject {
    @objc optional func sectionIndexView(_ sectionIndexView: SectionIndexView, didSelect section: Int)
    
    @objc optional func sectionIndexView(_ sectionIndexView: SectionIndexView, toucheMoved section: Int)
    
    @objc optional func sectionIndexView(_ sectionIndexView: SectionIndexView, toucheCancelled section: Int)
    
}


//MARK: - SectionIndexViewItemPreviewDirection
@objc enum SectionIndexViewItemPreviewDirection: Int {
    case left,right
}

//MARK: - SectionIndexView
class SectionIndexView: UIView {
    
    @objc weak var dataSource: SectionIndexViewDataSource? {
        didSet {
            loadView()
        }
    }
    @objc weak var delegate:   SectionIndexViewDelegate?
    
    @objc var isShowItemPreview: Bool = true
    
    @objc var itemPreviewDirection: SectionIndexViewItemPreviewDirection = .left
    
    @objc var itemPreviewMargin: CGFloat = 0
    
    @objc var isItemPreviewAlwaysInCenter = false
    
    @objc var currentItem: SectionIndexViewItem? {
        get {
            return _currentItem
        }
    }
    
    
    //MARK: - private
    
    private var items = Array<SectionIndexViewItem>.init()
    
    private var itemPreviews = Array<SectionIndexViewItemPreview>.init()

    private var _currentItem: SectionIndexViewItem?
    
    private var touchItem: SectionIndexViewItem?
    
    fileprivate var currentItemPreview: UIView?
    
    // MARK: - Func
    @objc func loadView() {
        if let numberOfItemViews = dataSource?.numberOfItemViews(in: self) {
            let height = bounds.height / CGFloat(numberOfItemViews)
            itemPreviews = Array<SectionIndexViewItemPreview>.init()
            for i in 0..<numberOfItemViews {
                if let itemView = dataSource?.sectionIndexView(self, itemViewAt: i) {
                    items.append(itemView)
                    itemView.frame = CGRect.init(x: 0, y: height * CGFloat(i), width: bounds.width, height: height)
                    addSubview(itemView)
                }
                if let itemPreview = dataSource?.sectionIndexView?(self, itemPreviewFor: i) {
                    itemPreviews.append(itemPreview)
                }
            }
        }
    }
    
    @objc func reloadData() {
        for itemView in self.items {
            itemView.removeFromSuperview()
        }
        items.removeAll()
        loadView()
    }
    
    @objc func item(at section: Int) -> SectionIndexViewItem? {
        if section >= items.count || section < 0 {
            return nil
        }
        return items[section]
    }
    
    @objc func selectItem(at section: Int) {
        if section >= items.count || section < 0 {
            return
        }
        deselectCurrentItem()
        _currentItem = items[section]
        items[section].select()
    }
    
    @objc func deselectCurrentItem() {
        _currentItem?.deselect()
    }
    
    @objc func showItemPreview(at section:Int, hideAfter delay: Double) {
        showItemPreview(at: section)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.currentItemPreview?.removeFromSuperview()
        }
    }
    
    @objc func showItemPreview(at section:Int) {
        guard
            isShowItemPreview == true,
            section < itemPreviews.count && section >= 0,
            let currentItem = _currentItem
            else { return }
        let preview = itemPreviews[section]
        currentItemPreview?.removeFromSuperview()
        
        var x,
        y:CGFloat
        switch self.itemPreviewDirection {
        case .right:
            x = currentItem.bounds.width + preview.bounds.width * 0.5 + itemPreviewMargin
        case .left:
            x = -(preview.bounds.width * 0.5 + itemPreviewMargin)
        }
        let centerY = currentItem.center.y
        y = isItemPreviewAlwaysInCenter == true ? (bounds.height - currentItem.bounds.height) * 0.5 : centerY
        preview.center = CGPoint.init(x: x, y: y)
        
        addSubview(preview)
        currentItemPreview = preview
    }
    
    private func getSectionBy(touches: Set<UITouch>) -> Int? {
        if let touch = touches.first {
            let point = touch.location(in: self)
            var item: SectionIndexViewItem
            for i in 0..<items.count {
                item = items[i]
                if item.frame.contains(point) == true {
                    return i
                }
            }
        }
        return nil
    }
    // MARK: - TouchesEvent
    override internal func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self)
            var item: SectionIndexViewItem
            for i in 0..<items.count {
                item = items[i]
                if touchItem != item && point.y <= (item.frame.origin.y + item.frame.size.height) && point.y >= item.frame.origin.y {
                    if  delegate?.sectionIndexView?(self, toucheMoved: i) != nil {
                        //
                    } else {
                        selectItem(at: i)
                        showItemPreview(at: i)
                    }
                    touchItem = item
                    return
                }
            }
        }
    }
    
    override internal func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let section = getSectionBy(touches: touches) {
            if delegate?.sectionIndexView?(self, didSelect: section) != nil {
                //
            }else {
                selectItem(at: section)
                showItemPreview(at: section, hideAfter: 0.2)
            }
            return
        }
        
        for i in 0..<items.count {
            if items[i] == _currentItem {
                delegate?.sectionIndexView?(self, didSelect: i)
            }
        }
    }
    
    override internal func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if  let section = getSectionBy(touches: touches) {
            if delegate?.sectionIndexView?(self, toucheCancelled: section) != nil {
                //
            }else {
                currentItemPreview?.removeFromSuperview()
            }
        }
    }
}



