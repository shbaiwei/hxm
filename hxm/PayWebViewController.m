//
//  PayWebViewController.m
//  hxm
//
//  Created by Bruce on 15-7-1.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "PayWebViewController.h"

@interface PayWebViewController ()

@end

@implementation PayWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title = @"账户充值";
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    protWebView = [ [UIWebView alloc] initWithFrame:self.view.bounds];
    
    protWebView.delegate = self;

    NSString *payUrl = [self.surl stringByReplacingOccurrencesOfString:@"http://www.huaji.com/" withString:@"http://hj.s10.baiwei.org/"];
    NSURL *url = [[NSURL alloc]initWithString:payUrl];
    
    [protWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.view addSubview:protWebView];
    
}

//几个代理方法

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    NSLog(@"webViewDidStartLoad");
    
}

- (void)webViewDidFinishLoad:(UIWebView *)web{
    
    NSLog(@"webViewDidFinishLoad");
    
}

-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error{
    
    NSLog(@"DidFailLoadWithError");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
