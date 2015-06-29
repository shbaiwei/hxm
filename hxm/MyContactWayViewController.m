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
#import "MJRefresh.h"


@interface MyContactWayViewController ()
{
    UITextField *link_man;
    UITextField *link_mobile;
    UITextField *link_phone;
    UITextField *link_email;
    UITextField *link_qq;
    UITextField *link_fax;
    UITextField *link_address;
    CGSize size;
}

@property (nonatomic,retain) UIScrollView *sclView;
@end

@implementation MyContactWayViewController

NSDictionary *regions;

NSDictionary *cityData;
NSDictionary *provinceData;
NSDictionary *townData;

NSUInteger send_province;
NSUInteger send_city;
NSUInteger send_town;

NSMutableArray *selectedRegions;

@synthesize areaText;
@synthesize areaValue=_areaValue;

@synthesize userinfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系方式";
    // Do any additional setup after loading the view.
    [self pageLayout];

}


//初始化数据
- (void) initData
{
    link_man.text = [userinfo objectForKey:@"link_man"];
    link_mobile.text = [userinfo objectForKey:@"link_mobile"];
    link_phone.text = [userinfo objectForKey:@"link_phone"];
    link_email.text = [userinfo objectForKey:@"link_email"];
    link_qq.text = [userinfo objectForKey:@"link_qq"];
    link_fax.text = [userinfo objectForKey:@"link_fax"];
    link_address.text = [userinfo objectForKey:@"link_address"];
    
    selectedRegions[0] =userinfo[@"link_prov"];
    selectedRegions[1] =userinfo[@"link_city"];
    selectedRegions[2] =userinfo[@"link_dist"];
    
    areaText.text =  [selectedRegions componentsJoinedByString:@" - "];
    send_province = [userinfo[@"link_prov_id"] integerValue];
    send_city = [userinfo[@"link_city_id"] integerValue];
    send_town = [userinfo[@"link_dist_id"] integerValue];
    
}

