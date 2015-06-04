//
//  PasswordSaleViewController.m
//  hxm
//
//  Created by spring on 15/5/29.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "PasswordSaleViewController.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"
#import "JKCountDownButton.h"

@interface PasswordSaleViewController ()
{
    MBProgressHUD *hud;
    UILabel *phone_info;
    JKCountDownButton *getCodeButton;
    CGSize size;
    UIButton *save_button;
}
@end

@implementation PasswordSaleViewController

@synthesize code;
@synthesize password;
@synthesize confirmpassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拍卖密码修改";
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
    
    phone_info = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, size.width-40, 40) ];
    NSString *phone = [NSString stringWithFormat:@"  您的验证手机：%@",self.mobile];
    phone_info.text = phone;
    
    phone_info.backgroundColor = [UIColor whiteColor];
    [phone_info.layer setMasksToBounds:YES];
    [phone_info.layer setCornerRadius:5.0];
    phone_info.textColor = [UIColor redColor];
    [main_view addSubview:phone_info];
    
    NSInteger yy = phone_info.frame.origin.y + phone_info.frame.size.height + 10;
    
    code = [self createTextFieldWithTitle:@"验证码:" yy:yy];
    code.keyboardType = UIKeyboardTypeNumberPad;
    yy += 50;
    password = [self createTextFieldWithTitle:@"新密码:" yy:yy];
    password.secureTextEntry = YES;
    yy += 50;
    confirmpassword = [self createTextFieldWithTitle:@"确认密码:" yy:yy];
    confirmpassword.secureTextEntry = YES;
    [main_view addSubview:code];
    [main_view addSubview:password];
    [main_view addSubview:confirmpassword];
    
    
    
    save_button = [UIButton buttonWithType:UIButtonTypeCustom];
    save_button.frame = CGRectMake(0, confirmpassword.frame.origin.y+confirmpassword.bounds.size.height+30, size.width-40, 40);
    [save_button setTag:30];
    [save_button.layer setMasksToBounds:YES];
    [save_button.layer setCornerRadius:5.0];
    [save_button setTintColor:[UIColor whiteColor]];
    [save_button setBackgroundColor:[UIColor redColor]];
    [save_button setTitle:@"确认修改" forState:UIControlStateNormal];
    [save_button addTarget:self action:@selector(do_action:) forControlEvents:UIControlEventTouchUpInside];
    [main_view addSubview:save_button];
    
    /*发送验证码uibutton事件处理*/
    [getCodeButton addToucheHandler:^(JKCountDownButton*sender, NSInteger tag) {
        
        [self sendPhoneCode];
        UIColor *orgin_color = sender.backgroundColor;
        sender.backgroundColor = [UIColor grayColor];
        sender.enabled = NO;
        
        [sender startWithSecond:60];
        
        [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
            NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
            return title;
        }];
        [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
            countDownButton.enabled = YES;
            sender.backgroundColor = orgin_color;
            return @"重新获取";
            
        }];
        
    }];
    /*发送验证码uibutton事件处理－－－end*/
}

- (void)do_action:(UIButton *)sender
{
  //  NSLog(@"save action");
    if(sender.tag==20)
    {
        NSLog(@"获取验证码操作");
        //[self sendPhoneCode];
    }
    else{
        //NSLog(@"确认修改操作");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统提示" message:@"系统提示信息" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        if([code.text isEqualToString:@""])
        {
            alert.message = @"请输入您收到的手机验证码信息";
            [alert show];
            return;
        }
        if([password.text isEqualToString:@""])
        {
            alert.message = @"请输入您的新密码";
            [alert show];
            return;
        }
        if([confirmpassword.text isEqualToString:@""])
        {
            alert.message = @"请输入您的确认密码";
            [alert show];
            return;
        }
        if ([confirmpassword.text isEqualToString:password.text] == FALSE) {
            alert.message = @"密码不一致，请检查";
            [alert show];
            return;
        }
        
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.delegate=self;
        
        NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"user/modifyAuctionPassword"];
        
        NSMutableDictionary *postData = [BWCommon getTokenData:@"user/modifyAuctionPassword"];
        
        [postData setValue:self.mobile forKey:@"mobile"];
        [postData setValue:code.text forKey:@"code"];
        [postData setValue:password.text forKey:@"password"];
        NSLog(@"%@",url);
        //load data
        [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
            
            NSLog(@"responseObject:%@",responseObject);
            NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
            
            [hud removeFromSuperview];
            if(errNo == 0)
            {
                //处理成功
                alert.message = @"拍卖密码修改成功";
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
        

    }
}

//发送手机验证码
- (void)sendPhoneCode
{
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    if (self.mobile == NULL) {
        alert.message = @"未绑定手机号码不能进行修改密码操作！";
        [alert show];
    }
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"common/sendSmsCode"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"common/sendSmsCode"];
    
    [postData setValue:self.mobile forKey:@"mobile"];
    //[postData setValue:@"15221966658" forKey:@"mobile"];
    [postData setValue:@"发送手机验证码" forKey:@"msg"];
    NSLog(@"%@",url);
    //load data
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSLog(@"userinfo:%@",responseObject);
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        [hud removeFromSuperview];
        if(errNo == 0)
        {
            //处理成功
            alert.message = @"成功发送验证码,请尽快填写验证";
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
        NSLog(@"请求失败");
    }];
    
    
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
    
    if([title isEqualToString:@"验证码:"])
    {
       // NSLog(@"1111");
        /*
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(size.width-80, 20, 80, 40)];
        label2.text = @"获取验证码";
        label2.textColor = [UIColor colorWithRed:116/255.0f green:197/255.0f blue:67/255.0f alpha:1.0];
        [field addSubview:label2];
        */
        
        getCodeButton = [[JKCountDownButton alloc] initWithFrame:CGRectMake(field.frame.size.width-90, 10, 80, 20)];
        [getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        getCodeButton.tintColor = [UIColor whiteColor];
        //[getCodeButton addTarget:self action:@selector(do_action:) forControlEvents:UIControlEventTouchUpInside];
       // getCodeButton.tag = 20;
        getCodeButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        //button.font = [UIFont systemFontOfSize:20];
        getCodeButton.backgroundColor = [UIColor colorWithRed:116/255.0f green:197/255.0f blue:67/255.0f alpha:1.0];

        [getCodeButton.layer setMasksToBounds:YES];
        [getCodeButton.layer setCornerRadius:3.0];
        [field addSubview:getCodeButton];
        
        
        
       // field.rightView = button;
        //field.rightViewMode = UITextFieldViewModeAlways;
    }
    
    return field;
}


@end
