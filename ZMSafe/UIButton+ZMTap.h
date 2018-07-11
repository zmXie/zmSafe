//
//  UIButton+TapHandle.h
//  ZMSafe
//
//  Created by xzm on 2018/7/3.
//  Copyright © 2018年 CHT-Technology. All rights reserved.
//  控制按钮点击范围、防止按钮暴力点击

#import <UIKit/UIKit.h>

@interface UIButton (ZMTap)

/** 控制按钮的点击范围 {上，左，下，右}*/
@property (nonatomic,assign) UIEdgeInsets zm_hitEdgeInsets;

@end
