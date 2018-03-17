//
//  CircleViewController.swift
//  SectionIndexViewDemo
//
//  Created by 陈健 on 2018/3/17.
//  Copyright © 2018年 ChenJian. All rights reserved.
//

import UIKit

class CircleViewController: UIViewController {

    let reuseIdentifier = "reuseIdentifier"
    let tableViewData = Array<String>.init(repeating: "Swift", count: 20)
    let indexData = ["A","B","C","D","E","F","G","H","I",
                     "J","K","L","M","N","O","P","Q","R",
                     "S","T","U","V","W","X","Y","Z"]
    
    var tableView: UITableView!
    var indexView: SectionIndexView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "circle"
        tableView = UITableView.init(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        indexView = SectionIndexView.init(frame: CGRect.init(x: view.bounds.width - 30, y: 150, width: 30, height: view.bounds.height - 300))
        indexView.itemPreviewMargin = 120
        indexView.dataSource = self
        indexView.delegate = self
        view.addSubview(indexView)
        indexView.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension CircleViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return indexData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return indexData[section]
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = tableViewData[indexPath.row]
        return cell
    }
}


extension CircleViewController: SectionIndexViewDataSource, SectionIndexViewDelegate {
    
    func numberOfItemViews(in sectionIndexView: SectionIndexView) -> Int {
        return indexData.count
    }
    
    func sectionIndexView(sectionIndexView: SectionIndexView, itemViewAt section: Int) -> SectionIndexViewItem {
        let itemView = SectionIndexViewItem.init()
        itemView.title = indexData[section]
        return itemView
    }
    
    func sectionIndexView(sectionIndexView: SectionIndexView, itemPreviewFor section: Int) -> SectionIndexViewItemPreview {
        let preview = SectionIndexViewItemPreview.init(title: indexData[section], type: .circle)
        preview.color = .red
        preview.titleColor = .red
        return preview
    }
    
    func sectionIndexView(sectionIndexView: SectionIndexView, toucheMoved section: Int) {
        sectionIndexView.selectItem(at: section)
        sectionIndexView.showItemPreview(at: section)
        tableView.scrollToRow(at: IndexPath.init(row: 0, section: section), at: .top, animated: false)
    }
    
    func sectionIndexView(sectionIndexView: SectionIndexView, didSelect section: Int) {
        sectionIndexView.selectItem(at: section)
        sectionIndexView.showItemPreview(at: section, hideAfter: 0.2)
        tableView.scrollToRow(at: IndexPath.init(row: 0, section: section), at: .top, animated: false)
    }
}
