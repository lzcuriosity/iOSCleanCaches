# iOSCleanCaches
iOS APP clean caches code.为你自己的应用清除缓存。

## 说明

由于我们删除 caches 我文件夹底下的文件之后，可能系统会自动生成一些文件，导致缓存计算不为0；我们可以将小于 0.1M 的缓存视为 0M；防止“有强迫症”用户重复点击。

## 使用

```objc
//引入头文件
#import "LZCleanCaches.h"

//单例模式的调用LZCleanCaches
+ (LZCleanCaches *) sharedInstance;

//计算缓存
- (void)getCacheSize:(void (^)(NSString *size))completion;
//删除缓存
- (void)cleanCache:(void(^)(void))completion;

```
详情见Demo。

## 相关文章

见我的博客：[《为你的APP添加缓存清理功能吧！》](http://lzcuriosity.github.io/2016/07/26/为你的APP添加缓存清理功能吧！/)