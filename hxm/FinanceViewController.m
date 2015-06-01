//
//  FinanceViewController.m
//  hxm
//
//  Created by Bruce on 15-6-1.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "FinanceViewController.h"
#import "BWCommon.h"
#import "MJRefresh.h"
#import "AFNetworkTool.h"

@interface FinanceViewController ()

@end

@implementation FinanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
}

-(void) pageLayout{
    self.navigationItem.title = @"财务管理";
    
    UIColor *bgColor = [BWCommon getBackgroundColor];
    
    self.view.backgroundColor = bgColor;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    sclView.backgroundColor = [BWCommon getBackgroundColor];
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width,900);

    [self.view addSubview:sclView];
    
    UIImageView *icon1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finace-1.png"]];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:icon1];
    
    [sclView addSubview:headerView];
    
    
}


- (void) loadData:(void(^)()) callback
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"account/getAccountInfoById"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"account/getAccountInfoById"];
    
    NSLog(@"%@",url);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        
        NSLog(@"%@",responseObject);
        [hud removeFromSuperview];
        if(errNo == 0)
        {
            
            //NSLog(@"%@",json);
            
            
            
            if(callback){
                callback();
            }
            
            [self.tableView reloadData];
        }
        else
        {
            NSLog(@"%@",[responseObject objectForKey:@"error"]);
        }
        
    } fail:^{
        [hud removeFromSuperview];
        NSLog(@"请求失败");
    }];
    
    
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
