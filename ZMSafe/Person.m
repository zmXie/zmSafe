//
//  Person.m
//  ZMSafe
//
//  Created by xzm on 2018/7/19.
//  Copyright © 2018年 CHT-Technology. All rights reserved.
//

#import "Person.h"
#import "NSObject+Swizzle.h"

@implementation Person

- (void)sayHello
{
    NSLog(@"person sayHello");
}

@end

@implementation Student

@end





@implementation Student (swizzle)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self zm_swizzleInstanceMethodWithSrcClass:[self class] srcSel:@selector(sayHello) swizzledSel:@selector(s_sayHello)];
    });
}

- (void)s_sayHello
{
    [self s_sayHello];
    NSLog(@"Student + swizzle sayHello");
}

@end

@implementation Person (swizzle)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self zm_swizzleInstanceMethodWithSrcClass:[self class] srcSel:@selector(sayHello) swizzledSel:@selector(p_sayHello)];
    });
}

- (void)p_sayHello
{
    [self p_sayHello];
    NSLog(@"Person + swizzle sayHello");
}

@end
