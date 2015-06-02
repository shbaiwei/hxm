//
//  MyAddressEditViewController.m
//  hxm
//
//  Created by spring on 15/6/1.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "MyAddressEditViewController.h"
#import "BWCommon.h"

@interface MyAddressEditViewController()
{
    UITextField *receiver_name;
    NSInteger *prov_id;
    NSInteger *city_id;
    NSInteger *dist_id;
    UITextField *address;
    UITextField *mobile;
    UITextField *zip;
    UITextField *phone;
    CGSize size;
}
@end


@implementation MyAddressEditViewController

@synthesize areaText;
@synthesize areaValue=_areaValue;
@synthesize locatePicker=_locatePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_address_info != NULL) {
        self.title = @"收货地址编辑";
    }
    else{
        self.title = @"收货地址添加";
    }
    NSLog(@"address:%@",_address_info);
    // Do any additional setup after loading the view.
    [self pageLayout];
}

-(void)setAreaValue:(NSString *)areaValue
{
    if (![_areaValue isEqualToString:areaValue]) {
        self.areaText.text = areaValue;
    }
}

- (void) pageLayout
{
    UIColor *bgColor = [BWCommon getBackgroundColor];
    self.view.backgroundColor = bgColor;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    
    UIView *main_view = [[UIView alloc] initWithFrame:CGRectMake(20, 60, size.width, size.height)];
    [self.view addSubview:main_view];
    NSInteger yy = 10;
    
    receiver_name = [self createTextFieldWithTitle:@"收件人姓名：" yy:yy];
    yy += 50;
    areaText = [self createTextFieldWithTitle:@"所在地区：" yy:yy];
    yy += 50;
    address = [self createTextFieldWithTitle:@"详细地址：" yy:yy];
    yy += 50;
    zip = [self createTextFieldWithTitle:@"邮政编码：" yy:yy];
    yy += 50;
    mobile = [self createTextFieldWithTitle:@"手机号码：" yy:yy];
    yy += 50;
    phone = [self createTextFieldWithTitle:@"固定电话：" yy:yy];
    
    [main_view addSubview:receiver_name];
    [main_view addSubview:areaText];
    [main_view addSubview:address];
    [main_view addSubview:zip];
    [main_view addSubview:mobile];
    [main_view addSubview:phone];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"是否设为常用地址";
    label2.frame = CGRectMake(0, phone.frame.origin.y+phone.bounds.size.height+10, 200, 40);
    label2.textColor = [UIColor colorWithRed:145/255.0 green:145/255.0 blue:145/255.0 alpha:1.0];
    label2.font = [UIFont systemFontOfSize:16.0];
    [main_view addSubview:label2];
    
    UISwitch *switchView = [[UISwitch alloc] init];
    switchView.frame = CGRectMake(size.width-95, label2.frame.origin.y, 40, 30);
    switchView.on = YES;//设置初始为ON的一边
    [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [main_view addSubview:switchView];
    
    UIButton *save_button = [UIButton buttonWithType:UIButtonTypeCustom];
    save_button.frame = CGRectMake(0, label2.frame.origin.y+label2.bounds.size.height+30, size.width-40, 40);
    [save_button setTag:30];
    [save_button.layer setMasksToBounds:YES];
    [save_button.layer setCornerRadius:3.0];
    [save_button setTintColor:[UIColor whiteColor]];
    [save_button setBackgroundColor:[UIColor redColor]];
    [save_button setTitle:@"保存" forState:UIControlStateNormal];
    [save_button addTarget:self action:@selector(do_action:) forControlEvents:UIControlEventTouchUpInside];
    [main_view addSubview:save_button];
}

//UISwitch事件处理
- (void) switchAction: (UISwitch *) sender
{
    
}

- (void) do_action:(id *) sender
{

}

- (UITextField *) createTextFieldWithTitle:(NSString *) title yy:(NSInteger)yy{
    
    UITextField * field = [[UITextField alloc] initWithFrame:CGRectMake(0, yy+10, size.width-40, 40)];
    field.borderStyle = UITextBorderStyleRoundedRect;
    [field.layer setCornerRadius:5.0];
    //field.placeholder = title;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 120, 40)];
    
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
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
    } else {
        [self cancelLocatePicker];
        self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCity delegate:self] ;
        [self.locatePicker showInView:self.view];
    }
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self cancelLocatePicker];
}

@end
