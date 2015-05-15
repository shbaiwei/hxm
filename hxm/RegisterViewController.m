//
//  RegisterViewController.m
//  hxm
//
//  Created by Bruce on 15-5-14.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "RegisterViewController.h"
#import "BWCommon.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
}

-(void) pageLayout {
    
    UIColor *bgColor = [BWCommon getBackgroundColor];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    sclView.backgroundColor = bgColor;
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width, size.height);
    [self.view addSubview:sclView];

    self.view.backgroundColor = bgColor;
    [self.navigationItem setTitle:@"注册"];
    
    UITextField *username = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 270, 50)];
    username.borderStyle = UITextBorderStyleRoundedRect;
    [username.layer setCornerRadius:5.0];
    //username.backgroundColor = [UIColor whiteColor];
    username.placeholder = @"会员名";
    UIImageView *usernameIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-user.png"]];
    username.leftView = usernameIcon;
    username.leftViewMode = UITextFieldViewModeAlways;
    username.translatesAutoresizingMaskIntoConstraints = NO;
    
    [sclView addSubview:username];
    
    
    
    NSArray *constraints1= [NSLayoutConstraint constraintsWithVisualFormat:@"|-[username(==270)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(username)];
    NSArray *constraints2= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[username(==50)]-40-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(username)];
    
    [sclView addConstraints:constraints1];
    [sclView addConstraints:constraints2];
    
    
    //水平居中
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:username attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    

    
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
