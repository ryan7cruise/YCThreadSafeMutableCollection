//
//  NSObject+ThreadSafeMutable.h
//  YCThreadSafeMutable
//
//  Created by pengyuchen on 2020/8/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ThreadSafeMutable)

+ (void)tsm_enumrateInstanceMethodsOfClasses:(NSArray<Class> *)classes addToClass:(Class)toClass;

@end

NS_ASSUME_NONNULL_END
