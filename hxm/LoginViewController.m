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
    
//注册连接
    
    UIButton *btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 80, 30)];
    btnRegister.tintColor = [UIColor grayColor];
    [btnRegister setTitle:@"注册账号" forState:UIControlStateNormal];
    [btnRegister addTarget:self action:@selector(registerTouched:)forControlEvents:UIControlEventTouchUpInside];
    [sclView addSubview:btnRegister];
    
    
    NSArray *constraints1= [NSLayoutConstraint constraintsWithVisualFormat:@"|-[ivLogo(<=220)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(ivLogo)];
    NSArray *constraints2= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[ivLogo(<=100)]-40-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(ivLogo)];
    
    [sclView addConstraints:constraints1];
    [sclView addConstraints:constraints2];
    
    //水平居中
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:ivLogo attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    
    
    

    
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
