//
//  NSObject+ZMRuntime.h
//  ZMSafe
//
//  Created by xzm on 2018/7/4.
//  Copyright © 2018年 CHT-Technology. All rights reserved.
//  获取类所有的属性、成员变量、方法、协议

#import <Foundation/Foundation.h>

@interface NSObject (ZMRuntime)

/**
 返回当前类所有的属性

 @return 属性数组
 */
+ (NSArray *)zm_propertyList;

/**
 返回当前类所有的成员变量

 @return 成员变量数组
 */
+ (NSArray *)zm_ivarList;

/**
 放回当前类所有的方法

 @return 方法数组
 */
+ (NSArray *)zm_methodList;

/**
 返回当前类所有的协议

 @return 协议列表
 */
+ (NSArray *)zm_protocolList;


@end