//初始化界面
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
    
    //UIScrollView *main_view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, size.width, size.height)];
    
    [self.view addSubview:sclView];
    link_man = [self createTextFieldWithTitle:@"姓    名："];

    link_mobile = [self createTextFieldWithTitle:@"手    机："];
    link_mobile.keyboardType = UIKeyboardTypeNamePhonePad;

    link_phone = [self createTextFieldWithTitle:@"固定电话："];

    link_email = [self createTextFieldWithTitle:@"E-mail："];
    link_email.keyboardType = UIKeyboardTypeEmailAddress;

    link_qq = [self createTextFieldWithTitle:@"Q Q："];
    link_qq.keyboardType = UIKeyboardTypeNumberPad;

    link_fax = [self createTextFieldWithTitle:@"传     真："];
    link_fax.keyboardType = UIKeyboardTypeNumberPad;

    areaText = [self createTextFieldWithTitle:@"所在地区："];
    areaText.tag = 1;

    link_address = [self createTextFieldWithTitle:@"街道地址："];
    
    
    regions = [BWCommon getDataInfo:@"regions"];
    provinceData  = [self loadRegions:0];
    //默认加载第一条
    cityData = [self loadRegions:[[[provinceData allKeys] objectAtIndex:0] integerValue]];
    townData = [self loadRegions:[[[cityData allKeys] objectAtIndex:0] integerValue]];

    selectedRegions = [NSMutableArray arrayWithCapacity:3];
    
    [self setPickerView:areaText];

    
    UIButton *submitButton = [self footerButton:@"保 存" bgColor:[BWCommon getRedColor]];
    
    [submitButton addTarget:self action:@selector(do_save:) forControlEvents:UIControlEventTouchUpInside];
    
    [sclView addSubview:link_man];
    [sclView addSubview:link_mobile];
    [sclView addSubview:link_phone];
    [sclView addSubview:link_email];
    [sclView addSubview:link_qq];
    [sclView addSubview:link_fax];
    [sclView addSubview:areaText];
    [sclView addSubview:link_address];
    [sclView addSubview:submitButton];
    
    NSUInteger width = size.width - 40;
    
    NSArray *constraints1= [NSLayoutConstraint constraintsWithVisualFormat:[self createFormat:@"link_man" width:width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(link_man)];
    NSArray *constraints2= [NSLayoutConstraint constraintsWithVisualFormat:[self createFormat:@"link_mobile" width:width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(link_mobile)];
    NSArray *constraints3= [NSLayoutConstraint constraintsWithVisualFormat:[self createFormat:@"link_phone" width:width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(link_phone)];
    NSArray *constraints4= [NSLayoutConstraint constraintsWithVisualFormat:[self createFormat:@"link_email" width:width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(link_email)];
    NSArray *constraints5= [NSLayoutConstraint constraintsWithVisualFormat:[self createFormat:@"link_qq" width:width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(link_qq)];
    NSArray *constraints6= [NSLayoutConstraint constraintsWithVisualFormat:[self createFormat:@"link_fax" width:width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(link_fax)];
    NSArray *constraints7= [NSLayoutConstraint constraintsWithVisualFormat:[self createFormat:@"areaText" width:width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(areaText)];
    NSArray *constraints8= [NSLayoutConstraint constraintsWithVisualFormat:[self createFormat:@"link_address" width:width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(link_address)];
    NSArray *constraints9= [NSLayoutConstraint constraintsWithVisualFormat:[self createFormat:@"submitButton" width:width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(submitButton)];
    
    NSArray *constraintsV= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[link_man(==50)]-10-[link_mobile(==50)]-10-[link_phone(==50)]-10-[link_email(==50)]-10-[link_qq(==50)]-10-[link_fax(==50)]-10-[areaText(==50)]-10-[link_address(==50)]-20-[submitButton(==50)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(link_man,link_mobile,link_phone,link_email,link_qq,link_fax,areaText,link_address,submitButton)];

    
    [sclView addConstraints:constraints1];
    [sclView addConstraints:constraints2];
    [sclView addConstraints:constraints3];
    [sclView addConstraints:constraints4];
    [sclView addConstraints:constraints5];
    [sclView addConstraints:constraints6];
    [sclView addConstraints:constraints7];
    [sclView addConstraints:constraints8];
    [sclView addConstraints:constraints9];
    [sclView addConstraints:constraintsV];
    
    [self getUserInfo];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    // very important make delegate useful
    tap.delegate = self;
    
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
        
        return 3;
    }
    else{
        return 2;
    }
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //return [self.items count];
    
    if(pickerView.tag == 1)
    {
        if (component == 0){
            
            return [provinceData count];
        }
        else if(component == 1){
            return [cityData count];
        }
        else if(component == 2){
            return [townData count];
        }
    }
    
    return 0;
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //return [self.items objectAtIndex:row];
    
    if(pickerView.tag == 1)
    {
        if(component == 0){
            return [[provinceData allValues] objectAtIndex:row];
            //self.selectedProvince = [self.province objectAtIndex:row];
            //return [self.province objectAtIndex:row];
        }
        else if (component == 1){
            return [[cityData allValues] objectAtIndex:row];
        }
        else if (component == 2){
            //self.selectedCity = [self.city objectAtIndex:row];
            //return [self.city objectAtIndex:row];
            return [[townData allValues] objectAtIndex:row];
        }
        
    }
    
    return @"";
}


-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if(pickerView.tag == 1)
    {
        if(component == 0){
            
            cityData = [self loadRegions:[[[provinceData allKeys] objectAtIndex:row] integerValue]];
            townData = [self loadRegions:[[[cityData allKeys] objectAtIndex:0] integerValue]];
            
            [pickerView selectedRowInComponent:1];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];

            
            send_province = [[[provinceData allKeys] objectAtIndex:row] integerValue];
            selectedRegions[0] = [[provinceData allValues] objectAtIndex:row];
            selectedRegions[1] = [[cityData allValues] objectAtIndex:0];
            
            if([townData count])
                selectedRegions[2] = [[townData allValues] objectAtIndex:0];
            else
                selectedRegions[2] = @"";
        }
        else if (component == 1){
            
            townData = [self loadRegions:[[[cityData allKeys] objectAtIndex:row] integerValue]];
            
            [pickerView selectedRowInComponent:2];
            [pickerView reloadComponent:2];
            
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
            send_city = [[[cityData allKeys] objectAtIndex:row] integerValue];
            selectedRegions[1] = [[cityData allValues] objectAtIndex:row];
            
            if([townData count])
                selectedRegions[2] = [[townData allValues] objectAtIndex:0];
            else
                selectedRegions[2] = @"";
        }
        else if (component == 2){
            
            send_town = [[[townData allKeys] objectAtIndex:row] integerValue];
            selectedRegions[2] = [[townData allValues] objectAtIndex:row];
        }
        
        //self.province.text = [selectedRegions componentsJoinedByString:@" - "];
    }
    
}


-(void)doneTouched:(id)sender{

    if([self.areaText resignFirstResponder] == YES){
        self.areaText.text = [selectedRegions componentsJoinedByString:@" - "];
        [self.areaText resignFirstResponder];
    }
    
}
-(void) cancelTouched:(id)sender{

    [self.areaText resignFirstResponder];
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

-(NSMutableDictionary *) loadRegions:(NSInteger) parent_id {
    NSArray *regions = [BWCommon getDataInfo:@"regions"];
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    for (int i=0;i<[regions count];i++){
        NSDictionary *item = [[NSDictionary alloc] initWithDictionary:[regions objectAtIndex:i]];
        if ([[item objectForKey:@"parent_id"] integerValue] == parent_id) {
            [data setObject:[item objectForKey:@"region_name"] forKey:[item objectForKey:@"region_id"]];
            
        }
    }
    return data;
}

- (NSString *) createFormat:(NSString *) name  width:( NSUInteger ) width{
    
    return [NSString stringWithFormat:@"H:|-20-[%@(==%d)]-20-|",name,width];
}

- (void) setTextFieldCenter:(NSArray *) items{
    
    NSInteger i = 0;
    
    for (i=0; i<[items count]; i++) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:[items objectAtIndex:i] attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    }
    
}

- (void)do_save:(id *)sender
{
    NSLog(@"save action");
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"user/saveContactInfo"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"user/saveContactInfo"];
    

    [postData setValue:link_man.text forKey:@"link_man"];
    [postData setValue:link_mobile.text forKey:@"link_mobile"];

    [postData setValue:link_email.text forKey:@"link_email"];
    [postData setValue:link_qq.text forKey:@"link_qq"];
    [postData setValue:link_fax.text forKey:@"link_fax"];
    [postData setValue:link_address.text forKey:@"link_address"];
    [postData setValue:[NSString stringWithFormat:@"%d",send_province] forKey:@"link_prov_id"];
    [postData setValue:[NSString stringWithFormat:@"%d",send_city] forKey:@"link_city_id"];
    [postData setValue:[NSString stringWithFormat:@"%d",send_town] forKey:@"link_dist_id"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"资料修改成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
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





@end
