//
//  PasswordSaleViewController.m
//  hxm
//
//  Created by spring on 15/5/29.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "PasswordSaleViewController.h"
#import "BWCommon.h"

@interface PasswordSaleViewController ()
{
    UILabel *phone_info;
    UITextField *code;
    UITextField *password;
    UITextField *confirmpassword;
    CGSize size;
}
@end

@implementation PasswordSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拍卖密码修改";
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
    
    phone_info = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, size.width-40, 40) ];
    phone_info.text = @"  您的验证手机：15221966658";
    phone_info.backgroundColor = [UIColor whiteColor];
    [phone_info.layer setMasksToBounds:YES];
    [phone_info.layer setCornerRadius:5.0];
    phone_info.textColor = [UIColor redColor];
    [main_view addSubview:phone_info];
    
    NSInteger yy = phone_info.frame.origin.y + phone_info.frame.size.height + 10;
    
    code = [self createTextFieldWithTitle:@"验证码:" yy:yy];
    yy += 50;
    password = [self createTextFieldWithTitle:@"新密码:" yy:yy];
    yy += 50;
    confirmpassword = [self createTextFieldWithTitle:@"确认密码:" yy:yy];
    
    [main_view addSubview:code];
    [main_view addSubview:password];
    [main_view addSubview:confirmpassword];
    
    
    
    UIButton *save_button = [UIButton buttonWithType:UIButtonTypeCustom];
    save_button.frame = CGRectMake(0, confirmpassword.frame.origin.y+confirmpassword.bounds.size.height+30, size.width-40, 40);
    [save_button setTag:30];
    [save_button.layer setMasksToBounds:YES];
    [save_button.layer setCornerRadius:5.0];
    [save_button setTintColor:[UIColor whiteColor]];
    [save_button setBackgroundColor:[UIColor redColor]];
    [save_button setTitle:@"确认修改" forState:UIControlStateNormal];
    [save_button addTarget:self action:@selector(do_action:) forControlEvents:UIControlEventTouchUpInside];
    [main_view addSubview:save_button];
}

- (void)do_action:(UIButton *)sender
{
  //  NSLog(@"save action");
    if(sender.tag==20)
    {
        NSLog(@"获取验证码操作");
    }
    else{
        NSLog(@"确认修改操作");
    }
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
    
    if([title isEqualToString:@"验证码:"])
    {
        NSLog(@"1111");
        /*
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(size.width-80, 20, 80, 40)];
        label2.text = @"获取验证码";
        label2.textColor = [UIColor colorWithRed:116/255.0f green:197/255.0f blue:67/255.0f alpha:1.0];
        [field addSubview:label2];
        */
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(field.frame.size.width-90, 10, 80, 20)];
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        button.tintColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(do_action:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 20;
        button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        //button.font = [UIFont systemFontOfSize:20];
        button.backgroundColor = [UIColor colorWithRed:116/255.0f green:197/255.0f blue:67/255.0f alpha:1.0];

        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:3.0];
        [field addSubview:button];
        
       // field.rightView = button;
        //field.rightViewMode = UITextFieldViewModeAlways;
    }
    
    return field;
}


@end
