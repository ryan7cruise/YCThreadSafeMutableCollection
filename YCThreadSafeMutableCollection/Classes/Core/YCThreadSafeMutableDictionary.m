//
//  YCThreadSafeMutableDictionary.m
//  YCThreadSafeMutable
//
//  Created by pengyuchen on 2020/8/19.
//

#import "YCThreadSafeMutableDictionary.h"
#import "NSObject+ThreadSafeMutable.h"
#import "YCThreadSafeMutableMacro.h"
#import "NSMethodSignature+ThreadSafeMutable.h"

@interface YCThreadSafeMutableDictionary ()

@property (nonatomic, strong) dispatch_semaphore_t lock;
@property (nonatomic, strong) NSMutableDictionary *mutableDictionary;

@end

@implementation YCThreadSafeMutableDictionary

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject tsm_enumrateInstanceMethodsOfClasses:@[NSMutableDictionary.class, NSDictionary.class] addToClass:YCThreadSafeMutableDictionary.class];
    });
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *result = [super methodSignatureForSelector:aSelector];
    if (result) {
        return result;
    }
    result = [self.mutableDictionary methodSignatureForSelector:aSelector];
    if (result && [self.mutableDictionary respondsToSelector:aSelector]) {
        return result;
    }
    return [NSMethodSignature threadSafeMutableAvoidExceptionSignature];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL selector = invocation.selector;
    if ([self.mutableDictionary respondsToSelector:selector]) {
         YC_SEMAPHORE_LOCKPAIR(self.lock, [invocation invokeWithTarget:self.mutableDictionary]);
    }
}

#pragma mark - must override

- (void)dealloc
{
//    NSLog(@"%s", __func__);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lock = dispatch_semaphore_create(1);
        self.mutableDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems
{
    self = [super init];
    if (self) {
        self.lock = dispatch_semaphore_create(1);
        self.mutableDictionary = [[NSMutableDictionary alloc] initWithCapacity:numItems];
    }
    return self;
}

- (instancetype)initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt
{
    self = [super init];
    if (self) {
        self.lock = dispatch_semaphore_create(1);
        self.mutableDictionary = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys count:cnt];
    }
    return self;
}

- (id)objectForKey:(id)aKey
{
    if (aKey) {
        YC_SEMAPHORE_LOCKPAIR(self.lock, id object = [self.mutableDictionary objectForKey:aKey]);
        return object;
    }
    return nil;
}

- (void)removeObjectForKey:(id)aKey
{
    if (aKey) {
        YC_SEMAPHORE_LOCKPAIR(self.lock, [self.mutableDictionary removeObjectForKey:aKey]);
    }
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject && aKey) {
        YC_SEMAPHORE_LOCKPAIR(self.lock, [self.mutableDictionary setObject:anObject forKey:aKey]);
    }
}

@end
