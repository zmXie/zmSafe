//
//  UINavigationBar+ZMCover.h
//  ZMSafe
//
//  Created by xzm on 2018/7/6.
//  Copyright © 2018年 CHT-Technology. All rights reserved.
//  设置NavigationBar透明+位移

#import <UIKit/UIKit.h>

@interface UINavigationBar (ZMCover)

- (void)zm_setBackgroundColor:(UIColor *)backgroundColor;

- (void)zm_setTranslationY:(CGFloat)translationY;

- (void)zm_setElementAlpha:(CGFloat)alpha;

- (void)zm_reset;

@end
