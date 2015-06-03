//
//  MyPasswordViewController.m
//  hxm
//
//  Created by spring on 15/5/28.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "MyPasswordViewController.h"
#import "BWCommon.h"
#import "PasswordLoginViewController.h"
#import "PasswordSaleViewController.h"

@interface MyPasswordViewController ()

@end

@implementation MyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"密码管理";
    // Do any additional setup after loading the view.
    [self pageLayout];
}

- (void)pageLayout
{
    
    UIColor *bgColor = [BWCommon getBackgroundColor];
    self.view.backgroundColor = bgColor;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    NSArray *titleArray = [[NSArray alloc] initWithObjects: @"密码管理", @"拍卖密码",nil];
    NSArray *subtitleArray = [[NSArray alloc] initWithObjects: @"互联网账号存在被盗风险，\n建议您定期更改密码以保护帐号安全", @"设置拍卖密码后可以用于登陆拍卖系统",nil];
    NSArray *iconArray =[[NSArray alloc] initWithObjects:@"password-login-icon", @"password-sale-icon",nil];
    NSInteger YY = 0 ;
    YY += 90;
    for(int i = 0; i < titleArray.count; i++)
    {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, YY, size.width-20, 130)];
        button.backgroundColor = [UIColor whiteColor];
        button.tag = 10 + i;
        [button.layer setCornerRadius:3.0];
        [button addTarget:self action:@selector(do_action:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, 70, 70)];
        headImageView.image = [UIImage imageNamed:iconArray[i]];
        [button addSubview:headImageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 130, 44)];
        label.text = titleArray[i];
        //label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:20];
        [button addSubview:label];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 240, 80)];
        label2.text = subtitleArray[i];
        label2.numberOfLines = 0;
       // label2.backgroundColor = [UIColor redColor];
        label2.textColor = [UIColor grayColor];
        label2.font = [UIFont systemFontOfSize:14];
        [button addSubview:label2];
        
        YY += 150;
    }

}

- (void) do_action: (UIButton *)button
{
    if(button.tag==10){
        //密码管理
        PasswordLoginViewController *page = [[PasswordLoginViewController alloc] init];
        page.mobile = self.mobile;
        [self.navigationController pushViewController:page animated:YES];
    }
    else{
        //拍卖密码
        PasswordSaleViewController *page = [[PasswordSaleViewController alloc] init];
        page.mobile = self.mobile;
        [self.navigationController pushViewController:page animated:YES];
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

@end
