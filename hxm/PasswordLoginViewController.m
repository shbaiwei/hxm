//
//  PasswordLoginViewController.m
//  hxm
//
//  Created by spring on 15/5/29.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "PasswordLoginViewController.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"

@interface PasswordLoginViewController ()
{
    CGSize size;
    UIButton *save_button;
}
@end

@implementation PasswordLoginViewController

@synthesize password;
@synthesize newpassword;
@synthesize confirmpassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录密码修改";
    // Do any additional setup after loading the view.
    [self pageLayout];
    [self checkMobile];
}

- (void)pageLayout
{
    UIColor *bgColor = [BWCommon getBackgroundColor];
    self.view.backgroundColor = bgColor;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    
    UIView *main_view = [[UIView alloc] initWithFrame:CGRectMake(20, 60, size.width, size.height)];
    [self.view addSubview:main_view];
    NSInteger yy = 10;
    
    password = [self createTextFieldWithTitle:@"原密码：" yy:yy];
    password.secureTextEntry = YES;
    yy += 50;
    newpassword = [self createTextFieldWithTitle:@"新密码：" yy:yy];
    newpassword.secureTextEntry = YES;
    yy += 50;
    confirmpassword = [self createTextFieldWithTitle:@"确认密码：" yy:yy];
    confirmpassword.secureTextEntry = YES;
    [main_view addSubview:password];
    [main_view addSubview:newpassword];
    [main_view addSubview:confirmpassword];
    
    save_button = [UIButton buttonWithType:UIButtonTypeCustom];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统提示" message:@"系统信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    if([password.text isEqualToString:@""])
    {
        alert.message = @"请输入您的愿密码";
        [alert show];
        return ;
    }
    if([newpassword.text isEqualToString:@""])
    {
        alert.message = @"请输入您的新密码";
        [alert show];
        return;
    }
    if([confirmpassword.text isEqualToString:@""])
    {
        alert.message = @"请再次输入您的密码";
        [alert show];
        return;
    }
    if([confirmpassword.text isEqualToString:newpassword.text] == FALSE)
    {
        alert.message = @"两次密码不一致，请检查";
        [alert show];
        return;
    }
    
    MBProgressHUD *hud;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"user/modifyPassword"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"user/modifyPassword"];
    
    [postData setValue:self.mobile forKey:@"mobile"];
    [postData setValue:password.text forKey:@"password"];
    [postData setValue:newpassword.text forKey:@"newpassword"];
    //[postData setValue:@"15221966658" forKey:@"mobile"];
    //[postData setValue:@"hj1234567" forKey:@"password"];
    //[postData setValue:@"1qaz2wsx" forKey:@"newpassword"];
    
    NSLog(@"%@",url);
    NSLog(@"postData:%@",postData);
    //load data
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSLog(@"responseObject:%@",responseObject);
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        [hud removeFromSuperview];
        if(errNo == 0)
        {
            //处理成功
            alert.message = @"登陆密码修改成功";
            [alert show];
            
        }
        else
        {
            alert.message = [responseObject objectForKey:@"error"];
            [alert show];
            NSLog(@"%@",[responseObject objectForKey:@"error"]);
        }
        
    } fail:^{
        [hud removeFromSuperview];
        alert.message = @"请求失败";
        [alert show];
        NSLog(@"请求失败");
    }];

    
    //NSLog(@"save action");
}

- (void)checkMobile
{
    if (self.mobile==NULL) {
        save_button.backgroundColor = [UIColor grayColor];
        [save_button setUserInteractionEnabled:NO];
        [save_button setAlpha:0.4];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统提示" message:@"未绑定手机号码不能进行修改密码操作！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        
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
    
    return field;
}

-(IBAction)backgroundTap:(id)sender
{
    [password resignFirstResponder];
    [newpassword resignFirstResponder];
    [confirmpassword resignFirstResponder];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //[nameTextField resignFirstResponder];
    //    [numberTextField resignFirstResponder];
    [textField resignFirstResponder];//等于上面两行的代码
    
    //NSLog(@"textFieldShouldReturn");//测试用
    return YES;
}
@end
