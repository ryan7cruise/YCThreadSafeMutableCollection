//
//  YCViewController.m
//  YCMutableThreadSafeCollection
//
//  Created by Yuchen Peng on 08/22/2020.
//  Copyright (c) 2020 Yuchen Peng. All rights reserved.
//

#import "YCViewController.h"
#import "YCThreadSafeMutableArray.h"
#import "YCThreadSafeMutableDictionary.h"
#import "YCThreadSafeMutableSet.h"

typedef NS_ENUM(NSUInteger, YCDemoType) {
    YCDemoTypeCrash,
    YCDemoTypeSafe,
};

@interface YCViewController ()

@end

@implementation YCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self arrayDemoWithType:YCDemoTypeCrash];
//    [self setDemoWithType:YCDemoTypeCrash];
//    [self dictionaryDemoWithType:YCDemoTypeCrash];
//    [self badCase];
//    [self archiveLimitation];
}

- (void)arrayDemoWithType:(YCDemoType)type
{
    NSMutableArray *array;
    if (type == YCDemoTypeCrash) {
        array = [[NSMutableArray alloc] init];
    } else {
        array = [[YCThreadSafeMutableArray alloc] init];
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 1000; ++i) {
        NSString *key = [NSString stringWithFormat:@"key%d", i];
        dispatch_async(queue, ^{
            [array addObject:key];
        });
        
        dispatch_async(queue, ^{
            [array removeObject:key];
        });
    }
    NSLog(@"finished");
}

- (void)setDemoWithType:(YCDemoType)type
{
    NSMutableSet *set;
    if (type == YCDemoTypeCrash) {
        set = [[NSMutableSet alloc] init];
    } else {
        set = [[YCThreadSafeMutableSet alloc] init];
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 1000; ++i) {
        NSString *key = [NSString stringWithFormat:@"key%d", i];
        dispatch_async(queue, ^{
            [set addObject:key];
        });
        
        dispatch_async(queue, ^{
            [set removeObject:key];
        });
    }
    NSLog(@"finished");
}

- (void)dictionaryDemoWithType:(YCDemoType)type
{
    NSMutableDictionary *dictionary;
    if (type == YCDemoTypeCrash) {
        dictionary = [[NSMutableDictionary alloc] init];
    } else {
        dictionary = [[YCThreadSafeMutableDictionary alloc] init];
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 1000; ++i) {
        NSString *key = [NSString stringWithFormat:@"key%d", i];
        dispatch_async(queue, ^{
            [dictionary setObject:@(i) forKey:key];
        });
        
        dispatch_async(queue, ^{
            [dictionary removeObjectForKey:key];
        });
    }
    NSLog(@"finished");
}

- (void)badCase
{
    YCThreadSafeMutableArray *array = [[YCThreadSafeMutableArray alloc] init];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for (int i = 0; i < 1000; ++i) {
            [array addObject:@(i)];
        }
    });
    // crash
    dispatch_async(queue, ^{
        for (NSNumber *number in array) {
            NSLog(@"%@", number);
        }
        NSLog(@"finished");
    });
    // safe
//    dispatch_async(queue, ^{
//        [array enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSLog(@"%@", obj);
//        }];
//        NSLog(@"finished");
//    });
    // safe
//    dispatch_async(queue, ^{
//        for (int i = 0; i < 1000; ++i) {
//            NSLog(@"%@", [array objectAtIndex:i]);
//        }
//        NSLog(@"finished");
//    });
}

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

@end
