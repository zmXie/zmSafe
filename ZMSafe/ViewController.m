//
//  ViewController.m
//  ZMSafe
//
//  Created by CHT-Technology on 2017/12/25.
//  Copyright © 2017年 CHT-Technology. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "UIButton+ZMTap.h"
#import "NSObject+ZMRuntime.h"
#import "UILabel+ZMMargin.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *zm_label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"FirstVC";
    
    [self testMethod];
    [self testArray];
    [self testDic];
    [self testUIKit];
//    [self setValue:@(YES) forKey:@"zm_navigationBarHidden"];

//    [self logSubViews:self.navigationController.navigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)logSubViews:(UIView *)view
{
    for (UIView *subView in view.subviews)
    {
        NSLog(@"%@",subView);
        if(subView.subviews.count > 0)
        {
            [self logSubViews:subView];
        }
    }
}

- (void)testArray
{
    NSString *a = nil;
    NSArray *arr = @[@"1",@"2",a];
    NSLog(@"数组第三个元素：%@",[arr objectAtIndex:2]);
    
    NSMutableArray *mArr = [NSMutableArray array];
    [mArr addObject:@"1"];
    [mArr objectAtIndex:2];
    [mArr addObject:a];
    NSLog(@"可变数组:%@",mArr);
}

- (void)testDic
{
    NSString *sex = nil;
    NSDictionary *dic = @{@"name":@"小明",
                          @"age":@"18",
                          @"sex":sex,
                          @"hobby":@"play"
                          };
    NSLog(@"字典输出:%@",dic);
}

- (void)testUIKit
{
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(50, 84, 200, 30)];
    pageControl.numberOfPages = 5;
    pageControl.backgroundColor = [UIColor orangeColor];
    [pageControl setValue:[UIImage imageNamed:@"ic_pagecontrol"] forKey:@"_pageImage"];
    [pageControl setValue:[UIImage imageNamed:@"ic_pagecontrol_selec"] forKey:@"_currentPageImage"];
    [self.view addSubview:pageControl];
    
    self.zm_label.layer.cornerRadius = 5;
    self.zm_label.layer.masksToBounds = YES;
    self.zm_label.layer.borderColor = [UIColor grayColor].CGColor;
    self.zm_label.layer.borderWidth = 0.5;
    self.zm_label.zm_textEdgeInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    
//    NSLog(@"%@",[[UIPageControl class] zm_propertyList]);
//    NSLog(@"%@",[[UIPageControl class] zm_ivarList]);
//    NSLog(@"%@",[[UIPageControl class] zm_methodList]);
//    NSLog(@"%@",[[UIPageControl class] zm_protocolList]);
    
}

- (void)testMethod
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 150, 80, 80)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(redBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *greenBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 250, 80, 80)];
    greenBtn.backgroundColor = [UIColor greenColor];
    [greenBtn addTarget:self action:@selector(greenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:greenBtn];
    greenBtn.zm_hitEdgeInsets = UIEdgeInsetsMake(-50, -50, -50, -50);
    
    UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(100, 400, 80, 80)];
    control.backgroundColor = [UIColor grayColor];
    [control addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
    
    //    objc_msgSend(self,@selector(btnAction));
    
}

- (void)redBtnAction:(UIButton *)btn
{
    NSLog(@"点击了红按钮");
}

- (void)greenBtnAction:(UIButton *)btn
{
    NSLog(@"点击了绿按钮");
}

- (void)controlAction
{
    NSLog(@"点击了灰色按钮");
    [self.navigationController pushViewController:[NSClassFromString(@"SecondViewController") new] animated:YES];
}


@end
