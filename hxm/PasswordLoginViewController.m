//
//  PasswordLoginViewController.m
//  hxm
//
//  Created by spring on 15/5/29.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "PasswordLoginViewController.h"
#import "BWCommon.h"


@interface PasswordLoginViewController ()
{
    UITextField *password;
    UITextField *newpassword;
    UITextField *confirmpassword;
    CGSize size;
}
@end

@implementation PasswordLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录密码修改";
    // Do any additional setup after loading the view.
    [self pageLayout];
}

- (void)pageLayout
{
    UIColor *bgColor = [BWCommon getBackgroundColor];
    self.view.backgroundColor = bgColor;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    
    UIView *main_view = [[UIView alloc] initWithFrame:CGRectMake(20, 60, size.width, size.height)];
    [self.view addSubview:main_view];
    NSInteger yy = 0;
    
    password = [self createTextFieldWithTitle:@"原密码：" yy:yy];
    yy += 50;
    newpassword = [self createTextFieldWithTitle:@"新密码：" yy:yy];
    yy += 50;
    confirmpassword = [self createTextFieldWithTitle:@"确认密码：" yy:yy];

    [main_view addSubview:password];
    [main_view addSubview:newpassword];
    [main_view addSubview:confirmpassword];
    
    UIButton *save_button = [UIButton buttonWithType:UIButtonTypeCustom];
    save_button.frame = CGRectMake(0, confirmpassword.frame.origin.y+confirmpassword.bounds.size.height+30, size.width-40, 40);
    [save_button setTag:30];
    [save_button.layer setMasksToBounds:YES];
    [save_button.layer setCornerRadius:3.0];
    [save_button setTintColor:[UIColor whiteColor]];
    [save_button setBackgroundColor:[UIColor redColor]];
    [save_button setTitle:@"确认修改" forState:UIControlStateNormal];
    [save_button addTarget:self action:@selector(do_save:) forControlEvents:UIControlEventTouchUpInside];
    [main_view addSubview:save_button];
}

- (void)do_save:(id *)sender
{
    NSLog(@"save action");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (UITextField *) createTextFieldWithTitle:(NSString *) title yy:(NSInteger)yy{
    
    UITextField * field = [[UITextField alloc] initWithFrame:CGRectMake(0, yy+10, size.width-40, 40)];
    field.borderStyle = UITextBorderStyleRoundedRect;
    [field.layer setCornerRadius:5.0];
    //field.placeholder = title;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 100, 40)];
    
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    field.leftView = label;
    field.leftViewMode = UITextFieldViewModeAlways;
    field.translatesAutoresizingMaskIntoConstraints = NO;
    field.delegate = self;
    
    return field;
}
@end
