//
//  CusViewController.swift
//
//  https://github.com/0xcj/SectionIndexView
//
//
//

import UIKit

class CusViewController: UIViewController {
    private let identifier = "acell"
    private var dataSource = [(key: String, value: [Person])]()
    private lazy var tableView: UITableView = {
        let v = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), style: .plain)
        v.showsVerticalScrollIndicator = false
        v.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        v.delegate = self
        v.dataSource = self
        return v
    }()
    private let tableViewVisibleOffset = UIApplication.shared.statusBarFrame.size.height + 44
    private lazy var indexView: SectionIndexView = {
        let height = CGFloat(self.dataSource.count * 15)
        let frame = CGRect.init(x: view.bounds.width - 20, y: (view.bounds.height - height) * 0.5, width: 20, height: height)
        let v = SectionIndexView.init(frame: frame)
        v.isItemIndicatorAlwaysInCenter = true
        v.itemIndicatorHorizontalOffset = -130
        v.delegate = self
        v.dataSource = self
        return v
    }()
    private var isOperated = false
       
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        title = "Custom"
        self.loadData()
        view.addSubview(tableView)
        view.addSubview(indexView)
    }
    
    private func loadData() {
        guard let path = Bundle.main.path(forResource: "data.json", ofType: nil),
            let url = URL.init(string: "file://" + path),
            let data = try? Data.init(contentsOf: url),
            let arr = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Array<Dictionary<String, String>>) else {
                return
        }
        self.dataSource = arr.compactMap({Person.init(dic: $0)}).reduce(into: [String: [Person]]()) {
            $0[$1.firstCharacter] = ($0[$1.firstCharacter] ?? []) + [$1]
        }.sorted { $0.key < $1.key }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension CusViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.dataSource[section].key
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource[section].value.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath)
        cell.textLabel?.text = self.dataSource[indexPath.section].value[indexPath.row].fullName
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !self.indexView.isTouching else { return }
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
        return tableView.contentOffset.y + self.tableViewVisibleOffset < rect.origin.y + rect.size.height
    }
}


extension CusViewController: SectionIndexViewDataSource, SectionIndexViewDelegate {

    func numberOfItems(in sectionIndexView: SectionIndexView) -> Int {
        return self.dataSource.count
    }
    
    func sectionIndexView(_ sectionIndexView: SectionIndexView, itemAt section: Int) -> SectionIndexViewItem {
        let item = SectionIndexViewItemView.init()
        let title = self.dataSource[section].key
        item.title = title
        item.titleSelectedColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        item.selectedColor = #colorLiteral(red: 0, green: 0.5291740298, blue: 1, alpha: 1)
        
        let indicator = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        indicator.text = title
        indicator.font = UIFont.boldSystemFont(ofSize: 35)
        indicator.adjustsFontSizeToFitWidth = true
        indicator.textAlignment = .center
        indicator.backgroundColor = .clear
        indicator.textColor = #colorLiteral(red: 0, green: 0.5291740298, blue: 1, alpha: 1)
        indicator.layer.cornerRadius = 25
        indicator.layer.borderWidth = 5
        indicator.layer.borderColor = #colorLiteral(red: 0, green: 0.5291740298, blue: 1, alpha: 1)
        
        item.indicator = indicator
        return item
    }

    func sectionIndexView(_ sectionIndexView: SectionIndexView, didSelect section: Int) {
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
    
    func sectionIndexViewToucheEnded(_ sectionIndexView: SectionIndexView) {
        UIView.animate(withDuration: 0.3) {
            sectionIndexView.hideCurrentItemIndicator()
        }
        self.tableView.panGestureRecognizer.isEnabled = true
    }
}
