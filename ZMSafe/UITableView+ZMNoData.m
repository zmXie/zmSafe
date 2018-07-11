//
//  UITableView+ZMNoData.m
//  ZMSafe
//
//  Created by xzm on 2018/7/5.
//  Copyright © 2018年 CHT-Technology. All rights reserved.
//

#import "UITableView+ZMNoData.h"
#import "NSObject+Swizzle.h"

#define Left(view)   CGRectGetMinX(view.frame)
#define Top(view)    CGRectGetMinY(view.frame)
#define Bottom(view) CGRectGetMaxY(view.frame)
#define Width(view)  CGRectGetWidth(view.frame)
#define Height(view) CGRectGetHeight(view.frame)

@interface ZMEmptyView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                         text:(NSString *)text
                        image:(UIImage *)image;

@end

@implementation ZMEmptyView

- (instancetype)initWithFrame:(CGRect)frame
                         text:(NSString *)text
                        image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        UILabel * label = [UILabel new];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithRed:33/255.f green:33/255.f blue:33/255.f alpha:1.0];
        label.text = text;
        label.textAlignment = 1;
        [label sizeToFit];
        CGPoint centerPoint = CGPointMake(CGRectGetMaxX(frame)/2.f, CGRectGetMaxY(frame)/2.f);
        label.center = centerPoint;
        [self addSubview:label];
        
        if(image)
        {
            CGFloat margin = 10;
            UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
            [imageView sizeToFit];
            [self addSubview:imageView];
            imageView.center = centerPoint;
            imageView.frame = CGRectMake(Left(imageView), Top(imageView) - (Height(label) + margin)/2.f, Width(imageView), Height(imageView));
            label.frame = CGRectMake(Left(label), Bottom(imageView) + margin, Width(label), Height(label));
        }
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end;

@implementation UITableView (ZMNoData)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self zm_swizzleInstanceMethodWithSrcClass:[self class] srcSel:@selector(reloadData) swizzledSel:@selector(zm_reloadData)];
    });
}

#pragma mark -- swizzling methods
- (void)zm_reloadData
{
    //需要显示空页面 && 已经跳过第一次加载(设置datasource的时候会自动执行一次reloadData,需要跳过)
    if(self.zm_showEmpty && self.zm_firstSkiped) [self zm_checkEmpty];
    self.zm_firstSkiped = YES;
    [self zm_reloadData];
}

/** 检查是否为空页面 */
- (void)zm_checkEmpty
{
    BOOL isEmpty = YES;
    id<UITableViewDataSource> dataSource = self.dataSource;
    NSInteger sections = 1;
    if([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)])
    {
        sections = [dataSource numberOfSectionsInTableView:self];
    }
    //遍历组，判断是否有row
    for (int i = 0; i < sections; i++){
        if([dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)])
        {
            if([dataSource tableView:self numberOfRowsInSection:i] > 0)
            {
                isEmpty = NO;
                break;
            }
        }
    }
    //显示隐藏空页面
    if(isEmpty)
    {
        if(!self.zm_emptyView)
        {
            self.zm_emptyView = [[ZMEmptyView alloc]initWithFrame:self.bounds text:self.zm_emptyText image:self.zm_emptyImage];
            [self addSubview:self.zm_emptyView];
        }
        self.zm_emptyView.hidden = NO;
        
    }else
    {
        self.zm_emptyView.hidden = YES;
    }
}

#pragma mark -- getter && setter
- (BOOL)zm_showEmpty
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setZm_showEmpty:(BOOL)zm_showEmpty
{
    objc_setAssociatedObject(self, @selector(zm_showEmpty), @(zm_showEmpty), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)zm_firstSkiped
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setZm_firstSkiped:(BOOL)zm_firstSkiped
{
    objc_setAssociatedObject(self, @selector(zm_firstSkiped), @(zm_firstSkiped), OBJC_ASSOCIATION_ASSIGN);
}

- (NSString *)zm_emptyText
{
    NSString *text = objc_getAssociatedObject(self, _cmd);
    if(!text) text = @"暂无数据";
    return text;
}

- (void)setZm_emptyText:(NSString *)zm_emptyText
{
    objc_setAssociatedObject(self, @selector(zm_emptyText), zm_emptyText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)zm_emptyImage
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setZm_emptyImage:(UIImage *)zm_emptyImage
{
    objc_setAssociatedObject(self, @selector(zm_emptyImage), zm_emptyImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ZMEmptyView *)zm_emptyView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setZm_emptyView:(ZMEmptyView *)zm_emptyView
{
    objc_setAssociatedObject(self, @selector(zm_emptyView), zm_emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


