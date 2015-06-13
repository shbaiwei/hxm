//
//  ApplyViewController.m
//  hxm
//
//  Created by Bruce on 15-5-19.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "ApplyViewController.h"
#import "AFNetworkTool.h"
#import "BWCommon.h"

@interface ApplyViewController ()

@property (nonatomic, weak) UIButton *photo1Button;
@property (nonatomic, weak) UIButton *photo2Button;
@property (nonatomic,weak) UITextField *main_type;
@property (nonatomic,weak) UITextField *province;

@end

@implementation ApplyViewController

NSString * face_pic;
NSString * back_pic;
NSDictionary *business;
NSArray *businessArray;

NSDictionary *regions;

NSDictionary *cityData;
NSDictionary *provinceData;
NSDictionary *townData;

NSUInteger send_province;
NSUInteger send_city;
NSUInteger send_town;

NSUInteger photo_type = 0;

NSMutableArray *selectedRegions;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) pageLayout{
    
    UIColor *bgColor = [BWCommon getBackgroundColor];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    sclView.backgroundColor = bgColor;
    sclView.scrollEnabled = YES;
    //sclView.translatesAutoresizingMaskIntoConstraints = NO;
    sclView.contentSize = CGSizeMake(size.width, 1000);
    [self.view addSubview:sclView];
    
    self.view.backgroundColor = bgColor;
    [self.navigationItem setTitle:@"提交审核信息"];
    
    UIView *tipsView = [[UIView alloc] initWithFrame:CGRectMake((size.width - 280) / 2, 15, 280, 50)];
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"apply-icon.png"]];
    icon.frame = CGRectMake(0,0, 40, 40);
    UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 240, 20)];
    tips.text = @"注册完成，请完善以下信息！";
    [tipsView addSubview:icon];
    [tipsView addSubview:tips];
    
    [sclView addSubview:tipsView];
    
    UITextField *real_name = [self createTextField:@"真实姓名："];
    [sclView addSubview:real_name];
    
    UITextField *id_card = [self createTextField:@"身份证号："];
    [sclView addSubview:id_card];
    
    UITextField *id_card_time = [self createTextField:@"有效期限："];
    [sclView addSubview:id_card_time];
    
    UITextField *main_type = [self createTextField:@"主体类型："];
    [sclView addSubview:main_type];
    main_type.tag = 1;
    self.main_type = main_type;
    
    [self setPickerView:main_type];
    
    //
    
    UITextField *province = [self createTextField:@"省/市/区："];
    [sclView addSubview:province];
    province.tag = 2;
    self.province = province;
    
    [self setPickerView:province];
    
    UITextField *address = [self createTextField:@"送货地址："];
    [sclView addSubview:address];
    
    UITextField *time = [self createTextField:@"送货时间："];
    [sclView addSubview:time];
    
    UITextField *contact = [self createTextField:@"联系人："];
    [sclView addSubview:contact];
    
    UITextField *mobile = [self createTextField:@"手机："];
    [sclView addSubview:mobile];
    
    UITextField *qq = [self createTextField:@"QQ："];
    [sclView addSubview:qq];
    
    UIView *photoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 120)];
    [sclView addSubview:photoView];
    photoView.translatesAutoresizingMaskIntoConstraints = NO;
    photoView.backgroundColor = [UIColor whiteColor];
    
    UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
    photoLabel.text = @"身份证照片";
    photoLabel.font = [UIFont systemFontOfSize:16];
    [photoView addSubview:photoLabel];
    
    UIButton *photo1Button = [[UIButton alloc] initWithFrame:CGRectMake(10, 36, 90, 68)];
    [photo1Button setBackgroundImage:[UIImage imageNamed:@"apply-plus1.png"] forState:UIControlStateNormal];
    [photoView addSubview:photo1Button];
    
    self.photo1Button = photo1Button;
    
    UIButton *photo2Button = [[UIButton alloc] initWithFrame:CGRectMake(120, 36, 90, 68)];
    [photo2Button setBackgroundImage:[UIImage imageNamed:@"apply-plus2.png"] forState:UIControlStateNormal];
    [photoView addSubview:photo2Button];
    
    self.photo2Button = photo2Button;
    
    
    //NSLog(@"%@",[BWCommon getDataInfo:@"regions"]);
    
    regions = [BWCommon getDataInfo:@"regions"];
    
    provinceData  = [self loadRegions:0];
    
    //默认加载第一条
    cityData = [self loadRegions:[[[provinceData allKeys] objectAtIndex:0] integerValue]];
    
    townData = [self loadRegions:[[[cityData allKeys] objectAtIndex:0] integerValue]];
    
    business = [BWCommon getDataInfo:@"business"];
    
    businessArray = [business allValues];
    
    selectedRegions = [NSMutableArray arrayWithCapacity:3];
    
    
    UIButton *submitButton = [self footerButton:@"保 存" bgColor:[UIColor colorWithRed:219/255.0f green:0/255.0f blue:0 alpha:1]];
    
    //[submitButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    //submitButton.frame = CGRectMake(padding, 200, size.width-padding*2 , 40);
    [sclView addSubview:submitButton];
    
    
    NSArray *constraints1= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[real_name(==300)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(real_name)];
    
    NSArray *constraints2= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[real_name(==50)]-10-[id_card(==50)]-10-[id_card_time(==50)]-10-[main_type(==50)]-10-[province(==50)]-10-[address(==50)]-10-[time(==50)]-10-[contact(==50)]-10-[mobile(==50)]-10-[qq(==50)]-10-[photoView(==120)]-10-[submitButton(==50)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(real_name,id_card,id_card_time,main_type,province,address,time,contact,mobile,qq,photoView,submitButton)];
    
    NSArray *constraints3= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[id_card(==300)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(id_card)];
    NSArray *constraints4= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[id_card_time(==300)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(id_card_time)];
    NSArray *constraints5= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[main_type(==300)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(main_type)];
    NSArray *constraints6= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[province(==300)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(province)];
    NSArray *constraints7= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[address(==300)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(address)];
    NSArray *constraints8= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[time(==300)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(time)];
    NSArray *constraints9= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[contact(==300)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contact)];
    NSArray *constraints10= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[mobile(==300)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(mobile)];
    NSArray *constraints11= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[qq(==300)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(qq)];
    NSArray *constraints12= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[photoView(==300)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(photoView)];
    NSArray *constraints13= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[submitButton(==300)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(submitButton)];
    
    [sclView addConstraints:constraints1];
    [sclView addConstraints:constraints2];
    [sclView addConstraints:constraints3];
    [sclView addConstraints:constraints4];
    [sclView addConstraints:constraints5];
    [sclView addConstraints:constraints6];
    [sclView addConstraints:constraints7];
    [sclView addConstraints:constraints8];
    [sclView addConstraints:constraints9];
    [sclView addConstraints:constraints10];
    [sclView addConstraints:constraints11];
    [sclView addConstraints:constraints12];
    [sclView addConstraints:constraints13];
    
    

    
    [photo1Button addTarget:self action:@selector(uploadTouched:) forControlEvents:UIControlEventTouchUpInside];
    [photo2Button addTarget:self action:@selector(uploadTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    photo1Button.tag=1;
    photo2Button.tag=2;

    [self setTextFieldCenter:[[NSArray alloc] initWithObjects:real_name,id_card,id_card_time,main_type,province,address,time,contact,mobile,qq,photoView,submitButton,nil]];

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


-(NSMutableDictionary *) loadRegions:(NSInteger) parent_id {
    NSArray *regions = [BWCommon getDataInfo:@"regions"];
    //[self.city removeAllObjects];
    //[self.cityKey removeAllObjects];
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    for (int i=0;i<[regions count];i++){
        NSDictionary *item = [[NSDictionary alloc] initWithDictionary:[regions objectAtIndex:i]];
        if ([[item objectForKey:@"parent_id"] integerValue] == parent_id) {
            [data setObject:[item objectForKey:@"region_name"] forKey:[item objectForKey:@"region_id"]];

        }
    }
    
    return data;
}

// tap dismiss keyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    //[self.password resignFirstResponder];
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

- (void) setTextFieldCenter:(NSArray *) items{
    
    NSInteger i = 0;
    
    for (i=0; i<[items count]; i++) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:[items objectAtIndex:i] attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    }
    
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


-(void) uploadTouched:(UIButton *)sender{

    photo_type = sender.tag;

    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
    menu.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
}


-(void)doneTouched:(id)sender{
    //[self.category resignFirstResponder];
    if([self.main_type resignFirstResponder] == YES){
        
        //self.departureArea.text = [NSString stringWithFormat:@"%@ %@", self.selectedProvince,self.selectedCity ];
        //self.fpid = self.selectedProvinceId;
        //self.fcid = main_type.selectedCityId;
        [self.main_type resignFirstResponder];
    }
    
    if([self.province resignFirstResponder] == YES){
        //self.destinationArea.text = [NSString stringWithFormat:@"%@ %@", self.selectedProvince,self.selectedCity ];
        //self.tpid = self.selectedProvinceId;
        //self.tcid = self.selectedCityId;
        
        self.province.text = [selectedRegions componentsJoinedByString:@" - "];
        
        [self.province resignFirstResponder];
    }
    
}
-(void) cancelTouched:(id)sender{
    [self.main_type resignFirstResponder];
    [self.province resignFirstResponder];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    if(pickerView.tag == 1){
        return 1;
    }
    else if(pickerView.tag == 2){
        
        return 3;
    }
    else{
        return 2;
    }
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //return [self.items count];
    
    if(pickerView.tag == 1){
        return [business count];
    }
    else if(pickerView.tag == 2)
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
    
    if(pickerView.tag == 1){
        return [businessArray objectAtIndex:row];
    }
    else if(pickerView.tag == 2)
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
            //[pickerView selectRow:0 inComponent:0 animated:YES];
            
            NSArray *values = [business allValues];
            self.main_type.text = [values objectAtIndex:row];
        }
    }
    else if(pickerView.tag == 2)
    {
        if(component == 0){
            
            cityData = [self loadRegions:[[[provinceData allKeys] objectAtIndex:row] integerValue]];
            townData = [self loadRegions:[[[cityData allKeys] objectAtIndex:0] integerValue]];
            
            [pickerView selectedRowInComponent:1];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            
            [pickerView selectRow:0 inComponent:1 animated:YES];
            
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


- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if(buttonIndex==0){
        [self snapImage];

    }else if(buttonIndex==1){
        [self pickImage];
    }

}

//拍照
- (void) snapImage{
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    ipc.sourceType=UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    ipc.allowsEditing=NO;
    
   
    [self presentViewController:ipc animated:YES completion:^{
        
        
    }];
    
}
//从相册里找
- (void) pickImage{
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    ipc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    ipc.allowsEditing=NO;
    
    [self presentViewController:ipc animated:YES completion:^{
    }];

}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *) info{
    
    UIImage *img=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
            //UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
    }
    
    int y = (arc4random() % 1001) + 9000;
    
    NSString *fileName = [NSString stringWithFormat:@"%d%@",y,@".jpg"];
    
    [self saveImage:img WithName:fileName];
    
    NSString *fullFileName = [[self documentFolderPath] stringByAppendingPathComponent:fileName];
    
    NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:fullFileName];
    //NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
    NSLog(@"%@",fileUrl);
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    
    NSString *api_url = @"http://hj.s10.baiwei.org/member/register/upload_img";

    NSDictionary *postData = @{@"password":[BWCommon getUserInfo:@"password"],@"uniqueid":[BWCommon getUserInfo:@"uid"]};
    
    
    [AFNetworkTool postUploadWithUrl:api_url fileUrl:fileUrl parameters:postData success:^(id responseObject) {
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        [hud removeFromSuperview];

        NSLog(@"%@",responseObject);
        if (errNo > 0) {
            [alert setMessage:[responseObject objectForKey:@"error"]];
            [alert show];
        }
        else
        {
            NSString *imgurl = [[responseObject objectForKey:@"data"] objectForKey:@"imgurl"];
            NSString *imgview = [[responseObject objectForKey:@"data"] objectForKey:@"imgview"];
            
            //图片获取的token
            NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970] ];
            NSString *uid = [BWCommon getUserInfo:@"uid"];
            
            NSString *str = [NSString stringWithFormat:@"register/display_cert_image/%@/%@",timestamp,[BWCommon md5:uid]];
            //init token
            NSString *token = [BWCommon md5:str];
            
            NSString *nimgview = [[NSString alloc] init];
            nimgview = [imgview stringByReplacingOccurrencesOfString:@"http://www.huaji.com/" withString:@"http://www.huaji.com:81/"];
            nimgview = [NSString stringWithFormat:@"%@?token=%@&time=%@&uid=%@",nimgview,token,timestamp,uid];
            NSURL *dataurl = [[NSURL alloc] initFileURLWithPath:nimgview];
            
            NSLog(@"%@",dataurl);
            
            NSData* ndata = [NSData dataWithContentsOfURL:dataurl];
            
            if(photo_type==1){
                face_pic = imgurl;
                
                [self.photo1Button setBackgroundImage:[UIImage imageWithData:ndata] forState:UIControlStateNormal];
            }
            else if(photo_type==2){
                back_pic = imgurl;
                
                [self.photo2Button setBackgroundImage:[UIImage imageWithData:ndata] forState:UIControlStateNormal];
            }

            NSLog(@"%@",imgurl);
        }

    } fail:^{
        
        [hud removeFromSuperview];
        
        [alert setMessage:@"请求超时，请稍候重试"];
        [alert show];
        
        NSLog(@"请求失败");
    }];
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage,1);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
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
