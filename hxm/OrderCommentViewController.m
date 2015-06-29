//
//  OrderCommentViewController.m
//  hxm
//
//  Created by Bruce He on 15/6/4.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "OrderCommentViewController.h"
#import "BWCommon.h"
#import "LDXScore.h"
#import "AFNetworkTool.h"

@interface OrderCommentViewController ()

@property (nonatomic,weak) UILabel *orderNoValue;

@property (nonatomic, weak) UITextView *commentView;

@property (nonatomic,weak) UIScrollView *sclView;

@property (nonatomic,retain) LDXScore *starView;

@end

@implementation OrderCommentViewController

NSString *order_no;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
}

- (void) pageLayout{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title = @"订单评论";
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    sclView.backgroundColor = [BWCommon getBackgroundColor];
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width,size.height);
    self.sclView = sclView;
    
    [self.view addSubview:sclView];
    
     NSUInteger padding = 15;
    
    LDXScore *starView = [[LDXScore alloc] initWithFrame:CGRectMake(padding,padding,140,50)];
    
    self.starView = starView;
    starView.normalImg = [UIImage imageNamed:@"btn_star_evaluation_normal"];
    starView.highlightImg = [UIImage imageNamed:@"btn_star_evaluation_press"];
    starView.isSelect = YES;
    starView.padding = 0;
    starView.layer.cornerRadius = 10;
    starView.layer.masksToBounds = YES;
    
    [sclView addSubview:starView];

    
   
    UILabel *orderNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding+50, 80, 20)];
    UILabel *orderNoValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding+80, padding+50, 200, 20)];

    orderNoLabel.text = @"订单编号：";
    orderNoLabel.font = [UIFont systemFontOfSize:16];

    self.orderNoValue = orderNoValueLabel;
    self.orderNoValue.text = order_no;
    
    
    [sclView addSubview:orderNoLabel];
    [sclView addSubview:orderNoValueLabel];
    
    UITextView *commentView = [[UITextView alloc] initWithFrame:CGRectMake(padding, 110, size.width-padding*2, 120)];
    
    [sclView addSubview:commentView];
    
    commentView.text = @"输入评论的内容";
    commentView.font = [UIFont systemFontOfSize:16];
    
    commentView.layer.cornerRadius = 5.0f;
    commentView.layer.borderWidth = 1.0f;
    [commentView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    self.commentView = commentView;
    
    
    [commentView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *submitButton = [self footerButton:@"提交评论" bgColor:[UIColor colorWithRed:219/255.0f green:0/255.0f blue:0 alpha:1]];
    
    [submitButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.frame = CGRectMake(padding, 250, size.width-padding*2 , 40);
    [sclView addSubview:submitButton];


}

- (void) buttonTouched:(id)sender{
    

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"order/addComment"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"order/addComment"];
    
    
    
    
    [postData setValue:[NSString stringWithFormat:@"%d",self.starView.show_star ] forKey:@"comment_rate"];
    [postData setValue:self.commentView.text forKey:@"comment_content"];
    
    url = [url stringByAppendingFormat:@"?order_no=%@",order_no ];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"点评提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    NSLog(@"%@",postData);
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        // NSLog(@"userinfo:%@",responseObject);
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        [hud removeFromSuperview];
        if(errNo == 0)
        {
            //处理成功
            [alert show];
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(UIButton *) footerButton: (NSString *) title bgColor : (UIColor *) bgColor {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:5.0];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = bgColor;
    button.tintColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setValue:(NSString *)detailValue{
    order_no = detailValue;
    
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
