//
//  MyBusinessInfoViewController.m
//  hxm
//
//  Created by spring on 15/5/28.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "MyBusinessInfoViewController.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"


@interface MyBusinessInfoViewController ()
{
    UITextField *body_type;
    UITextField *business_hour;
    UITextField *business_week;
    CGSize size;
    MBProgressHUD *hud;
}

@property (nonatomic,retain) UIScrollView *sclView;
@property (nonatomic,assign) NSUInteger body_type_id;
@end

@implementation MyBusinessInfoViewController

@synthesize userinfo;
@synthesize business_types;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"营业信息";
    [self pageLayout];
    [self initData];
    // Do any additional setup after loading the view.
}

- (void)pageLayout
{
    UIColor *bgColor = [BWCommon getBackgroundColor];
    self.view.backgroundColor = bgColor;
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    
    [self.navigationController.navigationBar setBarTintColor:[BWCommon getMainColor]];

    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    sclView.backgroundColor = bgColor;
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width, size.height);
    [self.view addSubview:sclView];
    
    self.sclView = sclView;
    
    [sclView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getUserInfo)];
    
    body_type = [self createTextFieldWithTitle:@"主营类型："];
    body_type.tag=1;

    business_hour = [self createTextFieldWithTitle:@"营业时间："];

    business_week = [self createTextFieldWithTitle:@"营业周期："];
    
    [sclView addSubview:body_type];
    [sclView addSubview:business_hour];
    [sclView addSubview:business_week];
    
    [self setPickerView:body_type];
    
    UIButton *submitButton = [self footerButton:@"保 存" bgColor:[BWCommon getRedColor]];
    [submitButton addTarget:self action:@selector(do_save:) forControlEvents:UIControlEventTouchUpInside];
    
    [sclView addSubview:submitButton];
    
    
    NSUInteger width = size.width - 40;
    
    NSArray *constraints1= [NSLayoutConstraint constraintsWithVisualFormat:[self createFormat:@"body_type" width:width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(body_type)];
    NSArray *constraints2= [NSLayoutConstraint constraintsWithVisualFormat:[self createFormat:@"business_hour" width:width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(business_hour)];
    NSArray *constraints3= [NSLayoutConstraint constraintsWithVisualFormat:[self createFormat:@"business_week" width:width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(business_week)];

    NSArray *constraints9= [NSLayoutConstraint constraintsWithVisualFormat:[self createFormat:@"submitButton" width:width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(submitButton)];
    
    NSArray *constraintsV= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[body_type(==50)]-10-[business_hour(==50)]-10-[business_week(==50)]-20-[submitButton(==50)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(body_type,business_hour,business_week,submitButton)];
    
    
    [sclView addConstraints:constraints1];
    [sclView addConstraints:constraints2];
    [sclView addConstraints:constraints3];

    [sclView addConstraints:constraints9];
    [sclView addConstraints:constraintsV];
    
    business_types = [BWCommon getDataInfo:@"business"];
    
    NSLog(@"%@",business_types);
    
    [self getUserInfo];

}

- (NSString *) createFormat:(NSString *) name  width:( NSUInteger ) width{
    
    return [NSString stringWithFormat:@"H:|-20-[%@(==%ld)]-20-|",name,width];
}


- (void)initData
{
    
    
    body_type.text = [business_types objectForKey:self.userinfo[@"body_type"]];
    business_hour.text = self.userinfo[@"business_hour"];
    business_week.text = self.userinfo[@"business_week"];


}



- (void) setPickerView:(UITextField *) field{
    
    //下拉
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.tag = field.tag;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouched:)];
    
    [toolBar setItems:[NSArray arrayWithObjects:cancelButton,[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],doneButton,nil ]];
    field.inputView = pickerView;
    field.inputAccessoryView = toolBar;
}


- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    if(pickerView.tag == 1){
        
        return 1;
    }
    
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //return [self.items count];
    
    if(pickerView.tag == 1)
    {
        return [business_types count];
    }
    
    return 0;
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //return [self.items objectAtIndex:row];
    
    if(pickerView.tag == 1)
    {
        if(component == 0){
            return [[business_types allValues] objectAtIndex:row];

        }
    }
    
    return @"";
}


-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if(pickerView.tag == 1)
    {
        if(component == 0){
            
            
            self.body_type_id = [[[business_types allKeys] objectAtIndex:row] integerValue];
            body_type.text = [[business_types allValues] objectAtIndex:row];

        }

    }
    
}


-(void)doneTouched:(id)sender{
    
    if([body_type resignFirstResponder] == YES){
        [body_type resignFirstResponder];
    }

    
}
-(void) cancelTouched:(id)sender{
    
    [body_type resignFirstResponder];
}




- (void) getUserInfo
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"user/getUserInfoById"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"user/getUserInfoById"];
    
    NSString *user_id = [BWCommon getUserInfo:@"uid"];
    NSLog(@"uid:%@",user_id);
    [postData setValue:[NSString stringWithFormat:@"%@",user_id] forKey:@"uid"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    
    NSLog(@"%@",url);
    //load data
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        // NSLog(@"userinfo:%@",responseObject);
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        [hud removeFromSuperview];
        [self.sclView.header endRefreshing];
        if(errNo == 0)
        {
            self.userinfo = [[responseObject objectForKey:@"data"] mutableCopy];
            [self initData];
        }
        else
        {
            NSLog(@"%@",[responseObject objectForKey:@"error"]);
            [alert setMessage:[responseObject objectForKey:@"error"]];
        }
        
    } fail:^{
        [hud removeFromSuperview];
        [self.sclView.header endRefreshing];
        NSLog(@"请求失败");
        [alert setMessage:@"连接超时，请重试"];
    }];
    
    
}

- (void)do_save:(id *)sender
{
    NSLog(@"save action");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统提示" message:@"系统信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"user/saveContactInfo"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"user/saveContactInfo"];
    
    [postData setValue:@"2" forKey:@"body_type"];
    [postData setValue:business_hour.text forKey:@"business_hour"];
    [postData setValue:business_week.text forKey:@"business_week"];
    NSLog(@"%@",url);
    NSLog(@"postData:%@",postData);
    //load data
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSLog(@"responseObject:%@",responseObject);
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        [hud removeFromSuperview];
        if(errNo == 0)
        {
            //处理成功
            alert.message = @"营业信息修改成功";
            [alert show];
            
        }
        else
        {
            alert.message = [responseObject objectForKey:@"error"];
            [alert show];
            NSLog(@"%@",[responseObject objectForKey:@"error"]);
        }
        
    } fail:^{
        [hud removeFromSuperview];
        alert.message = @"请求失败";
        [alert show];
        NSLog(@"请求失败");
    }];

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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (UITextField *) createTextFieldWithTitle:(NSString *) title{
    
    UITextField * field = [[UITextField alloc] init];
    field.borderStyle = UITextBorderStyleRoundedRect;
    [field.layer setCornerRadius:5.0];
    //field.placeholder = title;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 100, 40)];
    
    label.text = title;
    label.textAlignment = NSTextAlignmentRight;
    field.leftView = label;
    field.leftViewMode = UITextFieldViewModeAlways;
    field.translatesAutoresizingMaskIntoConstraints = NO;
    field.delegate = self;
    
    return field;
}

// tap dismiss keyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    //[self.password resignFirstResponder];
}


#pragma mark - TextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
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
@end
