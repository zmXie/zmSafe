//
//  ThirdViewController.m
//  ZMSafe
//
//  Created by xzm on 2018/7/10.
//  Copyright © 2018年 CHT-Technology. All rights reserved.
//

#import "ThirdViewController.h"


@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self setValue:@(YES) forKey:@"zm_navigationBarHidden"];
//    [self.navigationController setNavigationBarHidden:YES];
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self.navigationController pushViewController:[ThirdViewController new] animated:YES];
}

@end
