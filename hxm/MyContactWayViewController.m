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
    NSInteger link_prov_id;
    NSInteger link_city_id;
    NSInteger link_dist_id;
    UITextField *link_address;
    CGSize size;
}
@end

@implementation MyContactWayViewController

@synthesize areaText;
@synthesize areaValue=_areaValue;
@synthesize locatePicker=_locatePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系方式";
    // Do any additional setup after loading the view.
    [self pageLayout];
    [self initData];
}

-(void)setAreaValue:(NSString *)areaValue
{
    if (![_areaValue isEqualToString:areaValue]) {
        self.areaText.text = areaValue;
    }
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
    areaText.text = [NSString stringWithFormat:@"%@-%@-%@",_userinfo[@"link_prov"],_userinfo[@"link_city"],_userinfo[@"link_dist"]];
    link_prov_id = [_userinfo[@"link_prov_id"] integerValue];
    link_city_id = [_userinfo[@"link_city_id"] integerValue];
    link_dist_id = [_userinfo[@"link_dist_id"] integerValue];
    
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
    link_mobile.keyboardType = UIKeyboardTypeNamePhonePad;
    yy += 50;
    link_phone = [self createTextFieldWithTitle:@"固定电话：" yy:yy];
    yy += 50;
    link_email = [self createTextFieldWithTitle:@"E-mail：" yy:yy];
    link_email.keyboardType = UIKeyboardTypeEmailAddress;
    yy += 50;
    link_qq = [self createTextFieldWithTitle:@"Q Q：" yy:yy];
    link_qq.keyboardType = UIKeyboardTypeNumberPad;
    yy += 50;
    link_fax = [self createTextFieldWithTitle:@"传     真：" yy:yy];
    link_fax.keyboardType = UIKeyboardTypeNumberPad;
    yy += 50;
    areaText = [self createTextFieldWithTitle:@"所在地区：" yy:yy];
    /*
    //所在地区重新定义view
    //areaText = [self createTextFieldWithTitle:@"所在地区：" yy:yy];
    UIView *area_view = [[UIView alloc] init];
    area_view.frame = CGRectMake(0, yy+10, size.width-40, 40);
    area_view.backgroundColor = [UIColor whiteColor];
    [area_view.layer setCornerRadius:3.0];
    [main_view addSubview:area_view];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 0, 80, 40);
    label.text = @"所在地区:";
    [area_view addSubview:label];
    
    UIButton *provice_btn = [[UIButton alloc] init];
    provice_btn.frame = CGRectMake(105, 0, 45, 40);
    [provice_btn setTitle:@"浙江" forState:UIControlStateNormal];
    provice_btn.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [provice_btn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    //provice_btn.backgroundColor = [UIColor redColor];
    provice_btn.tag = 21;
    [provice_btn addTarget:self action:@selector(get_area:) forControlEvents:UIControlEventTouchUpInside];
    [area_view addSubview:provice_btn];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user-address-down-icon"]];
    image.frame = CGRectMake(provice_btn.frame.size.width+provice_btn.frame.origin.x+5, 12, 15, 15);
    [area_view addSubview:image];
    
    UIButton *city_btn = [[UIButton alloc] init];
    city_btn.frame = CGRectMake(image.frame.size.width+image.frame.origin.x+10, 0, 45, 40);
    [city_btn setTitle:@"杭州" forState:UIControlStateNormal];
    city_btn.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    city_btn.tag = 22;
    [city_btn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [city_btn addTarget:self action:@selector(get_area:) forControlEvents:UIControlEventTouchUpInside];
    [area_view addSubview:city_btn];
    
    UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user-address-down-icon"]];
    image2.frame = CGRectMake(city_btn.frame.size.width+city_btn.frame.origin.x+5, 12, 15, 15);
    [area_view addSubview:image2];
    
    UIButton *area_btn = [[UIButton alloc] init];
    area_btn.frame = CGRectMake(image2.frame.size.width+image2.frame.origin.x+10, 0, 45, 40);
    [area_btn setTitle:@"下城" forState:UIControlStateNormal];
    city_btn.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    area_btn.tag = 23;
    [area_btn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [area_btn addTarget:self action:@selector(get_area:) forControlEvents:UIControlEventTouchUpInside];
    //area_btn.backgroundColor = [UIColor blueColor];
    [area_view addSubview:area_btn];
    
    UIImageView *image3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user-address-down-icon"]];
    image3.frame = CGRectMake(area_btn.frame.size.width+area_btn.frame.origin.x+5, 12, 15, 15);
    [area_view addSubview:image3];
    
    //所在地区重新定义view--end
    */
    yy += 50;
    link_address = [self createTextFieldWithTitle:@"街道地址：" yy:yy];
    
    [main_view addSubview:link_man];
    [main_view addSubview:link_mobile];
    [main_view addSubview:link_phone];
    [main_view addSubview:link_email];
    [main_view addSubview:link_qq];
    [main_view addSubview:link_fax];
    [main_view addSubview:areaText];
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

/*
- (void)get_area:(UIButton *)sender
{
    switch (sender.tag) {
        case 21:
        {
            //省选择
            self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 300, 300, 162)];
            self.pickerView.backgroundColor = [UIColor whiteColor];
            self.pickerView.delegate = self;
            self.pickerView.dataSource = self;
            [self.view addSubview:self.pickerView];
            
            [self.pickerView reloadAllComponents];//刷新UIPickerView
            
            _cityArray = [NSArray arrayWithObjects:@"北京",@"上海",@"广州",@"深圳",@"重庆",@"武汉",@"天津",nil];
        }
            break;
        case 22:
        {
            //市选择
        }
            break;
        case 23:
        {
            //区选择
        }
            break;
        default:
            break;
    }
}
*/


- (void)do_save:(id *)sender
{
    NSLog(@"save action");
    MBProgressHUD *hud;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"user/saveContactInfo"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"user/saveContactInfo"];
    
    //NSString *user_id = [BWCommon getUserInfo:@"uid"];
    //[postData setValue:[NSString stringWithFormat:@"%@",user_id] forKey:@"uid"];
    [postData setValue:[NSString stringWithFormat:@"%@",link_man.text] forKey:@"link_man"];
    [postData setValue:[NSString stringWithFormat:@"%@",link_mobile.text] forKey:@"link_mobile"];
    //[postData setValue:[NSString stringWithFormat:@"%@",link_phone.text] forKey:@"link_phone"];
    [postData setValue:[NSString stringWithFormat:@"%@",link_email.text] forKey:@"link_email"];
    [postData setValue:[NSString stringWithFormat:@"%@",link_qq.text] forKey:@"link_qq"];
    [postData setValue:[NSString stringWithFormat:@"%@",link_fax.text] forKey:@"link_fax"];
    [postData setValue:[NSString stringWithFormat:@"%@",link_address.text] forKey:@"link_address"];
    //[postData setValue:@"3300" forKey:@"link_prov_id"];
    //[postData setValue:@"330300" forKey:@"link_city_id"];
    //[postData setValue:@"330304" forKey:@"link_dist_id"];
    
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


#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        self.areaValue = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
    }
}

-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}


#pragma mark - TextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.areaText]) {
        [self cancelLocatePicker];
        self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
        [self.locatePicker showInView:self.view];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self cancelLocatePicker];
}

@end
