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

import UIKit

class ViewController: UIViewController {
    
    private let identifier = "cell"
    private var dataSource = [(key: String, value: [Person])]()
    private lazy var tableView: UITableView = {
        let v = UITableView.init(frame: view.frame, style: .plain)
        v.showsVerticalScrollIndicator = false
        v.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        v.delegate = self
        v.dataSource = self
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SectionIndexView"
        self.loadData()
        view.addSubview(tableView)
       
        let items = self.items()
        let configuration = SectionIndexViewConfiguration.init()
        configuration.adjustedContentInset = UIApplication.shared.statusBarFrame.size.height + 44
        tableView.sectionIndexView(items: items, configuration: configuration)
        
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
    
    private func items() -> [SectionIndexViewItemView] {
        var items = [SectionIndexViewItemView]()
        for (i, key) in self.dataSource.compactMap({ $0.key }).enumerated() {
            let item = SectionIndexViewItemView.init()
            if i == 0 {
                item.image = UIImage.init(named: "recent")
                item.selectedImage = UIImage.init(named: "recent_sel")
                let indicator = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
                indicator.image = UIImage.init(named: "recent_ind")
                item.indicator = indicator
            } else {
                item.title = key
                item.indicator = SectionIndexViewItemIndicator.init(title: key)
            }
            items.append(item)
        }
        return items
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(CusViewController.init(), animated: true)
    }
}


