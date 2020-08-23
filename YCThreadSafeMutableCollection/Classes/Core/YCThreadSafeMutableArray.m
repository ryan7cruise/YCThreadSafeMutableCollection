//
//  YCThreadSafeMutableArray.h
//  YCThreadSafeMutable
//
//  Created by pengyuchen on 2020/8/19.
//

#import "YCThreadSafeMutableArray.h"
#import "NSObject+ThreadSafeMutable.h"
#import "YCThreadSafeMutableMacro.h"
#import "NSMethodSignature+ThreadSafeMutable.h"

@interface YCThreadSafeMutableArray ()

@property (nonatomic, strong) dispatch_semaphore_t lock;
@property (nonatomic, strong) NSMutableArray *mutableArray;

@end

@implementation YCThreadSafeMutableArray

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject tsm_enumrateInstanceMethodsOfClasses:@[NSMutableArray.class, NSArray.class] addToClass:YCThreadSafeMutableArray.class];
    });
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *result = [super methodSignatureForSelector:aSelector];
    if (result) {
        return result;
    }
    result = [self.mutableArray methodSignatureForSelector:aSelector];
    if (result && [self.mutableArray respondsToSelector:aSelector]) {
        return result;
    }
    return [NSMethodSignature threadSafeMutableAvoidExceptionSignature];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL selector = invocation.selector;
    if ([self.mutableArray respondsToSelector:selector]) {
         YC_SEMAPHORE_LOCKPAIR(self.lock, [invocation invokeWithTarget:self.mutableArray]);
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
        self.mutableArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems
{
    self = [super init];
    if (self) {
        self.lock = dispatch_semaphore_create(1);
        self.mutableArray = [[NSMutableArray alloc] initWithCapacity:numItems];
    }
    return self;
}

- (instancetype)initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt
{
    self = [super init];
    if (self) {
        self.lock = dispatch_semaphore_create(1);
        self.mutableArray = [[NSMutableArray alloc] initWithObjects:objects count:cnt];
    }
    return self;
}

- (id)objectAtIndex:(NSUInteger)index
{
    if (index >= 0 && index < self.count) {
        YC_SEMAPHORE_LOCKPAIR(self.lock, id object = [self.mutableArray objectAtIndex:index]);
        return object;
    }
    return nil;
}

- (void)addObject:(id)anObject
{
    if (anObject) {
        YC_SEMAPHORE_LOCKPAIR(self.lock, [self.mutableArray addObject:anObject]);
    }
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject && index >= 0) {
        if (index < self.count) {
            YC_SEMAPHORE_LOCKPAIR(self.lock, [self.mutableArray insertObject:anObject atIndex:index]);
        } else {
            YC_SEMAPHORE_LOCKPAIR(self.lock, [self.mutableArray addObject:anObject]);
        }
    }
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    if (index >= 0 && index < self.count) {
        YC_SEMAPHORE_LOCKPAIR(self.lock, [self.mutableArray removeObjectAtIndex:index]);
    }
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (anObject && index >= 0 && index < self.count) {
        YC_SEMAPHORE_LOCKPAIR(self.lock, [self.mutableArray replaceObjectAtIndex:index withObject:anObject]);
    }
}

@end
