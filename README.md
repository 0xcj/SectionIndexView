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

## Overview

| default | custom | image | 
| ------ | ------ | ------ | 
![default](https://upload-images.jianshu.io/upload_images/11200375-f16dec23eafc0e3f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240) | ![custom](https://upload-images.jianshu.io/upload_images/11200375-1129a588359d0dca.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240) | ![image](https://upload-images.jianshu.io/upload_images/11200375-79228d354feac9d3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

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
If your tableView use ```automaticallyAdjustsScrollViewInsets``` or ```contentInsetAdjustmentBehavior```, you need set up [tableViewVisibleOffset](https://github.com/0xcj/SectionIndexView/blob/master/SectionIndexViewDemo/SectionIndexView/UITableView%2BSectionIndexView.swift), see the following code.
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

