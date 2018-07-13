//
//  NSObject+ZMSafe.m
//  ChengHuiTong
//
//  Created by CHT-Technology on 2017/5/15.
//  Copyright © 2017年 CHT-Technology. All rights reserved.
//

#import "NSObject+ZMSafe.h"
#import <objc/runtime.h>
#import "NSObject+Swizzle.h"

@implementation NSObject (ZMSafe)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self zm_swizzleInstanceMethodWithSrcClass:[self class]
                                            srcSel:@selector(forwardInvocation:)
                                       swizzledSel:@selector(zm_forwardInvocation:)];
        
        [self zm_swizzleInstanceMethodWithSrcClass:[self class]
                                            srcSel:@selector(methodSignatureForSelector:)
                                       swizzledSel:@selector(zm_methodSignatureForSelector:)];
        
    });
}


- (void)empty
{
    NSLog(@"empty");
}

/**
 消息转发方法
 
 @param anInvocation 消息调用对象
 */
- (void)zm_forwardInvocation:(NSInvocation *)anInvocation
{
    NSLog(@"unrecognized selector -[%@ %@]\n%s",anInvocation.target,NSStringFromSelector([anInvocation selector]),__FUNCTION__);
    
    //如果自定义实现方法empty中什么都没做，只是为了能在运行时找到该实现方法，不至于crash，那么这里可以不进行消息发送，可以注释掉
    if (![self respondsToSelector:anInvocation.selector])
    {
        // 拿到方法对象，method其实就相当于在SEL跟IMP之间作了一个映射，有了SEL，我们便可以找到对应的IMP
        NSLog(@"%@--%@",self,[self class]);
        Method method = class_getClassMethod([self class], @selector(empty));
        // 获取函数类型，有没有返回参数，传入参数
        const char *type = method_getTypeEncoding(method);
        // 添加方法
        class_addMethod([self class], anInvocation.selector, method_getImplementation(method), type);
        // 转发给自己，没毛病
        [anInvocation invokeWithTarget:self];
    }
}

/**
 构造一个方法签名，提供给- (void)forwardInvocation:(NSInvocation *)anInvocation方法，如果aSelector没有对应的IMP，则会生成一个空的方法签名，最终导致程序报错崩溃,所以必须重写。
 
 @param aSelector 方法编号
 @return 方法签名
 */
- (NSMethodSignature *)zm_methodSignatureForSelector:(SEL)aSelector
{
    if ([self respondsToSelector:aSelector])
    {
        // 如果能够响应则返回原始方法签名
        return [self zm_methodSignatureForSelector:aSelector];
    }else
    {
        // 构造自定义方法的签名
        return [[self class] instanceMethodSignatureForSelector: @selector(empty)];
    }
}

/**
 重写KVC赋值操作中未识别的key，避免crash
 */
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"[%@ setValue:forUndefinedKey:%@]",NSStringFromClass(self.class),key);
}

/**
 重写KVC获取操作中未识别的key，避免crash
 */
- (nullable id)valueForUndefinedKey:(NSString *)key
{
    NSLog(@"[%@ valueForUndefinedKey:%@]",NSStringFromClass(self.class),key);
    return [NSNull null];
}

@end
