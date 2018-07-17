//
//  NavgationViewController.m
//  ZMSafe
//
//  Created by xzm on 2018/7/6.
//  Copyright © 2018年 CHT-Technology. All rights reserved.
//

#import "NavgationViewController.h"


@interface NavgationViewController ()

@end

@implementation NavgationViewController

+ (void)load
{
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [UINavigationBar appearance].barTintColor = [UIColor brownColor];
    
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
//    [[UINavigationBar appearance] setBackgroundImage:[self imageWithColor:[UIColor orangeColor]] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setTranslucent:NO];
    
    [[UINavigationBar appearance] setBackIndicatorImage:[[UIImage imageNamed:@"title_icon_back"]imageWithRenderingMode:UIImageRenderingModeAutomatic]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[[UIImage imageNamed:@"title_icon_back"]imageWithRenderingMode:UIImageRenderingModeAutomatic]];
    
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGSize imageSize = CGSizeMake(1, 1);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    return YES;
//}

- (void)dealloc
{
    NSLog(@"%@ 销毁了",NSStringFromClass([self class]));
}


@end
