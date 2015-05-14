//
//  LoginViewController.m
//
//
//  Created by Bruce He on 15-5-14.
//
//

#import "LoginViewController.h"
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

- (void)pageLayout {
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:250/255.0f alpha:1];
    
    //logo
    UIImage *logo = [UIImage imageNamed:@"logo.png"];
    UIImageView *ivLogo = [[UIImageView alloc] initWithImage:logo];
    
    [self.view addSubview:ivLogo];
    
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
