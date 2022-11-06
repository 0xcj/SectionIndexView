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
#### Swift Package Manager
 - File > Swift Packages > Add Package Dependency
 `https://github.com/0xcj/SectionIndexView.git`
- Select "Up to Next Major" with "3.0.0"

### Manual
Drop the swift files inside of [SectionIndexViewDemo/SectionIndexView](https://github.com/0xcj/SectionIndexView/tree/master/SectionIndexViewDemo/SectionIndexView) into your project.

## Usage

Swift
```swift
override func viewDidLoad() {
    ......
    let titles = ["A","B","C","D","E","F","G"]
    let items = titles.compactMap { (title) -> SectionIndexViewItem? in
            let item = SectionIndexViewItemView.init()
            item.title = title
            item.indicator = SectionIndexViewItemIndicator.init(title: title)
            return item
        }
    self.tableView.sectionIndexView(items: items)
}

```
Objective-C
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    ......
    NSMutableArray<UIView<SectionIndexViewItem>*> *items = [[NSMutableArray alloc]init];
    NSArray *titles = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G"];
    for (NSString *title in titles) {
        SectionIndexViewItemView *item = [[SectionIndexViewItemView alloc] init];
        item.title = title
        item.indicator = [[SectionIndexViewItemIndicator alloc]initWithTitle:title];
        [items addObject:item];
    }
    [self.tableView sectionIndexViewWithItems:[NSArray arrayWithArray:items]];
}
```
## Attention
In order to assure `SectionIndexView` has correct scrolling when your navigationBar not hidden and  UITableView  use ` contentInsetAdjustmentBehavior`  or ` automaticallyAdjustsScrollViewInsets`  to adjust content. Set [adjustedContentInset](https://github.com/0xcj/SectionIndexView/blob/master/SectionIndexViewDemo/SectionIndexView/UITableView%2BSectionIndexView.swift) value equal to UITableView’s adjustment content inset
```swift
override func viewDidLoad() {
    ......
    let navigationBarHeight = self.navigationController.navigationBar.frame.height
    let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    let frame = CGRect.init(x: 0, y: 0, width: width, height: height)
    let tableView = UITableView.init(frame: frame, style: .plain)
    let configuration = SectionIndexViewConfiguration.init()
    configuration.adjustedContentInset = statusBarHeight + navigationBarHeight
    tableView.sectionIndexView(items: items, configuration: configuration)
}
```

If you want to control the UITableView and SectionIndexView manually，you can use it like this. [There is an example.](https://github.com/0xcj/SectionIndexView/blob/master/SectionIndexViewDemo/SectionIndexViewDemo/CusViewController.swift)
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

## License

All source code is licensed under the [License](https://github.com/0xcj/SectionIndexView/blob/master/LICENSE)

