# YCThreadSafeMutableCollection

[![CocoaPods](https://img.shields.io/badge/pod-0.1.0-green.svg)](https://github.com/ryan7cruise/YCThreadSafeMutableCollection)
[![Platform](https://img.shields.io/badge/platform-iOS-green.svg)](https://github.com/ryan7cruise/YCThreadSafeMutableCollection)
[![Support](https://img.shields.io/badge/support-iOS%208.0%2B-green.svg)](https://github.com/ryan7cruise/YCThreadSafeMutableCollection)
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/ryan7cruise/YCThreadSafeMutableCollection/blob/master/LICENSE)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

The example project shows several thread issues and solutions using **YCThreadSafeMutableCollection**.

It's thread-safe for NSMutableArray, NSMutableDictionary and NSMutableSet APIs, but not for **for in**.

```objective-c
for (NSNumber *number in array) {
    NSLog(@"%@", number);
}
```

**Attention:** If you archive and unarchive the mutable collection, you won't get the thread-safe version.

```objective-c
- (void)archiveLimitation
{
    YCThreadSafeMutableArray *array = [[YCThreadSafeMutableArray alloc] init];
    [array addObject:@0];
    [array addObject:@1];
    [array addObject:@2];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    YCThreadSafeMutableArray *unarchiveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"%@", NSStringFromClass(unarchiveArray.class));
    NSLog(@"%@", unarchiveArray);
}
// NSLog
__NSArrayM
(
    0,
    1,
    2
)
```

## Installation

YCThreadSafeMutableCollection is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'YCThreadSafeMutableCollection'
```

## Author

Yuchen Peng, yuchenpeng826@hotmail.com

## License

YCThreadSafeMutableCollection is available under the MIT license. See the LICENSE file for more info.



## 示例

要运行示例工程，请先克隆，再在Example文件夹下执行`pod install`。

实例工程展示了几个线程问题，使用 **YCThreadSafeMutableCollection** 的是可以解决这些问题的。

对于 NSMutableArray、NSMutableDictionary 和 NSMutableSet 的API都是线程安全的，但 **for in** 是不安全的。

```objective-c
for (NSNumber *number in array) {
    NSLog(@"%@", number);
}
```

**注意：** 如果对可变集合进行了归档和解归档，你将无法得到一个线程安全的版本。

```objective-c
- (void)archiveLimitation
{
    YCThreadSafeMutableArray *array = [[YCThreadSafeMutableArray alloc] init];
    [array addObject:@0];
    [array addObject:@1];
    [array addObject:@2];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    YCThreadSafeMutableArray *unarchiveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"%@", NSStringFromClass(unarchiveArray.class));
    NSLog(@"%@", unarchiveArray);
}
// NSLog
__NSArrayM
(
    0,
    1,
    2
)
```