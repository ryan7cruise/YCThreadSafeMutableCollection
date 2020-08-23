//
//  NSMethodSignature+ThreadSafeMutable.h
//  YCThreadSafeMutable
//
//  Created by pengyuchen on 2020/8/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMethodSignature (ThreadSafeMutable)

+ (NSMethodSignature *)threadSafeMutableAvoidExceptionSignature;

@end

NS_ASSUME_NONNULL_END
