[中文介绍](https://www.jianshu.com/p/18db920693cf)

# SectionIndexView
SectionIndexView which could be highly customized, can easily be used to customize the UITableView's section index .

# Overview

![Demo Overview](https://github.com/1-ChenJian/SectionIndexView/blob/master/ScreenShorts/default.gif)
![Demo Overview](https://github.com/1-ChenJian/SectionIndexView/blob/master/ScreenShorts/circle.gif)
![Demo Overview](https://github.com/1-ChenJian/SectionIndexView/blob/master/ScreenShorts/drip.gif)
![Demo Overview](https://github.com/1-ChenJian/SectionIndexView/blob/master/ScreenShorts/rect.gif)
![Demo Overview](https://github.com/1-ChenJian/SectionIndexView/blob/master/ScreenShorts/empty.gif)

# Installation
```
pod 'SectionIndexView'
```


# Usage
SectionIndexView is easy to use, API are like UITableView.

Init  `SectionIndexView `.

```
override func viewDidLoad() {
    ......
    indexView = SectionIndexView.init(frame:frame)
    indexView.dataSource = self
    indexView.delegate = self
    view.addSubview(indexView)
}

```
Conforming to protocol `SectionIndexViewDataSource`.

```
func numberOfItemViews(in sectionIndexView: SectionIndexView) -> Int {
    return indexData.count
}

func sectionIndexView(_ sectionIndexView: SectionIndexView, itemViewAt section: Int) -> SectionIndexViewItem {
    let itemView = SectionIndexViewItem.init()
    itemView.title = indexData[section]
    return itemView
}
// when you need SectionIndexViewItemPreview
func sectionIndexView(_ sectionIndexView: SectionIndexView, itemPreviewFor section: Int) -> SectionIndexViewItemPreview {
    let preview = SectionIndexViewItemPreview.init(title: indexData[section], type: .default)
    return preview
}
```

Conforming to protocol `SectionIndexViewDelegate`.
All of them are optional.
```
//didSelect
func sectionIndexView(_ sectionIndexView: SectionIndexView, didSelect section: Int)

//toucheMoved
func sectionIndexView(_ sectionIndexView: SectionIndexView, toucheMoved section: Int)

//toucheCancelled
func sectionIndexView(_ sectionIndexView: SectionIndexView, toucheCancelled section: Int)

```
Please see the demo for more details.


## License

SectionIndexView is released under an MIT license.

