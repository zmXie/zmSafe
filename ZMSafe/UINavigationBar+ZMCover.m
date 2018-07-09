//
//  UINavigationBar+ZMCover.m
//  ZMSafe
//
//  Created by xzm on 2018/7/6.
//  Copyright © 2018年 CHT-Technology. All rights reserved.
//

#import "UINavigationBar+ZMCover.h"
#import <objc/runtime.h>

@implementation UINavigationBar (ZMCover)

- (UIView *)coverView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCoverView:(UIView *)view
{
    objc_setAssociatedObject(self, @selector(coverView), view, OBJC_ASSOCIATION_RETAIN);
}

- (void)zm_setBackgroundColor:(UIColor *)backgroundColor
{
    if(!self.coverView)
    {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
        CGFloat statusH = CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame);
        self.coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds) + statusH)];
        self.coverView.userInteractionEnabled = NO;
        self.coverView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [[self.subviews firstObject] insertSubview:self.coverView atIndex:0];
    }
    self.coverView.backgroundColor = backgroundColor;
}

- (void)zm_setElementAlpha:(CGFloat)alpha
{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *subView in self.subviews) {
            if(![subView isKindOfClass:NSClassFromString(@"_UIBarBackground")])
            {
                subView.alpha = alpha;
            }
        }
    });
}

- (void)zm_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)zm_reset
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.coverView removeFromSuperview];
    self.coverView = nil;
    [self zm_setElementAlpha:1];
    [self zm_setTranslationY:0];
}

@end
