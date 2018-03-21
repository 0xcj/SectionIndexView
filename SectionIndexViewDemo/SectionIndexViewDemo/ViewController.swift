//
//  ViewController.swift
//  SectionIndexViewDemo
//
//  Created by 陈健 on 2018/3/13.
//  Copyright © 2018年 ChenJian. All rights reserved.
//

import UIKit

enum Type: String {
    case `default` = "default"
    case rect = "rect"
    case circle = "circle"
    case drip = "drip"
    case empty = "empty"
}
class ViewController: UIViewController {
    
    let data = [Type.default,
                Type.rect,
                Type.circle,
                Type.drip,
                Type.empty]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SectionIndexView"
        
        let tableView = UITableView.init(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = data[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath),
            let text = cell.textLabel?.text,
            let type = Type.init(rawValue: text) {
            switch type {
            case Type.default:
                navigationController?.pushViewController(DefaultViewController(), animated: true)
                break
            case Type.rect:
                navigationController?.pushViewController(RectViewController(), animated: true)
                break
            case Type.circle:
                navigationController?.pushViewController(CircleViewController(), animated: true)
                break
            case Type.drip:
                navigationController?.pushViewController(DripViewController(), animated: true)
                break
            case Type.empty:
                navigationController?.pushViewController(EmptyViewController(), animated: true)
                break
            }
        }
        
    }
}
