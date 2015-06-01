//
//  MyContactWayViewController.m
//  
//
//  Created by spring on 15/5/28.
//
//

#import "MyContactWayViewController.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"

@interface MyContactWayViewController ()
{
    UITextField *link_man;
    UITextField *link_mobile;
    UITextField *link_phone;
    UITextField *link_email;
    UITextField *link_qq;
    UITextField *link_fax;
    UITextField *link_prov_id;
    UITextField *link_city_id;
    UITextField *link_dist_id;
    UITextField *link_address;
    CGSize size;
}
@end

@implementation MyContactWayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系方式";
    // Do any additional setup after loading the view.
    [self pageLayout];
    [self initData];
}

//初始化数据
- (void) initData
{
    link_man.text = [_userinfo objectForKey:@"link_man"];
    link_mobile.text = [_userinfo objectForKey:@"link_mobile"];
    link_phone.text = [_userinfo objectForKey:@"link_phone"];
    link_email.text = [_userinfo objectForKey:@"link_email"];
    link_qq.text = [_userinfo objectForKey:@"link_qq"];
    link_fax.text = [_userinfo objectForKey:@"link_fax"];
    link_address.text = [_userinfo objectForKey:@"link_address"];
}

//初始化界面
- (void)pageLayout
{
    UIColor *bgColor = [BWCommon getBackgroundColor];
    self.view.backgroundColor = bgColor;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    
    UIView *main_view = [[UIView alloc] initWithFrame:CGRectMake(20, 60, size.width, size.height)];
    [self.view addSubview:main_view];
    NSInteger yy = 0;
    link_man = [self createTextFieldWithTitle:@"姓    名：" yy:yy];
    yy += 50;
    link_mobile = [self createTextFieldWithTitle:@"手    机：" yy:yy];
    yy += 50;
    link_phone = [self createTextFieldWithTitle:@"固定电话：" yy:yy];
    yy += 50;
    link_email = [self createTextFieldWithTitle:@"E-mail：" yy:yy];
    yy += 50;
    link_qq = [self createTextFieldWithTitle:@"Q Q：" yy:yy];
    yy += 50;
    link_fax = [self createTextFieldWithTitle:@"传     真：" yy:yy];
    yy += 50;
    link_address = [self createTextFieldWithTitle:@"街道地址：" yy:yy];
    [main_view addSubview:link_man];
    [main_view addSubview:link_mobile];
    [main_view addSubview:link_phone];
    [main_view addSubview:link_email];
    [main_view addSubview:link_qq];
    [main_view addSubview:link_fax];
    [main_view addSubview:link_address];
    
    UIButton *save_button = [UIButton buttonWithType:UIButtonTypeCustom];
    save_button.frame = CGRectMake(0, link_address.frame.origin.y+link_address.bounds.size.height+30, size.width-40, 40);
    [save_button setTag:30];
    [save_button.layer setMasksToBounds:YES];
    [save_button.layer setCornerRadius:3.0];
    [save_button setTintColor:[UIColor whiteColor]];
    [save_button setBackgroundColor:[UIColor redColor]];
    [save_button setTitle:@"保存" forState:UIControlStateNormal];
    [save_button addTarget:self action:@selector(do_save:) forControlEvents:UIControlEventTouchUpInside];
    [main_view addSubview:save_button];
}

- (void)do_save:(id *)sender
{
    NSLog(@"save action");
    MBProgressHUD *hud;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"user/saveContactInfo"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"user/saveContactInfo"];
    
    NSString *user_id = [BWCommon getUserInfo:@"uid"];
    [postData setValue:[NSString stringWithFormat:@"%@",user_id] forKey:@"uid"];
    [postData setValue:[NSString stringWithFormat:@"%@",link_man.text] forKey:@"link_man"];
    [postData setValue:[NSString stringWithFormat:@"%@",link_mobile.text] forKey:@"link_mobile"];
    [postData setValue:[NSString stringWithFormat:@"%@",link_phone.text] forKey:@"link_phone"];
    [postData setValue:[NSString stringWithFormat:@"%@",link_email.text] forKey:@"link_email"];
    [postData setValue:[NSString stringWithFormat:@"%@",link_qq.text] forKey:@"link_qq"];
    [postData setValue:[NSString stringWithFormat:@"%@",link_fax.text] forKey:@"link_fax"];
    [postData setValue:[NSString stringWithFormat:@"%@",link_address.text] forKey:@"link_address"];
    
    
    NSLog(@"%@",url);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        // NSLog(@"userinfo:%@",responseObject);
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        [hud removeFromSuperview];
        if(errNo == 0)
        {
            //处理成功
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"资料修改成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        
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
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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

@end
