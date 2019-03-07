//
//  EmptyViewController.swift
//  SectionIndexViewDemo
//
//  Created by 陈健 on 2018/3/17.
//  Copyright © 2018年 ChenJian. All rights reserved.
//

import UIKit

class EmptyViewController: UIViewController {

    let reuseIdentifier = "reuseIdentifier"
    let tableViewData = Array<String>.init(repeating: "Swift", count: 20)
    let indexData = ["A","B","C","D","E","F","G","H","I",
                     "J","K","L","M","N","O","P","Q","R",
                     "S","T","U","V","W","X","Y","Z"]
    
    var tableView: UITableView!
    var indexView: SectionIndexView!
    
    var disableScrollSelect = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "empty"
        
        let y = CGFloat(view.bounds.height == 812 ? 88 : 64)
        let frame = CGRect.init(x: 0, y: y, width: view.bounds.width, height: view.bounds.height - y)
        
        tableView = UITableView.init(frame: frame, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        indexView = SectionIndexView.init(frame: CGRect.init(x: view.bounds.width - 30, y: 150, width: 30, height: view.bounds.height - 300))
        indexView.dataSource = self
        indexView.delegate = self
        indexView.isItemPreviewAlwaysInCenter = true
        indexView.itemPreviewMargin = 120
        view.addSubview(indexView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension EmptyViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return indexData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(arc4random()) % tableViewData.count + 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return indexData[section]
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = tableViewData[indexPath.row]
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard disableScrollSelect == false else { return }
        if let section = tableView.indexPathsForVisibleRows?.first?.section, indexView.currentItem != indexView.item(at: section) {
            indexView.selectItem(at: section)
        }
    }
}


extension EmptyViewController: SectionIndexViewDataSource, SectionIndexViewDelegate {
    
    func numberOfItemViews(in sectionIndexView: SectionIndexView) -> Int {
        return indexData.count
    }
    
    func sectionIndexView(_ sectionIndexView: SectionIndexView, itemViewAt section: Int) -> SectionIndexViewItem {
        if section % 5 == 0 {
            let itemView = SectionIndexViewItem.init()
            itemView.selectedColor = .clear
            itemView.image = #imageLiteral(resourceName: "sectionIndexView_fire")
            itemView.selectedImage = #imageLiteral(resourceName: "sectionIndexView_fire_s")
            return itemView
        }
        let itemView = SectionIndexViewItem.init()
        itemView.title = indexData[section]
        return itemView
    }
    
    func sectionIndexView(_ sectionIndexView: SectionIndexView, itemPreviewFor section: Int) -> SectionIndexViewItemPreview {
        var preview: SectionIndexViewItemPreview
        if section <= 6 {
            preview = SectionIndexViewItemPreview.init(title: indexData[section], type: .empty, image: #imageLiteral(resourceName: "sectionIndexView_star"))
            return preview
        }
        if section >= 8 && section <= 15 {
            preview = SectionIndexViewItemPreview.init(title: nil, type: .empty)
            return preview
        }
        if section > 15 && section <= 21 {
            preview = SectionIndexViewItemPreview.init(title: indexData[section], type: .default, image: #imageLiteral(resourceName: "sectionIndexView_star"))
            preview.color = .clear
            preview.titleColor = #colorLiteral(red: 0.3077450097, green: 0.6633865237, blue: 0.8674423099, alpha: 1)
            preview.titleFont = UIFont.boldSystemFont(ofSize: 20)
            return preview
        }
        preview = SectionIndexViewItemPreview.init(title: indexData[section], type: .default)
        return preview
    }
    
    func sectionIndexView(_ sectionIndexView: SectionIndexView, toucheMoved section: Int) {
        sectionIndexView.selectItem(at: section)
        sectionIndexView.showItemPreview(at: section)
        disableScrollSelect = true
        tableView.scrollToRow(at: IndexPath.init(row: 0, section: section), at: .top, animated: false)
        disableScrollSelect = false
    }
    
    func sectionIndexView(_ sectionIndexView: SectionIndexView, didSelect section: Int) {
        sectionIndexView.selectItem(at: section)
        sectionIndexView.showItemPreview(at: section, hideAfter: 0.2)
        disableScrollSelect = true
        tableView.scrollToRow(at: IndexPath.init(row: 0, section: section), at: .top, animated: false)
        disableScrollSelect = false
    }
}

