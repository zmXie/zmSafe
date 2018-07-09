//
//  NSTimer+ZMSafe.m
//  ZMSafe
//
//  Created by xzm on 2018/7/5.
//  Copyright © 2018年 CHT-Technology. All rights reserved.
//

#import "NSTimer+ZMSafe.h"
#import "NSObject+Swizzle.h"

@interface ZMTimerTarget : NSObject

@property (nonatomic,   weak) id aTarget;    //原始taget
@property (nonatomic, assign) SEL aSelector; //原始selector

@end

@implementation ZMTimerTarget

- (void)timerTargetAction:(NSTimer *)timer
{
    if(self.aTarget && [self.aTarget respondsToSelector:self.aSelector])
    {
        [self.aTarget performSelector:self.aSelector withObject:timer afterDelay:0.0];
    }
}

- (void)dealloc
{
    NSLog(@"%@ 释放了",NSStringFromClass([ZMTimerTarget class]));
}

@end


@implementation NSTimer (ZMSafe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self zm_swizzleClassMethodWithSrcClass:[self class] srcSel:@selector(timerWithTimeInterval:target:selector:userInfo:repeats:) swizzledSel:@selector(zm_timerWithTimeInterval:target:selector:userInfo:repeats:)];
    });
}

+ (NSTimer *)zm_timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo
{
    ZMTimerTarget *timeTarget = [ZMTimerTarget new];
    timeTarget.aTarget = aTarget;
    timeTarget.aSelector = aSelector;
    
    return [NSTimer zm_timerWithTimeInterval:ti target:timeTarget selector:@selector(timerTargetAction:) userInfo:userInfo repeats:yesOrNo];
}

@end
