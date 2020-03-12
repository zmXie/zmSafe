//
//  UINavigationController+ZMBarHidden.m
//  PatientCircle
//
//  Created by xzm on 2018/5/29.
//  Copyright © 2018年 Dachen. All rights reserved.
//

#import "UINavigationController+ZMBarHide.h"
#import <objc/runtime.h>

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

@implementation UIApplication (ZMBarHide)

#pragma mark -- getter && setter
- (NSMutableSet <__kindof NSString *> *)zm_ignoreNavHideVCs
{
    NSMutableSet *mSet = objc_getAssociatedObject(self, _cmd);
    if (!mSet)
    {
        NSArray *defaultArray = @[@"CAMViewfinderViewController",@"LFCameraDisplayController",@"LFCameraTakeViewController",@"LFCameraPickerController",@"UIImagePickerController",@"CAMImagePickerCameraViewController",@"CAMPreviewViewController",@"MFMessageComposeViewController",@"CKSMSComposeController",@"CKSMSComposeRemoteViewController"];
        mSet = [NSMutableSet setWithArray:defaultArray];
        self.zm_ignoreNavHideVCs = mSet;
    }
    return mSet;
}

- (void)setZm_ignoreNavHideVCs:(NSMutableSet<__kindof NSString *> *)zm_ignoreNavHideVCs
{
    objc_setAssociatedObject(self, @selector(zm_ignoreNavHideVCs), zm_ignoreNavHideVCs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end


@implementation UIViewController (ZMBarHide)

void ZMBarHidden_ExchangeImplementation(Class srcClass,SEL srcSel,SEL swizzledSel)
{
    Method srcMethod = class_getInstanceMethod(srcClass, srcSel);
    Method swizzledMethod = class_getInstanceMethod(srcClass, swizzledSel);
    //该类为nil || 该类或者其父类没有这个方法，则不执行交换
    if (!srcClass || !srcMethod || !swizzledMethod) return;
    
    //加一层保护措施，如果添加成功，则表示该方法不存在于本类，而是存在于父类中，不能交换父类的方法,否则父类的对象调用该方法会crash；添加失败则表示本类存在该方法
    BOOL addMethod = class_addMethod(srcClass, srcSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (addMethod)
    {
        //再将原有的实现替换到swizzledMethod方法上，从而实现方法的交换，并且未影响到父类方法的实现
        class_replaceMethod(srcClass, swizzledSel, method_getImplementation(srcMethod), method_getTypeEncoding(srcMethod));
    }else
    {
        method_exchangeImplementations(srcMethod, swizzledMethod);
    }
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ZMBarHidden_ExchangeImplementation([self class],@selector(viewWillAppear:),@selector(zm_viewWillAppear:));
    });
}

#pragma mark -- swizzling methods
- (void)zm_viewWillAppear:(BOOL)animated
{
    //该控制器是否是子控制器，如果是，则不影响父控制器对导航的操作
    UIViewController *parentVC = self.parentViewController;
    BOOL isSubVC = (![parentVC isKindOfClass:[UINavigationController class]] && ![parentVC isKindOfClass:[UITabBarController class]]);
    
    if(![[UIApplication sharedApplication].zm_ignoreNavHideVCs containsObject:NSStringFromClass([self class])]
       && self.navigationController.zm_barAppearaceEnabled && !isSubVC)
    {
        [self.navigationController setNavigationBarHidden:self.zm_navigationBarHidden animated:animated];
        UIView *line = [self.navigationController.navigationBar viewWithTag:113];
        if (line) {
            line.hidden = self.zm_navigationBarLineHidden;
        }
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

- (BOOL)zm_navigationBarLineHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setZm_navigationBarLineHidden:(BOOL)zm_navigationBarLineHidden
{
    objc_setAssociatedObject(self, @selector(zm_navigationBarLineHidden), @(zm_navigationBarLineHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
        ZMBarHidden_ExchangeImplementation([self class],@selector(viewDidLoad),@selector(zm_viewDidLoad));
    });
}

#pragma mark -- swizzling methods
- (void)zm_viewDidLoad
{
    self.interactivePopGestureRecognizer.delegate = self.zm_popGestureRecognizerDelegate;
    [self zm_viewDidLoad];
}

#pragma mark -- getter && setter

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
