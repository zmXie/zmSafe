//
//  UITableView+ZMNoData.h
//  ZMSafe
//
//  Created by xzm on 2018/7/5.
//  Copyright © 2018年 CHT-Technology. All rights reserved.
//  自动添加tableView空页面

#import <UIKit/UIKit.h>

@interface UITableView (ZMNoData)

/** 无数据时是否显示空页面，默认为NO*/
@property (nonatomic,assign) BOOL zm_showEmpty;

/** 空页面显示的文字，默认为”暂无数据“*/
@property (nonatomic,  copy) NSString *zm_emptyText;

/** 空页面显示的图片，默认为空 */
@property (nonatomic,strong) UIImage *zm_emptyImage;

@end
