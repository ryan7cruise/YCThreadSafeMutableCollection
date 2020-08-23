//
//  YCThreadSafeMutableSet.m
//  YCThreadSafeMutable
//
//  Created by pengyuchen on 2020/8/20.
//

#import "YCThreadSafeMutableSet.h"
#import "NSObject+ThreadSafeMutable.h"
#import "YCThreadSafeMutableMacro.h"
#import "NSMethodSignature+ThreadSafeMutable.h"

@interface YCThreadSafeMutableSet ()

@property (nonatomic, strong) dispatch_semaphore_t lock;
@property (nonatomic, strong) NSMutableSet *mutableSet;

@end

@implementation YCThreadSafeMutableSet

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject tsm_enumrateInstanceMethodsOfClasses:@[NSMutableSet.class, NSSet.class] addToClass:YCThreadSafeMutableSet.class];
    });
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *result = [super methodSignatureForSelector:aSelector];
    if (result) {
        return result;
    }
    result = [self.mutableSet methodSignatureForSelector:aSelector];
    if (result && [self.mutableSet respondsToSelector:aSelector]) {
        return result;
    }
    return [NSMethodSignature threadSafeMutableAvoidExceptionSignature];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL selector = invocation.selector;
    if ([self.mutableSet respondsToSelector:selector]) {
         YC_SEMAPHORE_LOCKPAIR(self.lock, [invocation invokeWithTarget:self.mutableSet]);
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
        self.mutableSet = [[NSMutableSet alloc] init];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems
{
    self = [super init];
    if (self) {
        self.lock = dispatch_semaphore_create(1);
        self.mutableSet = [[NSMutableSet alloc] initWithCapacity:numItems];
    }
    return self;
}

- (instancetype)initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt
{
    self = [super init];
    if (self) {
        self.lock = dispatch_semaphore_create(1);
        self.mutableSet = [[NSMutableSet alloc] initWithObjects:objects count:cnt];
    }
    return self;
}

- (void)addObject:(id)object
{
    if (object) {
        YC_SEMAPHORE_LOCKPAIR(self.lock, [self.mutableSet addObject:object]);
    }
}

- (void)removeObject:(id)object
{
    if (object) {
        YC_SEMAPHORE_LOCKPAIR(self.lock, [self.mutableSet removeObject:object]);
    }
}

@end
