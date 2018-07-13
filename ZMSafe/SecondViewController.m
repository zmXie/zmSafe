//
//  SecondViewController.m
//  ZMSafe
//
//  Created by xzm on 2018/7/5.
//  Copyright © 2018年 CHT-Technology. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "UINavigationBar+ZMCover.h"
#import "UITableView+ZMNoData.h"
#import "UINavigationController+ZMBarHide.h"

@interface ZMTableView : UITableView

@end

@implementation ZMTableView

//- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event;
//{
//    UIView *view = [super hitTest:point withEvent:event];
//    NSLog(@"%@",view);
//    NSLog(@"%@",NSStringFromClass(self.class));
//    if([view isKindOfClass:self.class])
//    {
//        
//        return nil;
//    }
//    return view;
//}

@end

@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _count;
}

@property (nonatomic  ,weak) NSTimer     * timer;
@property (nonatomic,strong) UITableView * tableView;

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"SecondVC";
//    [self setValue:@(YES) forKey:@"zm_interactivePopDisabled"];
//    [self testTimer];
    [self testTableView];
    
//    [self setValue:@(YES) forKey:@"zm_navigationBarHidden"];
    [self valueForKey:@"uuu"];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self scrollViewDidScroll:self.tableView];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [self.navigationController.navigationBar zm_reset];
//    [super viewWillDisappear:animated];
//}

- (void)testTableView
{
    self.tableView = [[ZMTableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)) style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetMaxX([UIScreen mainScreen].bounds), 200)];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.zm_showEmpty = YES;
    self.tableView.zm_emptyImage = [UIImage imageNamed:@"default_images_all"];
    [self.view addSubview:self.tableView];
    
    [self changeCount];
    
}

- (void)changeCount
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _count = _count == 0 ? 50 : 0;
        [self.tableView reloadData];
//        [self changeCount];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[ThirdViewController new] animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.y);
    CGFloat persent = (scrollView.contentOffset.y + 64)/ 200.f;
    [self.navigationController.navigationBar zm_setBackgroundColor:[[UIColor magentaColor] colorWithAlphaComponent:persent]];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithWhite:persent alpha:1];

//    [self.navigationController.navigationBar zm_setTranslationY:MIN(0, -44 * MIN(1, persent))];
//    [self.navigationController.navigationBar zm_setElementAlpha:MAX(0, 1-persent)];
}

- (void)testTimer
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
    [self.timer fire];
    NSLog(@"%@",NSStringFromClass([self.timer class]));
}

- (void)timeAction
{
    NSLog(@"哈哈");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController.zm_ignoreVCs addObject:NSStringFromClass([ThirdViewController class])];
    [self.navigationController pushViewController:[ThirdViewController new] animated:YES];
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"%@ 销毁了", NSStringFromClass([self class]));
}

@end
