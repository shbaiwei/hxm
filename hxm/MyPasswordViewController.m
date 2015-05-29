//
//  MyPasswordViewController.m
//  hxm
//
//  Created by spring on 15/5/28.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "MyPasswordViewController.h"
#import "BWCommon.h"

@interface MyPasswordViewController ()

@end

@implementation MyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self pageLayout];
}

- (void)pageLayout
{
    UIColor *bgColor = [BWCommon getBackgroundColor];
    self.view.backgroundColor = bgColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.title = @"密码管理";
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    // 进入页面隐藏标签栏
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    // 离开页面显示标签栏
    self.tabBarController.tabBar.hidden = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
