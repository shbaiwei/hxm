//
//  OrderCommentViewController.m
//  hxm
//
//  Created by Bruce He on 15/6/4.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "OrderNoteViewController.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"

@interface OrderNoteViewController ()

@property (nonatomic,weak) UILabel *orderNoValue;
@property (nonatomic,weak) UIScrollView *sclView;
@property (nonatomic,retain) NSArray *images;
@property (nonatomic,retain) UIButton *flagButton;

@property (nonatomic, weak) UITextView *noteView;

@end

@implementation OrderNoteViewController

NSString *order_no;
NSUInteger tmp_flag_id;
NSUInteger flag_id;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
}

- (void) pageLayout{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title = @"订单备注";
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    sclView.backgroundColor = [BWCommon getBackgroundColor];
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width,700);
    self.sclView = sclView;
    
    [self.view addSubview:sclView];
    
    NSUInteger padding = 15;
    
    tmp_flag_id = 1;
    flag_id = 1;
    
    NSUInteger height = 20;
    
    UIImage *flag1 = [UIImage imageNamed:@"op_memo_1"];
    UIImage *flag2 = [UIImage imageNamed:@"op_memo_2"];
    UIImage *flag3 = [UIImage imageNamed:@"op_memo_3"];
    UIImage *flag4 = [UIImage imageNamed:@"op_memo_4"];
    UIImage *flag5 = [UIImage imageNamed:@"op_memo_5"];
    
    self.images = [NSArray arrayWithObjects:flag1,flag2,flag3,flag4,flag5, nil];
    
    UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, 80, height)];
    flagLabel.text = @"标     记：";
    
    
    UIButton *flagButton = [[UIButton alloc] initWithFrame:CGRectMake(padding+80, padding, 60, 20)];
    [flagButton setBackgroundImage:[UIImage imageNamed:@"op_memo_1"] forState:UIControlStateNormal];
    
    [flagButton addTarget:self action:@selector(pickerViewTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    self.flagButton = flagButton;
    
    [self.sclView addSubview:flagLabel];
    [self.sclView addSubview:flagButton];
    
    
    UILabel *orderNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding*2+height, 80, 20)];
    UILabel *orderNoValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding+80, padding*2+height, 200, 20)];
    
    orderNoLabel.text = @"订单编号：";
    orderNoLabel.font = [UIFont systemFontOfSize:16];
    
    self.orderNoValue = orderNoValueLabel;
    self.orderNoValue.text = order_no;
    
    
    [sclView addSubview:orderNoLabel];
    [sclView addSubview:orderNoValueLabel];
    
    UITextView *noteView = [[UITextView alloc] initWithFrame:CGRectMake(padding, 90, size.width-padding*2, 120)];
    
    [sclView addSubview:noteView];
    
    self.noteView = noteView;
    
    noteView.text = @"输入备注的内容";
    
    noteView.layer.cornerRadius = 5.0f;
    noteView.layer.borderWidth = 1.0f;
    noteView.font = [UIFont systemFontOfSize:16];
    [noteView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [noteView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *submitButton = [self footerButton:@"提交备注" bgColor:[UIColor colorWithRed:219/255.0f green:0/255.0f blue:0 alpha:1]];
    
    [submitButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.frame = CGRectMake(padding, 230, size.width-padding*2 , 40);
    [sclView addSubview:submitButton];
    
    
    [self loadData:order_no callback:^{}];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    // very important make delegate useful
    tap.delegate = self;
}


- (void) loadData:(NSString *) order_no callback:(void(^)()) callback{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"order/getOrderInfoById"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"order/getOrderInfoById"];
    
    [postData setValue:order_no forKey:@"order_no"];
    
    NSLog(@"%@",order_no);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        [hud removeFromSuperview];
        if(errNo == 0)
        {
            
            NSLog(@"%@",[responseObject objectForKey:@"data"]);
            
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            NSString *buyer_memo = [data objectForKey:@"buyer_memo"];
            if([buyer_memo  isEqual: [NSNull null]]){
                buyer_memo = @"";
            }
            
            self.noteView.text = buyer_memo;
            
            NSInteger buyer_memo_flag = [[data objectForKey:@"buyer_memo_flag"] integerValue];
            buyer_memo_flag = buyer_memo_flag < 1? 1 : buyer_memo_flag;
            flag_id = buyer_memo_flag;
            [self.flagButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"op_memo_%ld",flag_id]] forState:UIControlStateNormal];
            
            if(callback){
                callback();
            }
            
            //NSLog(@"%@",json);
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




- (void) pickerViewTouched:(id)sender{
    
    //下拉
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;

    UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
  
    UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        flag_id = tmp_flag_id;
        [self.flagButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"op_memo_%ld",flag_id]] forState:UIControlStateNormal];

    }];
    
    UIAlertAction* no=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    [alertVc.view addSubview:pickerView];
    [alertVc addAction:ok];
    [alertVc addAction:no];
    [self presentViewController:alertVc animated:YES completion:nil];
}


- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //return [self.items count];
    

            
        //return [provinceData count];
    return  [self.images count];

}

#define kImageTag 1
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    // 如果可重用的view的tag不等于kImageTag，表明该view已经不存在，需要重新创建
    if(view.tag != kImageTag)
    {
        view = [[UIImageView alloc] initWithImage:[self.images objectAtIndex:row]];
        // 为该UIView设置tag属性
        view.tag = kImageTag;
        // 设置不允许用户交互
        view.userInteractionEnabled = NO;
    }
    return view;
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    tmp_flag_id = row + 1;
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
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"order/addRemark"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"order/addRemark"];

    
    [postData setValue:[NSString stringWithFormat:@"%ld",flag_id ] forKey:@"buyer_memo_flag"];
    [postData setValue:self.noteView.text forKey:@"buyer_memo"];
    
    url = [url stringByAppendingFormat:@"?order_no=%@",order_no ];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"备注提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
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
