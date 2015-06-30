//
//  OrderCommentViewController.m
//  hxm
//
//  Created by Bruce He on 15/6/4.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "OrderComplainViewController.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"

@interface OrderComplainViewController ()

@property (nonatomic,weak) UILabel *orderNoValue;
@property (nonatomic,weak) UITextView *contentView;
@property (nonatomic,weak) UIScrollView *sclView;

@end

@implementation OrderComplainViewController

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
    self.navigationItem.title = @"订单投诉";
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    sclView.backgroundColor = [BWCommon getBackgroundColor];
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width,700);
    self.sclView = sclView;
    
    [self.view addSubview:sclView];
    
    NSUInteger padding = 15;
    
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(padding, padding, size.width - padding*2, 200)];
    inputView.layer.cornerRadius = 5.0f;
    inputView.backgroundColor = [UIColor whiteColor];
    

    UITextView *contentView = [[UITextView alloc] initWithFrame:CGRectMake(0, 10, size.width-padding*2, 140)];
    
    [inputView addSubview:contentView];
    
    [sclView addSubview:inputView];
    
    self.contentView = contentView;
    
    contentView.text = @"有什么要说的，尽管吐槽吧～";

    contentView.font = [UIFont systemFontOfSize:16];
    //[contentView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *submitButton = [self footerButton:@"发表投诉" bgColor:[UIColor colorWithRed:219/255.0f green:0/255.0f blue:0 alpha:1]];
    
    [submitButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.frame = CGRectMake(padding, 230, size.width-padding*2 , 40);
    [sclView addSubview:submitButton];
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    // very important make delegate useful
    tap.delegate = self;
    
}




- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}


-(void)doneTouched:(id)sender{
    
    /*if([self.areaText resignFirstResponder] == YES){
     self.areaText.text = [selectedRegions componentsJoinedByString:@" - "];
     [self.areaText resignFirstResponder];
     }*/
    
}
-(void) cancelTouched:(id)sender{
    
    //[self.areaText resignFirstResponder];
}


- (void) buttonTouched:(id)sender{
    
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"complain/addComplain"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"complain/addComplain"];
    
    [postData setValue:order_no forKey:@"order_no"];
    [postData setValue:self.contentView.text forKey:@"content"];
   
    //url = [url stringByAppendingFormat:@"?order_no=%@",order_no ];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"投诉提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
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

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setValue:(NSString *)detailValue{
    order_no = detailValue;
    
}


// tap dismiss keyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    //[self.password resignFirstResponder];
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
