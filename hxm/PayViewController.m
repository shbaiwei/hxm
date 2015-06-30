//
//  PayViewController.m
//  hxm
//
//  Created by Bruce on 15-7-1.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "PayViewController.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"
#import "PayWebViewController.h"

@interface PayViewController ()

@property (nonatomic,retain) UIScrollView *sclView;
@property (nonatomic,retain) UITextField *numberField;

@end

@implementation PayViewController
CGSize size;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
}

- (void) pageLayout{
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    sclView.backgroundColor = [UIColor whiteColor];
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width,size.height);
    self.sclView = sclView;
    
    [self.view addSubview:sclView];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.image=[UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem=backItem;
    
    self.view.backgroundColor = [BWCommon getBackgroundColor];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title = @"账户充值";
    
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 160)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.sclView addSubview:baseView];
    
    UIImageView *icon1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finance-2.png"]];
    icon1.frame = CGRectMake(10, 10, 30, 30);
    [baseView addSubview:icon1];
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 16, 200, 20)];
    title1.text = @"账户充值";
    title1.font = [UIFont systemFontOfSize:16];
    [baseView addSubview:title1];
    
    
    NSInteger y = 50;
    UIView * rowNumber = [self createFieldRow:@"充值金额："];
    rowNumber.frame = CGRectMake(40, y, size.width - 40, 40);
    //[BWCommon setBottomBorder:rowNumber color:[BWCommon getBorderColor]];
    [baseView addSubview:rowNumber];
    
    UITextField *numberField = [[UITextField alloc] initWithFrame:CGRectMake(80, 5, size.width - 150, 30)];
    [rowNumber addSubview:numberField];
    numberField.keyboardType = UIKeyboardTypeNumberPad;
    numberField.placeholder = @"如：100";
    numberField.layer.borderWidth = 1.0f;
    numberField.layer.cornerRadius = 2.0f;
    numberField.layer.borderColor = [BWCommon getBorderColor].CGColor;
    numberField.textAlignment = NSTextAlignmentCenter;
    
    self.numberField = numberField;

    y+=60;
    UIButton *wireInButton = [self footerButton:@"充值" bgColor:[BWCommon getRedColor]];
    wireInButton.frame = CGRectMake(20, y, size.width-40, 40);
    [baseView addSubview:wireInButton];
    
    [wireInButton addTarget:self action:@selector(wireInTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    // very important make delegate useful
    tap.delegate = self;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
    //[self.password resignFirstResponder];
}

-(void) wireInTouched:(id) sender{


    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"account/pay"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"account/pay"];
    
    
    NSString *price = self.numberField.text;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统提示" message:@"请先输入充值金额" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    if([price isEqual:@""])
    {
        
        [alert show];
        return;
    }
    
    
    [postData setValue:[BWCommon getUserInfo:@"uid"] forKey:@"uniqueid"];
    [postData setValue:[BWCommon getUserInfo:@"hxm_uid"] forKey:@"user_id"];
    [postData setValue:[BWCommon getUserInfo:@"billauth"] forKey:@"billauth"];
    [postData setValue:@"directPay" forKey:@"bankId"];
    [postData setValue:price forKey:@"price"];
    
    NSLog(@"%@",postData);
    //load data
    
    
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        
        NSLog(@"%@",responseObject);
        [hud removeFromSuperview];
        if(errNo == 0)
        {
            
            //NSLog(@"%@",json);
            
            NSString *payUrl = [[responseObject objectForKey:@"data"] objectForKey:@"url"];
            
            PayWebViewController *webView = [[PayWebViewController alloc] init];
            webView.surl = payUrl;
            
            [self.navigationController pushViewController:webView animated:YES];

        }
        else
        {
            NSLog(@"%@",[responseObject objectForKey:@"error"]);
            [alert setMessage:[responseObject objectForKey:@"error"]];
            [alert show];
        }
        
    } fail:^{
        [hud removeFromSuperview];
        NSLog(@"请求失败");
        [alert setMessage:@"连接超时，请重试"];
        [alert show];
    }];
    
    
}

-(UIButton *) footerButton: (NSString *) title bgColor : (UIColor *) bgColor {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:5.0];
    //button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = bgColor;
    button.tintColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (UIView *) createFieldRow:(NSString *) title{
    
    UIView * row = [[UIView alloc] init];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 80, 20)];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [row addSubview:titleLabel];
    return row;
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
