//
//  MyAddressEditViewController.m
//  hxm
//
//  Created by spring on 15/6/1.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "MyAddressEditViewController.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"

@interface MyAddressEditViewController()
{
    UITextField *receiver_name;

    UITextField *address;
    UITextField *mobile;
    UITextField *zip;
    UITextField *phone;
    CGSize size;
}

@property (nonatomic,retain) UIScrollView *sclView;
@property (nonatomic,retain) UISwitch *switchView;
@end


@implementation MyAddressEditViewController

NSDictionary *regions;

NSDictionary *cityData;
NSDictionary *provinceData;
NSDictionary *townData;

NSUInteger send_province;
NSUInteger send_city;
NSUInteger send_town;

NSUInteger address_id;

bool is_default;

NSMutableArray *selectedRegions;

@synthesize areaText;
@synthesize areaValue=_areaValue;
@synthesize addressInfo;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (address_id > 0) {
        self.title = @"编辑收货地址";
    }
    else{
        self.title = @"新增收货地址";
    }
    
    [self pageLayout];
}


- (void) pageLayout
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
    
    if(address_id>0)
        [sclView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getAddressInfo)];
    else
    {
        is_default = 0;
        self.switchView.on = is_default;
    }
    
    
    receiver_name = [self createTextFieldWithTitle:@"收件人姓名："];

    areaText = [self createTextFieldWithTitle:@"所在地区："];
    areaText.tag = 1;
    
    regions = [BWCommon getDataInfo:@"regions"];
    provinceData  = [self loadRegions:0];
    //默认加载第一条
    cityData = [self loadRegions:[[[provinceData allKeys] objectAtIndex:0] integerValue]];
    townData = [self loadRegions:[[[cityData allKeys] objectAtIndex:0] integerValue]];
    
    selectedRegions = [NSMutableArray arrayWithCapacity:3];
    
    [self setPickerView:areaText];


    address = [self createTextFieldWithTitle:@"详细地址："];

    zip = [self createTextFieldWithTitle:@"邮政编码："];
    zip.keyboardType = UIKeyboardTypeNumberPad;

    mobile = [self createTextFieldWithTitle:@"手机号码："];
    mobile.keyboardType = UIKeyboardTypeNumberPad;

    phone = [self createTextFieldWithTitle:@"固定电话："];
    phone.keyboardType = UIKeyboardTypeNumberPad;
    
    [sclView addSubview:receiver_name];
    [sclView addSubview:areaText];
    [sclView addSubview:address];
    [sclView addSubview:zip];
    [sclView addSubview:mobile];
    [sclView addSubview:phone];
    
    
    UIView *switchBody = [[UIView alloc] init];
    switchBody.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"是否设为常用地址";
    label2.frame = CGRectMake(0, 10, 200, 40);
    label2.textColor = [UIColor colorWithRed:145/255.0 green:145/255.0 blue:145/255.0 alpha:1.0];
    label2.font = [UIFont systemFontOfSize:16.0];
    
    UISwitch *switchView = [[UISwitch alloc] init];
    switchView.frame = CGRectMake(size.width-95, 10, 40, 30);
    switchView.on = YES;//设置初始为ON的一边
    [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    self.switchView = switchView;

    [switchBody addSubview:label2];
    [switchBody addSubview:switchView];
    
    [sclView addSubview:switchBody];

    UIButton *submitButton = [self footerButton:@"保 存" bgColor:[BWCommon getRedColor]];
    [submitButton addTarget:self action:@selector(do_save:) forControlEvents:UIControlEventTouchUpInside];
    
    [sclView addSubview:submitButton];
    
    NSUInteger width = size.width - 40;
    
    NSArray *constraints1= [NSLayoutConstraint constraintsWithVisualFormat:[self createFormat:@"receiver_name" width:width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(receiver_name)];
    NSArray *constraints2= [NSLayoutConstraint constraintsWithVisualFormat:[self createFormat:@"areaText" width:width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(areaText)];
    NSArray *constraints3= [NSLayoutConstraint constraintsWithVisualFormat:[self createFormat:@"address" width:width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(address)];
    NSArray *constraints4= [NSLayoutConstraint constraintsWithVisualFormat:[self createFormat:@"zip" width:width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(zip)];
    NSArray *constraints5= [NSLayoutConstraint constraintsWithVisualFormat:[self createFormat:@"mobile" width:width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(mobile)];
    NSArray *constraints6= [NSLayoutConstraint constraintsWithVisualFormat:[self createFormat:@"phone" width:width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(phone)];
    
    NSArray *constraints7= [NSLayoutConstraint constraintsWithVisualFormat:[self createFormat:@"switchBody" width:width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(switchBody)];
    NSArray *constraints9= [NSLayoutConstraint constraintsWithVisualFormat:[self createFormat:@"submitButton" width:width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(submitButton)];
    
    NSArray *constraintsV= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[receiver_name(==50)]-10-[areaText(==50)]-10-[address(==50)]-10-[zip(==50)]-10-[mobile(==50)]-10-[phone(==50)]-10-[switchBody(==30)]-20-[submitButton(==50)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(receiver_name,areaText,address,zip,mobile,phone,switchBody,submitButton)];
    
    
    [sclView addConstraints:constraints1];
    [sclView addConstraints:constraints2];
    [sclView addConstraints:constraints3];
    [sclView addConstraints:constraints4];
    [sclView addConstraints:constraints5];
    [sclView addConstraints:constraints6];
    [sclView addConstraints:constraints7];
    [sclView addConstraints:constraints9];
    [sclView addConstraints:constraintsV];
    
    if(address_id>0)
        [self getAddressInfo];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    // very important make delegate useful
    tap.delegate = self;

}

- (void)initData{
    receiver_name.text = [self.addressInfo objectForKey:@"receiver_name"];
    address.text = [self.addressInfo objectForKey:@"address"];
    zip.text = [self.addressInfo objectForKey:@"zip"];
    mobile.text = [self.addressInfo objectForKey:@"mobile"];
    phone.text = [self.addressInfo objectForKey:@"phone"];
    
    is_default = [[self.addressInfo objectForKey:@"is_default"] boolValue];
    
    if(is_default){
        self.switchView.on = YES;
    }else{
        self.switchView.on = NO;
    }
    
    
    NSMutableArray *areaArray = [[NSMutableArray alloc] init];
    
    areaArray[0] = [BWCommon getRegionById:[[self.addressInfo objectForKey:@"prov_id"]integerValue]];
    areaArray[1] = [BWCommon getRegionById:[[self.addressInfo objectForKey:@"city_id"]integerValue]];
    
    if([[self.addressInfo objectForKey:@"dist_id"] integerValue] > 0)
    {
        areaArray[2] = [BWCommon getRegionById:[[self.addressInfo objectForKey:@"dist_id"]integerValue]];
    }
    
    areaText.text = [areaArray componentsJoinedByString:@" - "];

    
    //selectedRegions[0] =self.addressInfo[@"prov_id"];
    //selectedRegions[1] =self.addressInfo[@"city_id"];
    //selectedRegions[2] =self.addressInfo[@"dist_id"];
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

-(void) setValue: (NSUInteger) detailValue{
    address_id = detailValue;
}

- (void) getAddressInfo
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"user/getAddressInfoById"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"user/getAddressInfoById"];
    

    [postData setValue:[NSString stringWithFormat:@"%ld",address_id] forKey:@"address_id"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    
    NSLog(@"%@",url);
    //load data
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSLog(@"addressInfo:%@",responseObject);
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        [hud removeFromSuperview];
        [self.sclView.header endRefreshing];
        if(errNo == 0)
        {
            self.addressInfo = [[responseObject objectForKey:@"data"] mutableCopy];
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
    
    return [NSString stringWithFormat:@"H:|-20-[%@(==%ld)]-20-|",name,width];
}

//UISwitch事件处理
- (void) switchAction: (UISwitch *) sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        is_default = 1;
    }else {
        is_default = 0;
    }
}

- (void)do_save:(id *)sender
{
    NSLog(@"save action");
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *url2 = address_id > 0 ? @"user/saveAddress" : @"user/addAddress";
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:url2];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:url2];
    
    
    [postData setValue:receiver_name.text forKey:@"receiver_name"];

    
    [postData setValue:address.text forKey:@"address"];
    [postData setValue:mobile.text forKey:@"link_qq"];
    [postData setValue:zip.text forKey:@"link_fax"];
    [postData setValue:phone.text forKey:@"link_address"];
    [postData setValue:[NSString stringWithFormat:@"%ld",send_province] forKey:@"prov_id"];
    [postData setValue:[NSString stringWithFormat:@"%ld",send_city] forKey:@"city_id"];
    [postData setValue:[NSString stringWithFormat:@"%ld",send_town] forKey:@"dist_id"];
    
    [postData setValue:[NSString stringWithFormat:@"%d",is_default] forKey:@"is_default"];
    
    if(address_id>0)
        [postData setValue:[NSString stringWithFormat:@"%ld",address_id] forKey:@"address_id"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    NSLog(@"%@",postData);
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        // NSLog(@"userinfo:%@",responseObject);
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        [hud removeFromSuperview];
        if(errNo == 0)
        {
            //处理成功
            if(address_id > 0){
                [alert setMessage:@"编辑收货地址操作成功"];
            }else{
                [alert setMessage:@"新增收货地址操作成功"];
            }
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


- (UITextField *) createTextFieldWithTitle:(NSString *) title{
    
    UITextField * field = [[UITextField alloc] init];
    field.borderStyle = UITextBorderStyleRoundedRect;
    [field.layer setCornerRadius:5.0];
    //field.placeholder = title;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 110, 40)];
    
    label.text = title;
    label.textAlignment = NSTextAlignmentRight;
    field.leftView = label;
    field.leftViewMode = UITextFieldViewModeAlways;
    field.translatesAutoresizingMaskIntoConstraints = NO;
    field.delegate = self;
    
    return field;
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

// tap dismiss keyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    //[self.password resignFirstResponder];
}

@end
