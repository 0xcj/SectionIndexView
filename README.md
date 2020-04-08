<p style="align: center">
       <img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=plastic">
    </a>
      <img src="https://img.shields.io/badge/support-ios9%2B-orange.svg">
    </a>
       <img src="https://img.shields.io/badge/language-swift-blue.svg">
    </a>
       <img src="https://img.shields.io/badge/cocoapods-supported-4BC51D.svg?style=plastic">
    </a>
    <a href="https://github.com/0xcj/SectionIndexView/blob/master/LICENSE">
    <img src="https://img.shields.io/cocoapods/l/Kingfisher.svg?style=flat">
    </a>
</p>

## SectionIndexView
SectionIndexView which could be highly customized, can easily be used to customize the UITableView's section index .

## Overview

| default | custom | image | 
| ------ | ------ | ------ | 
![Demo Overview](https://github.com/0xcj/SectionIndexView/blob/master/images/default.png) | ![Demo Overview](https://github.com/0xcj/SectionIndexView/blob/master/images/custom.png) | ![Demo Overview](https://github.com/0xcj/SectionIndexView/blob/master/images/image.png)

## Installation
### CocoaPods
```
pod 'SectionIndexView'
```
### Manual
Drop the swift files inside of [SectionIndexViewDemo/SectionIndexView](https://github.com/0xcj/SectionIndexView/tree/master/SectionIndexViewDemo/SectionIndexView) into your project.

## Usage
SectionIndexView is easy to use.

```swift
override func viewDidLoad() {
    ......
    let titles = ["A","B","C","D","E","F","G"]
    let items = titles.compactMap { (title) -> SectionIndexViewItem? in
            let item = SectionIndexViewItemView.init()
            item.title = title
            return item
        }
    self.tableView.sectionIndexView(items: items)
}

```
If you need more permissions，you can use it like this.
```swift
override func viewDidLoad() {
    ......
    let indexView = SectionIndexView.init(frame: frame)
    indexView.delegate = self
    indexView.dataSource = self
    self.view.addSubview(indexView)
}
```
Please see the demo for more details.

## Attention
If your tableView use ```automaticallyAdjustsScrollViewInsets``` or ```contentInsetAdjustmentBehavior```, you need set up <font color=#ff0000>tableViewVisibleOffset</font>, see the following code.
```swift
override func viewDidLoad() {
    ......
    let navHeight = self.navigationController.navigationBar.frame.height
    let statusHeight = UIApplication.shared.statusBarFrame.size.height
    let frame = CGRect.init(x: 0, y: 0, width: width, height: height)
    let tableView = UITableView.init(frame: frame, style: .plain)
    let configuration = SectionIndexViewConfiguration.init()
    configuration.tableViewVisibleOffset = navHeight + statusHeight
    tableView.sectionIndexView(items: items, configuration: configuration)
}
```
Or
```swift
override func viewDidLoad() {
    ......
    let navHeight = self.navigationController.navigationBar.frame.height
    let statusHeight = UIApplication.shared.statusBarFrame.size.height
    let y = navHeight + statusHeight
    let frame = CGRect.init(x: 0, y: y, width: width, height: height)
    let tableView = UITableView.init(frame: frame, style: .plain)
    let configuration = SectionIndexViewConfiguration.init()
    configuration.tableViewVisibleOffset = 0
    tableView.sectionIndexView(items: items, configuration: configuration)
}
```

## License

All source code is licensed under the [License](https://github.com/0xcj/SectionIndexView/blob/master/LICENSE)

