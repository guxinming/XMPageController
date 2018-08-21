# XMPageController
这是一个页面管理器，类似于爱奇艺，腾讯视频等app的页面控制器
## 为什么要写这个库
其实之前已经有一些非常优秀的库，像 [TYPageController](https://github.com/12207480/TYPagerController), [WMPageController](https://github.com/wangmchn/WMPageController),TYPageController感觉的定制性更好，但是库中存在一点交互问题，WMPageController实现的非常强大，但是使用的时候需要继承库中的controller，感觉不是特别理想，于是就想根据自己的想法来实现一套。
## 功能
 库中主体是两个部分XMPageBar，XMPageViewController
 
 XMPageBar是一个UICollectionView和progressView的结合。XMPageViewController就是一个页面控制器，主体是UIScrollview。两者分离，通过提供的方法进行交互关联。

![1.默认bar样式](https://ws3.sinaimg.cn/large/006tNbRwly1fuhbuv4arfg30bi0esnpd.gif)
