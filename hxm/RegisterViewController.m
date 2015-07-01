//
//  RegisterViewController.m
//  hxm
//
//  Created by Bruce on 15-5-14.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "RegisterViewController.h"
#import "ApplyViewController.h"
#import "AFNetworkTool.h"
#import "BWCommon.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

UITextField *rusername;
UITextField *rpassword;
UITextField *repassword;
UITextField *mobile;
UITextField *email;


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
    
    rusername = [self createTextField:@"login-user.png" Title:@"会员名"];
    [sclView addSubview:rusername];
    rusername.delegate = self;
    
    rpassword = [self createTextField:@"login-password.png" Title:@"登录密码"];
    rpassword.secureTextEntry = YES;
    [sclView addSubview:rpassword];
    rpassword.delegate = self;
    
    repassword = [self createTextField:@"register-password.png" Title:@"确认密码"];
    repassword.secureTextEntry = YES;
    [sclView addSubview:repassword];
    repassword.delegate = self;
    
    mobile = [self createTextField:@"register-cellphone.png" Title:@"手机号码"];
    [sclView addSubview:mobile];
    mobile.delegate = self;
    
    email = [self createTextField:@"register-email.png" Title:@"电子邮箱"];
    [sclView addSubview:email];
    email.delegate = self;
    
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnRegister.frame = CGRectMake(0, 0, 270, 50);
    [btnRegister.layer setMasksToBounds:YES];
    [btnRegister.layer setCornerRadius:5.0];
    btnRegister.translatesAutoresizingMaskIntoConstraints = NO;
    btnRegister.backgroundColor = [UIColor colorWithRed:116/255.0 green:197/255.0 blue:67/255.0 alpha:1];
    btnRegister.tintColor = [UIColor whiteColor];
    btnRegister.titleLabel.font = [UIFont systemFontOfSize:22];
    
    [btnRegister setTitle:@"提交注册" forState:UIControlStateNormal];
    
    //点击回调
    [btnRegister addTarget:self action:@selector(registerTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [sclView addSubview:btnRegister];
    
    
    
    NSArray *constraints1= [NSLayoutConstraint constraintsWithVisualFormat:@"|-[rusername(==270)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(rusername)];
    NSArray *constraints2= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[rusername(==50)]-10-[rpassword(==50)]-10-[repassword(==50)]-10-[mobile(==50)]-10-[email(==50)]-20-[btnRegister(==50)]-80-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(rusername,rpassword,repassword,mobile,email,btnRegister)];
    
    NSArray *constraints3= [NSLayoutConstraint constraintsWithVisualFormat:@"|-[rpassword(==270)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(rpassword)];
    NSArray *constraints4= [NSLayoutConstraint constraintsWithVisualFormat:@"|-[repassword(==270)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(repassword)];
    NSArray *constraints5= [NSLayoutConstraint constraintsWithVisualFormat:@"|-[mobile(==270)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(mobile)];
    NSArray *constraints6= [NSLayoutConstraint constraintsWithVisualFormat:@"|-[email(==270)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(email)];
    
    NSArray *constraints7= [NSLayoutConstraint constraintsWithVisualFormat:@"|-[btnRegister(==270)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btnRegister)];
    
    [sclView addConstraints:constraints1];
    [sclView addConstraints:constraints2];
    [sclView addConstraints:constraints3];
    [sclView addConstraints:constraints4];
    [sclView addConstraints:constraints5];
    [sclView addConstraints:constraints6];
    [sclView addConstraints:constraints7];
    
    
    //水平居中
    
    [self setTextFieldCenter:[[NSArray alloc] initWithObjects:rusername,rpassword,repassword,mobile,email,btnRegister,nil]];
    

    // tap for dismissing keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    // very important make delegate useful
    tap.delegate = self;
    
    
}

// tap dismiss keyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    //[self.password resignFirstResponder];
}


-(void) registerTouched: (id)sender
{
    NSString *usernameValue = rusername.text;
    NSString *passwordValue = rpassword.text;
    NSString *repasswordValue = repassword.text;
    NSString *mobileValue = mobile.text;
    NSString *emailValue = email.text;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    if([usernameValue isEqualToString:@""])
    {
        [alert setMessage:@"用户名未输入"];
        [alert show];
        return;
    }
    
    if([passwordValue isEqualToString:@""])
    {
        [alert setMessage:@"密码未输入"];
        [alert show];
        return;
    }
    
    if(![passwordValue isEqualToString:repasswordValue])
    {
        [alert setMessage:@"两次输入的密码不一致"];
        [alert show];
        return;
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    
    NSString *api_url = [BWCommon getBaseInfo:@"api_url"];
    
    NSString *url =  [api_url stringByAppendingString:@"user/addUser"];
    
    NSDictionary *postData = @{@"username":usernameValue,@"password":passwordValue,@"repassword":repasswordValue,@"mobile":mobileValue,@"email":emailValue};
    
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        
        NSLog(@"%@",responseObject);
        
        [hud removeFromSuperview];
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        if (errNo > 0) {
            [alert setMessage:[responseObject objectForKey:@"error"]];
            [alert show];
        }
        else
        {
            
            [alert setMessage:[responseObject objectForKey:@"error"]];
            [alert show];
            //NSDictionary *data = [responseObject objectForKey:@"data"];
            
            //NSUserDefaults *udata = [NSUserDefaults standardUserDefaults];
            //udata = [data copy];
            //[udata setObject:[data objectForKey:@"uid"] forKey:@"uid"];
            
            NSString *uid = [[[responseObject objectForKey:@"data"] objectForKey:@"id"] stringValue];
            NSString *user_key = [[responseObject objectForKey:@"data"] objectForKey:@"user_key"];
            
            [BWCommon setUserInfo:@"uid" value:uid];
            [BWCommon setUserInfo:@"username" value:usernameValue];
            
            [BWCommon setUserInfo:@"user_key" value:user_key];
            [BWCommon setUserInfo:@"password" value:passwordValue];
            [BWCommon setUserInfo:@"mobile" value:mobileValue];
            
            [BWCommon setUserInfo:@"status" value:@"verify"];
            ApplyViewController *applyView = [[ApplyViewController alloc] init];
            
            [self.navigationController pushViewController:applyView animated:YES];

            
            //[self backTouched:nil];
            
            //NSLog(@"%@",udata);
        }

    } fail:^{
        
        [hud removeFromSuperview];
        [alert setMessage:@"网络连接超时"];
        [alert show];
        
        NSLog(@"请求失败");
    }];
    
    
}

- (void) setTextFieldCenter:(NSArray *) items{
    
    NSInteger i = 0;
    
    for (i=0; i<[items count]; i++) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:[items objectAtIndex:i] attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    }
    
}

- (UITextField *) createTextField:(NSString *)image Title:(NSString *) title{
    
    UITextField * field = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 270, 50)];
    field.borderStyle = UITextBorderStyleRoundedRect;
    [field.layer setCornerRadius:5.0];
    field.placeholder = title;
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    field.leftView = icon;
    field.leftViewMode = UITextFieldViewModeAlways;
    field.translatesAutoresizingMaskIntoConstraints = NO;
    field.delegate = self;
    
    return field;
}

- (void) applyTouched:(id)sender
{
    
    //临时测试用
    [BWCommon setUserInfo:@"password" value:@"hj1234567"];
    
    ApplyViewController * applyView = [[ApplyViewController alloc] init];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController pushViewController:applyView animated:YES];
    
    NSLog(@"apply touched");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    [textField resignFirstResponder];
    return YES;
}

// 点击隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}


//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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
