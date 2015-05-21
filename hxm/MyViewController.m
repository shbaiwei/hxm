//
//  MyViewController.m
//  hxm
//
//  Created by Bruce He on 15-5-21.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "MyViewController.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
}

- (void) pageLayout{
    
    UIColor *bgColor = [BWCommon getBackgroundColor];
    self.view.backgroundColor = bgColor;
    
    NSLog(@"%@",[BWCommon getUserInfo:@"uid"]);
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView *topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user-bg.jpg"]];
    topView.frame = CGRectMake(0, 0, size.width, 300);
    
    
    [self.view addSubview:topView];
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 160, size.width, size.height-160)];
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width, size.height);
    [self.view addSubview:sclView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
