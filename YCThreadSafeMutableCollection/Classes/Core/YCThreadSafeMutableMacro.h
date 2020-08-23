//
//  YCThreadSafeMutableMacro.h
//  YCThreadSafeMutable
//
//  Created by pengyuchen on 2020/8/19.
//

#ifndef YCThreadSafeMutableMacro_h
#define YCThreadSafeMutableMacro_h

#ifndef YC_SEMAPHORE_LOCK
#define YC_SEMAPHORE_LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER)
#endif

#ifndef YC_SEMAPHORE_UNLOCK
#define YC_SEMAPHORE_UNLOCK(lock) dispatch_semaphore_signal(lock)
#endif

#define YC_SEMAPHORE_LOCKPAIR(lock, ...) YC_SEMAPHORE_LOCK(lock); \
__VA_ARGS__; \
YC_SEMAPHORE_UNLOCK(lock)

#endif /* YCThreadSafeMutableMacro_h */
