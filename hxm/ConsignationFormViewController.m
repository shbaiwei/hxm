//
//  ConsignationFormViewController.m
//  hxm
//
//  Created by Bruce He on 15/6/24.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "ConsignationFormViewController.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"

@interface ConsignationFormViewController ()

@property (nonatomic, weak) UIScrollView *sclView;
@property (nonatomic, weak) UITextField *numberField;
@property (nonatomic, weak) UITextField *priceField;

@end

@implementation ConsignationFormViewController

NSUInteger detail_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pagelayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) pagelayout{

    self.view.backgroundColor = [BWCommon getBackgroundColor];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title = @"委托拍卖";
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;

    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    sclView.backgroundColor = [BWCommon getBackgroundColor];
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width,900);

    self.sclView = sclView;
    [self.view addSubview:sclView];
    
    UIView *formView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 400)];
    //[self.sclView addSubview:formView];
    formView.backgroundColor = [UIColor whiteColor];
    
    UILabel *serialLabel = [[UILabel alloc] init];
    
    [self.sclView addSubview:serialLabel];
    serialLabel.text = [NSString stringWithFormat:@"  序号：%ld",detail_id];
    serialLabel.translatesAutoresizingMaskIntoConstraints = NO;
    serialLabel.font = [UIFont systemFontOfSize:16];
    
    UITextField *numberField = [self createTextField:@"箱数："];
    [self.sclView addSubview:numberField];
    numberField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.numberField = numberField;
    
    UITextField *priceField = [self createTextField:@"委托价格："];
    [self.sclView addSubview:priceField];
    priceField.keyboardType = UIKeyboardTypeDecimalPad;
    priceField.placeholder = @"元/枝";
    
    self.priceField = priceField;
    
    //加入
    UIButton *btnConfirm = [self footerButton:@"确定" bgColor:[UIColor colorWithRed:116/255.0f green:197/255.0f blue:67/255.0f alpha:1]];
    //btnConfirm.frame = CGRectMake(10, 20, 160, 60);
    [self.sclView addSubview: btnConfirm];
    
    [btnConfirm addTarget:self action:@selector(confirmTouched:) forControlEvents:UIControlEventTouchUpInside];


    
    
    NSArray *constraints0= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[serialLabel(==300)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(serialLabel)];

    NSArray *constraints1= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[numberField(==300)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(numberField)];
    
    NSArray *constraints2= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[serialLabel(==30)]-10-[numberField(==50)]-10-[priceField(==50)]-30-[btnConfirm(==50)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(serialLabel,numberField,priceField,btnConfirm)];
    
    NSArray *constraints3= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[priceField(==300)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(priceField)];
    
    NSArray *constraints4= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[btnConfirm(==300)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btnConfirm)];
    
    [self.sclView addConstraints:constraints0];
    [self.sclView addConstraints:constraints1];
    [self.sclView addConstraints:constraints2];
    [self.sclView addConstraints:constraints3];
    [self.sclView addConstraints:constraints4];
    
    
    [self setTextFieldCenter:[[NSArray alloc] initWithObjects:serialLabel,numberField,priceField,btnConfirm,nil]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    // very important make delegate useful
    tap.delegate = self;
    
}


-(void) confirmTouched:(id)sender{
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"delegation/addDelegation"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"delegation/addDelegation"];
    
    [postData setValue:[NSString stringWithFormat:@"%ld",detail_id] forKey:@"id"];
    url = [url stringByAppendingFormat:@"?ent_id=%ld&etr_qty=%@&etr_prc=%@",detail_id,self.numberField.text,self.priceField.text];

    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    NSLog(@"%@",url);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        NSLog(@"%@",responseObject);
        
        if(errNo == 0)
        {
            [alert setMessage:@"委托拍卖保存成功"];
            [alert show];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSLog(@"%@",[responseObject objectForKey:@"error"]);
            [alert setMessage:[responseObject objectForKey:@"error"]];
            [alert show];
        }
        
    } fail:^{
        NSLog(@"请求失败");
        [alert setMessage:@"请求超时"];
        [alert show];
    }];
}

-(UIButton *) footerButton: (NSString *) title bgColor : (UIColor *) bgColor {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:5.0];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = bgColor;
    button.tintColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}


// tap dismiss keyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    //[self.password resignFirstResponder];
}

- (void) setTextFieldCenter:(NSArray *) items{
    
    NSInteger i = 0;
    
    for (i=0; i<[items count]; i++) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:[items objectAtIndex:i] attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    }
    
}

-(void) setValue:(NSUInteger)detailValue{
    
    detail_id =detailValue;
}

- (UITextField *) createTextField:(NSString *) title{
    
    UITextField * field = [[UITextField alloc] init];
    field.borderStyle = UITextBorderStyleRoundedRect;
    [field.layer setCornerRadius:5.0];
    field.clearsOnBeginEditing = YES;
    field.clearButtonMode=UITextFieldViewModeWhileEditing;
    //field.placeholder = title;
    
    UIView *lfView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 80, 30)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 30)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = title;
    
    [lfView addSubview:titleLabel];
    
    field.leftView = lfView;
    
    field.translatesAutoresizingMaskIntoConstraints = NO;
    field.leftViewMode = UITextFieldViewModeAlways;
    field.rightViewMode=UITextFieldViewModeAlways;
    field.delegate = self;
    
    return field;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// 点击隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}


//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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
