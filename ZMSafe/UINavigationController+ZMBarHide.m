//
//  UINavigationController+ZMBarHide.m
//  ZMSafe
//
//  Created by xzm on 2018/7/10.
//  Copyright © 2018年 CHT-Technology. All rights reserved.
//

#import "UINavigationController+ZMBarHide.h"
#import "NSObject+Swizzle.h"

@interface ZMPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *nav;

@end

@implementation ZMPopGestureRecognizerDelegate

#pragma mark -- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UIViewController *lastVC = self.nav.viewControllers.lastObject;
    //不是跟视图控制器 && pop跟push动画没有正在执行 && 手势有效
    if (self.nav.childViewControllers.count > 1
        && ![[self.nav valueForKey:@"_isTransitioning"] boolValue]
        && !lastVC.zm_interactivePopDisabled)
    {
        return YES;
    }
    return NO;
}

@end


@implementation UIViewController (ZMBarHide)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self zm_swizzleInstanceMethodWithSrcClass:[self class] srcSel:@selector(viewWillAppear:) swizzledSel:@selector(zm_viewWillAppear:)];
    });
}

#pragma mark -- swizzling methods
- (void)zm_viewWillAppear:(BOOL)animated
{
    if(![self.navigationController.zm_ignoreVCs containsObject:NSStringFromClass([self class])]
       && self.navigationController.zm_barAppearaceEnabled)
    {
        [self.navigationController setNavigationBarHidden:self.zm_navigationBarHidden animated:animated];
    }
    [self zm_viewWillAppear:animated];
}

#pragma mark -- getter && setter
- (BOOL)zm_navigationBarHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setZm_navigationBarHidden:(BOOL)zm_navigationBarHidden
{
    objc_setAssociatedObject(self, @selector(zm_navigationBarHidden), @(zm_navigationBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)zm_interactivePopDisabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setZm_interactivePopDisabled:(BOOL)zm_interactivePopDisabled
{
    objc_setAssociatedObject(self, @selector(zm_interactivePopDisabled), @(zm_interactivePopDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@implementation UINavigationController (ZMBarHide)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self zm_swizzleInstanceMethodWithSrcClass:[self class] srcSel:@selector(viewDidLoad) swizzledSel:@selector(zm_viewDidLoad)];
    });
}

#pragma mark -- swizzling methods
- (void)zm_viewDidLoad
{
    self.interactivePopGestureRecognizer.delegate = self.zm_popGestureRecognizerDelegate;
    [self zm_viewDidLoad];
}

#pragma mark -- getter && setter
- (NSMutableSet <__kindof NSString *> *)zm_ignoreVCs
{
    NSMutableSet *mSet = objc_getAssociatedObject(self, _cmd);
    if (!mSet)
    {
        mSet = [NSMutableSet set];
        self.zm_ignoreVCs = mSet;
    }
    return mSet;
}

- (void)setZm_ignoreVCs:(NSMutableSet<__kindof NSString *> *)zm_ignoreVCs
{
    objc_setAssociatedObject(self, @selector(zm_ignoreVCs), zm_ignoreVCs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)zm_barAppearaceEnabled
{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if(number){
      return number.boolValue;
    }
    self.zm_barAppearaceEnabled = YES;
    return YES;
}

- (void)setZm_barAppearaceEnabled:(BOOL)zm_barAppearaceEnabled
{
    objc_setAssociatedObject(self, @selector(zm_barAppearaceEnabled), @(zm_barAppearaceEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ZMPopGestureRecognizerDelegate *)zm_popGestureRecognizerDelegate
{
    ZMPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (!delegate)
    {
        delegate = [[ZMPopGestureRecognizerDelegate alloc] init];
        delegate.nav = self;
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

@end

