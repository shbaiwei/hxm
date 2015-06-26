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
@interface MyBusinessInfoViewController ()
{
    UITextField *body_type;
    UITextField *business_hour;
    UITextField *business_week;
    CGSize size;
    MBProgressHUD *hud;
}
@end

@implementation MyBusinessInfoViewController

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

    
    UIView *main_view = [[UIView alloc] initWithFrame:CGRectMake(20, 60, size.width, size.height)];
    [self.view addSubview:main_view];
    NSInteger yy = 0;
    
    body_type = [self createTextFieldWithTitle:@"主营类型：" yy:yy];
    yy += 50;
    business_hour = [self createTextFieldWithTitle:@"营业时间：" yy:yy];
    yy += 50;
    business_week = [self createTextFieldWithTitle:@"营业周期：" yy:yy];
    
    [main_view addSubview:body_type];
    [main_view addSubview:business_hour];
    [main_view addSubview:business_week];
    
    UIButton *save_button = [UIButton buttonWithType:UIButtonTypeCustom];
    save_button.frame = CGRectMake(0, business_week.frame.origin.y+business_week.bounds.size.height+30, size.width-40, 40);
    [save_button setTag:30];
    [save_button.layer setMasksToBounds:YES];
    [save_button.layer setCornerRadius:3.0];
    [save_button setTintColor:[UIColor whiteColor]];
    [save_button setBackgroundColor:[UIColor redColor]];
    [save_button setTitle:@"保存" forState:UIControlStateNormal];
    [save_button addTarget:self action:@selector(do_save:) forControlEvents:UIControlEventTouchUpInside];
    [main_view addSubview:save_button];
}

- (void)initData
{
    body_type.text = self.userinfo[@"body_type"];
    business_hour.text = self.userinfo[@"business_hour"];
    business_week.text = self.userinfo[@"business_week"];
   
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"common/getBusinessTypes"];
    
    NSLog(@"%@",url);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:nil success:^(id responseObject) {
        
        NSLog(@"responseObject:%@",responseObject);
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        [hud removeFromSuperview];
        if(errNo == 0)
        {
            _bussiness_types = [responseObject objectForKey:@"data"];
            NSLog(@"all keys:%@",[_bussiness_types allKeys]);
            NSLog(@"all values:%@",[_bussiness_types allValues]);
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

- (UITextField *) createTextFieldWithTitle:(NSString *) title yy:(NSInteger)yy{
    
    UITextField * field = [[UITextField alloc] initWithFrame:CGRectMake(0, yy+10, size.width-40, 40)];
    field.borderStyle = UITextBorderStyleRoundedRect;
    [field.layer setCornerRadius:5.0];
    //field.placeholder = title;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 100, 40)];
    
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    field.leftView = label;
    field.leftViewMode = UITextFieldViewModeAlways;
    field.translatesAutoresizingMaskIntoConstraints = NO;
    field.delegate = self;
    
    return field;
}

#pragma mark - TextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:body_type]) {
        //NSLog(@"122222222");
        //[_bussiness_types objectAtIndex:1];
        
        UIActionSheet *acsheet = [[UIActionSheet alloc] initWithTitle:@"选择主营类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        
        [acsheet addButtonWithTitle:@"Item A"];
        [acsheet addButtonWithTitle:@"Item B"];
        [acsheet addButtonWithTitle:@"Item C"];
        [acsheet showInView:self.view];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    }

#pragma mark - actionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"index:%ld",(long)buttonIndex);
}
@end
