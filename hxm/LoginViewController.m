//
//  LoginViewController.m
//
//
//  Created by Bruce He on 15-5-14.
//
//  25f485432617ab64b329a96da3190d3e
//  1288143826
//  regtime 1432049330

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ApplyViewController.h"
#import "AFNetworkTool.h"
#import "BWCommon.h"

@interface LoginViewController () 

@end

@implementation LoginViewController

UITextField *username;
UITextField *password;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //NSLog(@"%@",[BWCommon md5:@"123456"]);
    
    [self pageLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) registerTouched:(id)sender
{
    
    RegisterViewController * registerView = [[RegisterViewController alloc] init];
    
    [self.navigationController pushViewController:registerView animated:YES];
        
    NSLog(@"register touched");
}

- (void)pageLayout {
    
    UIColor *bgColor = [BWCommon getBackgroundColor];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.image=[UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem=backItem;
    
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    sclView.backgroundColor = bgColor;
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width, size.height);
    [self.view addSubview:sclView];

    
    
    UIImage *logo = [UIImage imageNamed:@"logo.png"];
    UIImageView *ivLogo = [[UIImageView alloc] initWithImage:logo];
    
    ivLogo.translatesAutoresizingMaskIntoConstraints = NO;
    [sclView addSubview:ivLogo];
    
    username = [self createTextField:@"login-user.png" Title:@""];
    [sclView addSubview:username];
    username.delegate = self;
    self.username = username;
    
    password = [self createTextField:@"login-password.png" Title:@""];
    password.secureTextEntry = YES;
    password.delegate = self;
    [sclView addSubview:password];
    self.password = password;
    
    
    UIButton *btnLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnLogin.frame = CGRectMake(0, 0, 270, 50);
    [btnLogin.layer setMasksToBounds:YES];
    [btnLogin.layer setCornerRadius:5.0];
    btnLogin.translatesAutoresizingMaskIntoConstraints = NO;
    btnLogin.backgroundColor = [UIColor colorWithRed:116/255.0 green:197/255.0 blue:67/255.0 alpha:1];
    btnLogin.tintColor = [UIColor whiteColor];
    btnLogin.titleLabel.font = [UIFont systemFontOfSize:22];
    
    [btnLogin setTitle:@"登 录" forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(loginTouched:) forControlEvents:UIControlEventTouchUpInside];
    [sclView addSubview:btnLogin];
    
    UIView *actionView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 270, 20)];
    actionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [sclView addSubview:actionView];
//注册连接
    
    UIButton *btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    [btnRegister setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btnRegister.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnRegister setTitle:@"注册账号" forState:UIControlStateNormal];
    [btnRegister addTarget:self action:@selector(registerTouched:)forControlEvents:UIControlEventTouchUpInside];
    [actionView addSubview:btnRegister];
    
    
    UIButton *btnForget = [[UIButton alloc] initWithFrame:CGRectMake(190, 0, 80, 20)];
    [btnForget setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btnForget.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnForget setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [btnForget addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [actionView addSubview:btnForget];
    
    NSArray *constraints1= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[ivLogo(<=220)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(ivLogo)];
    
    
    NSUInteger mTop = 60;
    if(size.height>700)
        mTop = 120;
    
    NSString * format = [NSString stringWithFormat:@"V:|-%ld-[ivLogo(<=100)]-40-[username(==50)]-10-[password(==50)]-20-[btnLogin(==50)]-10-[actionView(==20)]-60-|",mTop];
        
    NSArray *constraints2= [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:NSDictionaryOfVariableBindings(ivLogo,username,password,btnLogin,actionView)];
    
    NSArray *constraints3= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[username(==270)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(username)];
    
    NSArray *constraints4= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[password(==270)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(password)];
    
    NSArray *constraints5= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[btnLogin(==270)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btnLogin)];
    
    NSArray *constraints6= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[actionView(==270)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(actionView)];
    
    
    [sclView addConstraints:constraints1];
    [sclView addConstraints:constraints2];
    [sclView addConstraints:constraints3];
    [sclView addConstraints:constraints4];
    [sclView addConstraints:constraints5];
    [sclView addConstraints:constraints6];

    
    
    [self setTextFieldCenter:[[NSArray alloc] initWithObjects:ivLogo,password,username,btnLogin,actionView,nil]];
    
    
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



-(void) loginTouched: (id)sender
{
    NSString *usernameValue = username.text;
    NSString *passwordValue = password.text;

    //test user
    usernameValue = @"花满大厦";
    passwordValue = @"hj1234567";

    
    
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
    
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *api_url = [BWCommon getBaseInfo:@"api_url"];
    
    NSString *url =  [api_url stringByAppendingString:@"user/checkUser"];
    
    NSDictionary *postData = @{@"username":usernameValue,@"password":passwordValue};
    
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        
        NSLog(@"%@",responseObject);
        
        [hud removeFromSuperview];
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];

        
        if (errNo > 0) {
            [alert setMessage:[responseObject objectForKey:@"error"]];
            [alert show];
            
            //提交审核信息
            if(errNo == 3){
                
                
                NSString *uid = [[responseObject objectForKey:@"data"] objectForKey:@"user_id"];
                NSString *user_key = [[responseObject objectForKey:@"data"] objectForKey:@"user_key"];
                
                [BWCommon setUserInfo:@"uid" value:uid];
                [BWCommon setUserInfo:@"user_key" value:user_key];
                [BWCommon setUserInfo:@"password" value:passwordValue];
                
                [BWCommon setUserInfo:@"status" value:@"verify"];
                ApplyViewController *applyView = [[ApplyViewController alloc] init];
                [self.navigationController pushViewController:applyView animated:YES];

            }
        }
        else
        {
            
            NSString *uid = [[responseObject objectForKey:@"data"] objectForKey:@"user_id"];
            NSString *user_key = [[responseObject objectForKey:@"data"] objectForKey:@"user_key"];
            
            [BWCommon setUserInfo:@"uid" value:uid];
            [BWCommon setUserInfo:@"user_key" value:user_key];
            //认证通过后清除
            [BWCommon setUserInfo:@"password" value:@""];
            
            [self getHxmUserInfo:uid];
            
        }
        
    } fail:^{
        [hud removeFromSuperview];
        [alert setMessage:@"网络连接超时"];
        [alert show];
        
        NSLog(@"请求失败");
    }];
    
    
}

-(void) getHxmUserInfo:(NSString *) uid{
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"user/getHxmUserInfo"];
    
    NSDictionary *postData = @{@"uniqueid":uid};
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        if (errNo > 0) {
            [alert setMessage:[responseObject objectForKey:@"error"]];
            [alert show];
        }
        else{
            //记录好香美ID
            [BWCommon setUserInfo:@"hxm_uid" value:[[responseObject objectForKey:@"data"] objectForKey:@"user_id"]];
            [BWCommon setUserInfo:@"user_key" value:[[responseObject objectForKey:@"data"] objectForKey:@"user_key"]];
            

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            id mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainIdentifier"];
            [self presentViewController:mainViewController animated:YES completion:^{}];
        }
        
    } fail:^{
        NSLog(@"访问失败");
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - <UITextFeildDeletage>

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
@end
