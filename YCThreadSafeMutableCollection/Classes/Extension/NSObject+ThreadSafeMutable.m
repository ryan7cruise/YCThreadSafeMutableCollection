//
//  NSObject+ThreadSafeMutable.m
//  YCThreadSafeMutable
//
//  Created by pengyuchen on 2020/8/19.
//

#import "NSObject+ThreadSafeMutable.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject(ThreadSafeMutable)

CG_INLINE IMP tsm_getMsgForwardIMP(Class cls, SEL selector) {
    IMP msgForwardIMP = _objc_msgForward;
#if !defined(__arm64__)
    Method method = class_getInstanceMethod(cls, selector);
    const char *typeDescription = method_getTypeEncoding(method);
    if (typeDescription[0] == '{') {
        // 以下代码参考 JSPatch 的实现：
        //In some cases that returns struct, we should use the '_stret' API:
        //http://sealiesoftware.com/blog/archive/2008/10/30/objc_explain_objc_msgSend_stret.html
        //NSMethodSignature knows the detail but has no API to return, we can only get the info from debugDescription.
        NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:typeDescription];
        if ([methodSignature.debugDescription rangeOfString:@"is special struct return? YES"].location != NSNotFound) {
            msgForwardIMP = (IMP)_objc_msgForward_stret;
        }
    }
#endif
    return msgForwardIMP;
}

+ (void)tsm_enumrateInstanceMethodsOfClass:(Class)aClass usingBlock:(void (^)(Method, SEL))block {
    if (!block) return;
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(aClass, &methodCount);
    for (unsigned int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        SEL selector = method_getName(method);
        if (block) block(method, selector);
    }
    free(methods);
}

+ (void)tsm_enumrateInstanceMethodsOfClasses:(NSArray<Class> *)classes addToClass:(Class)toClass {
    if (toClass) {
        [classes enumerateObjectsUsingBlock:^(Class  _Nonnull hookClass, NSUInteger idx, BOOL * _Nonnull stop) {
            [self tsm_enumrateInstanceMethodsOfClass:hookClass usingBlock:^(Method  _Nonnull method, SEL  _Nonnull selector) {
                // 如果已经实现了该方法，则不需要消息转发
                if (class_getInstanceMethod(toClass, selector) != method) return;
                const char * typeDescription = (char *)method_getTypeEncoding(method);
                if (typeDescription) {
                    class_addMethod(toClass, selector, tsm_getMsgForwardIMP(hookClass, selector), typeDescription);
                }
            }];
        }];
    }
}

@end
