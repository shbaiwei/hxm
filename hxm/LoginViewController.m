//
//  LoginViewController.m
//
//
//  Created by Bruce He on 15-5-14.
//
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AFNetworkTool.h"
#import "BWCommon.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) registerTouched:(id)sender
{
    
    RegisterViewController * registerView = [[RegisterViewController alloc] init];
    
    [self presentViewController:registerView animated:YES completion:^(void){
        
        NSString *username = [BWCommon getUserInfo:@"username"];
        if(username != nil){
            //注册成功
        }
        NSLog(@"register view closed");
    }];
    
    NSLog(@"register touched");
}

- (void)pageLayout {
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:250/255.0f alpha:1];
    
    //logo
    UIImage *logo = [UIImage imageNamed:@"logo.png"];
    UIImageView *ivLogo = [[UIImageView alloc] initWithImage:logo];
    ivLogo.frame = CGRectMake(50, 100, 220, 100);
    ivLogo.contentMode = UIViewContentModeCenter;
    
    [self.view addSubview:ivLogo];
    
//注册连接
    
    UIButton *btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 80, 30)];
    btnRegister.tintColor = [UIColor grayColor];
    [btnRegister setTitle:@"注册账号" forState:UIControlStateNormal];
    [btnRegister addTarget:self action:@selector(registerTouched:)forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnRegister];

    
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
