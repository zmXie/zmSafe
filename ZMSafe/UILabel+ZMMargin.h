//
//  UILabel+ZMMargin.h
//  ZMSafe
//
//  Created by xzm on 2018/7/5.
//  Copyright © 2018年 CHT-Technology. All rights reserved.
//  设置label文字边距

#import <UIKit/UIKit.h>

@interface UILabel (ZMMargin)

/** 文字边缘间距 {上，左，下，右}*/
@property (nonatomic,assign) UIEdgeInsets zm_textEdgeInset;

@end
