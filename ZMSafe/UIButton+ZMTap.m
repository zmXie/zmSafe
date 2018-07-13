//
//  UIButton+TapHandle.m
//  ZMSafe
//
//  Created by xzm on 2018/7/3.
//  Copyright © 2018年 CHT-Technology. All rights reserved.
//

#import "UIButton+ZMTap.h"
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

static const CGFloat EventTimeInterval = 0.5;

@interface UIButton()

/** 是否忽略事件 */
@property (nonatomic,assign) BOOL isIgnoreEvent;

@end

@implementation UIButton (ZMTap)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self zm_swizzleInstanceMethodWithSrcClass:[self class] srcSel:@selector(sendAction:to:forEvent:) swizzledSel:@selector(zm_sendAction:to:forEvent:)];
    });
}

#pragma mark -- swizzling methods
- (void)zm_sendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event
{
    if(self.isIgnoreEvent) return;
    self.isIgnoreEvent = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(EventTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isIgnoreEvent = NO;
    });
    [self zm_sendAction:action to:target forEvent:event];
}

#pragma mark -- cover system
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if(UIEdgeInsetsEqualToEdgeInsets(self.zm_hitEdgeInsets, UIEdgeInsetsZero)
       || !self.userInteractionEnabled
       || !self.enabled
       || self.hidden)
    {
        return [super pointInside:point withEvent:event];
    }
    //返回范围控制之后的rect
    CGRect hitRect = UIEdgeInsetsInsetRect(self.bounds, self.zm_hitEdgeInsets);
    return  CGRectContainsPoint(hitRect, point);
}

#pragma mark -- getter && setter
- (BOOL)isIgnoreEvent
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent
{
    objc_setAssociatedObject(self, @selector(isIgnoreEvent), @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)zm_hitEdgeInsets
{
    NSValue *value = objc_getAssociatedObject(self, _cmd);
    if (value)
    {
        return value.UIEdgeInsetsValue;
    }
    return UIEdgeInsetsZero;
}

- (void)setZm_hitEdgeInsets:(UIEdgeInsets)hitEdgeInsets
{
    objc_setAssociatedObject(self, @selector(zm_hitEdgeInsets), [NSValue valueWithUIEdgeInsets:hitEdgeInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
