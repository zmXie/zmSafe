//
//  NSObject+Swizzle.m
//  SwizzleProject
//
//  Created by CHT-Technology on 2017/4/25.
//  Copyright © 2017年 CHT-Technology. All rights reserved.
//

#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzle)

/**
 交换两个对象方法的实现
 
 @param srcClass 被替换方法的类
 @param srcSel 被替换的方法编号
 @param swizzledSel 用于替换的方法编号
 */
- (void)zm_swizzleInstanceMethodWithSrcClass:(Class)srcClass
                                      srcSel:(SEL)srcSel
                                 swizzledSel:(SEL)swizzledSel{
    
    if (!srcClass || !srcSel || !swizzledSel) return;
    
    Method srcMethod = class_getInstanceMethod(srcClass, srcSel);
    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSel);
    method_exchangeImplementations(srcMethod, swizzledMethod);
}


/**
 交换两个类方法的实现
 
 @param srcClass 被替换方法的类
 @param srcSel 被替换的方法编号
 @param swizzledSel 用于替换的方法编号
 */
- (void)zm_swizzleClassMethodWithSrcClass:(Class)srcClass
                                   srcSel:(SEL)srcSel
                              swizzledSel:(SEL)swizzledSel{
    
    if (!srcClass || !srcSel || !swizzledSel) return;
    
    Method srcMethod = class_getClassMethod(srcClass, srcSel);
    Method swizzledMethod = class_getClassMethod([self class], swizzledSel);
    method_exchangeImplementations(srcMethod, swizzledMethod);
}
@end
