//
//  MyNewViewController.m
//  hxm
//
//  Created by Bruce He on 15/6/26.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "MyNewViewController.h"
#import "MyTableViewFrame.h"
#import "MyTableViewCell.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"
#import "LoginViewController.h"
#import "MyContactWayViewController.h"
#import "MyBusinessInfoViewController.h"
#import "MyAddressViewController.h"
#import "MyAfterSalesViewController.h"
#import "MyPasswordViewController.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

@interface MyNewViewController ()

@property (nonatomic, strong) NSArray *statusFrames;

@property (nonatomic,retain) NSMutableArray *list;
@property (nonatomic,retain) NSMutableArray *sectionList;
@property (nonatomic,retain) UIScrollView *sclView;

@property (nonatomic,retain) UILabel *usernameLabel;
@property (nonatomic,retain) UIImageView * faceImage;

@property (nonatomic,retain) NSMutableDictionary *userinfo;

@end

@implementation MyNewViewController

CGSize size;

@synthesize tableview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
}

- (void) pageLayout{
    UIColor *bgColor = [BWCommon getBackgroundColor];
    self.view.backgroundColor = bgColor;
    
    //NSLog(@"%@",[BWCommon getUserInfo:@"uid"]);
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
    //self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
 
    
    self.navigationController.navigationBarHidden = YES;
    
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.image=[UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem=backItem;
    
    UIImageView *topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user-bg.jpg"]];
    topView.frame = CGRectMake(0, 0, size.width, 160);
    [self.view addSubview:topView];
    
    
    UILabel *headLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, topView.bounds.size.height/2)];
    headLabel.text = @"我的";
    headLabel.textAlignment = NSTextAlignmentCenter;
    headLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:headLabel];
    
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, (topView.bounds.size.height)-30, size.width, 20)];
    usernameLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:usernameLabel];
    self.usernameLabel = usernameLabel;
    
    UIImageView *faceImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, topView.frame.size.height-70, 80, 80)];
    [faceImage.layer setCornerRadius:40.0];
    [faceImage.layer setZPosition:100.0f];
    faceImage.layer.masksToBounds = YES;
    [self.view addSubview:faceImage];
    self.faceImage = faceImage;
    
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 160, size.width, size.height)];
    sclView.backgroundColor = bgColor;
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width, size.height+300);
    [self.view addSubview:sclView];
    self.sclView = sclView;

    
    //table footer view  for  logout button
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 80)];
    footerView.backgroundColor = [BWCommon getBackgroundColor];
    //加入
    UIButton *btLogout = [self footerButton:@"退出当前账号" bgColor:[BWCommon getRedColor]];
    
    [btLogout addTarget:self action:@selector(logoutTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview: btLogout];
    //[btnList addTarget:self action:@selector(listButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        
    NSArray *constraints1= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[btLogout(<=300)]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btLogout)];
    NSArray *constraints2= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[btLogout(==40)]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btLogout)];
        
    [footerView addConstraints:constraints1];
    [footerView addConstraints:constraints2];
    

    
    
    
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    tableview.delegate = self;
    tableview.scrollEnabled = NO;
    tableview.dataSource = self;
    tableview.tableFooterView = footerView;
    //tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [tableview addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    

    [sclView addSubview:tableview];
    
    [sclView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getUserInfo)];
    

    //按钮居中
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btLogout attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    
    self.sectionList = [[NSMutableArray alloc] init];
    [self.sectionList addObject:@{@"title":@"基本信息",@"image":@"user-icon1.png"}];
    [self.sectionList addObject:@{@"title":@"身份证信息",@"image":@"user-icon2.png"}];
    
    self.list = [[NSMutableArray alloc] init];
    
    [self renderPage];
    [self getUserInfo];

}

-(void) logoutTouched:(id) sender{
    

    UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:@"系统提示" message:@"确定要退出吗？" preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        [BWCommon logout];
        [self presentLoginView];

    }];
    UIAlertAction* no=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    [alertVc addAction:ok];
    [alertVc addAction:no];
    [self presentViewController:alertVc animated:YES completion:nil];
    
}

-(void) presentLoginView{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    id mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginIdentifier"];
    [self presentViewController:mainViewController animated:YES completion:^{}];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //将UITableview的高度设置为内容的大小
    CGRect frame = self.tableview.frame;
    frame.size = self.tableview.contentSize;

    self.tableview.frame = frame;
    self.sclView.contentSize = CGSizeMake(frame.size.width,frame.size.height+220);

}

- (NSDictionary *) createRow:(NSString *) title  text: (NSString *) text icon: (NSString *) icon{
    
    NSDictionary *row = [[NSMutableDictionary alloc] initWithObjectsAndKeys:title,@"title",text,@"text", icon,@"icon", nil];
    return row;
}
-(NSString *) fetchData:(NSString *)key{
    NSString *value = [self.userinfo objectForKey:key];
    if (![value isEqual:[NSNull null]] ){
        return value;
    }
    return @"";
}

- (void) renderPage{


    NSMutableArray *menus0 = [[NSMutableArray alloc] init];
    
    
    if([self fetchData:@"real_name"])
        self.usernameLabel.text = [NSString stringWithFormat:@"%@(编号%@)",[self fetchData:@"real_name"],[self fetchData:@"uid_hj"]];
    
    NSString *avatar = [self fetchData:@"avatar"];
    
    if(avatar){
        [self.faceImage sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"user-face"]];
    }
    
    [menus0 addObject:[self createRow:@"手机：" text:[self fetchData:@"link_mobile"] icon:nil]];
    [menus0 addObject:[self createRow:@"生日：" text:[self fetchData:@"birthday"] icon:nil]];
    
    NSInteger gender = [[self fetchData:@"gender"] integerValue];
    
    [menus0 addObject:[self createRow:@"性别：" text: (gender==1?@"男":@"女") icon:nil]];
    
    
    NSMutableArray *menus1 = [[NSMutableArray alloc] init];
    
    NSString *realName =[self fetchData:@"real_name"];
    
    if(![realName isEqualToString:@""]){
        NSRange range0 = NSMakeRange(1, 1);
        realName = [realName stringByReplacingCharactersInRange:range0 withString:@"*"];
    }
    
    [menus1 addObject:[self createRow:@"真实姓名：" text:realName icon:nil]];
    
    NSString *idCard =[self fetchData:@"id_card"];
    
    if(![idCard isEqualToString:@""] && [idCard length] == 18){
        NSRange range1 = NSMakeRange(6, 8);
        idCard = [idCard stringByReplacingCharactersInRange:range1 withString:@"********"];
    }
    
    [menus1 addObject:[self createRow:@"身份证号：" text:idCard icon:nil]];
    
    NSString *idCardTime = [NSString stringWithFormat:@"%@至%@",[self fetchData:@"id_card_start"],[self fetchData:@"id_card_end"]];
    [menus1 addObject:[self createRow:@"有效期限：" text:idCardTime icon:nil]];
    
    NSMutableArray *menus2 = [[NSMutableArray alloc] init];
    
    [menus2 addObject:[self createRow:@"联系方式" text:@"" icon:@"user-icon3.png"]];
    [menus2 addObject:[self createRow:@"营业信息" text:@"" icon:@"user-icon4.png"]];
    [menus2 addObject:[self createRow:@"收货地址管理" text:@"" icon:@"user-icon5.png"]];
    [menus2 addObject:[self createRow:@"售后管理" text:@"" icon:@"user-icon6.png"]];
    [menus2 addObject:[self createRow:@"密码管理" text:@"" icon:@"user-icon7.png"]];
    

    
    self.list[0] = menus0;
    self.list[1] = menus1;
    self.list[2] = menus2;
    
    self.statusFrames = nil;
    
    NSLog(@"%@",self.userinfo);
    
    [self.tableview reloadData];
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
            [self renderPage];
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


- (NSArray *)statusFrames
{
    if (_statusFrames == nil) {
        
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:self.list.count];
        
        for (int i=0;i < self.list.count;i++){
            
            NSMutableArray *tmp = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dict in [self.list objectAtIndex:i]) {
                // 创建模型
                MyTableViewFrame *vf = [[MyTableViewFrame alloc] init];
                vf.data = dict;
                //NSLog(@"%@",dict);
                [tmp addObject:vf];
            }
            
            
            [models addObject:tmp];
        }
        self.statusFrames = [models copy];
    }
    

    return _statusFrames;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return [self.sectionList count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return [[self.list objectAtIndex:section] count];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if(section <2)
        return 15;
    else
        return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section < 2)
        return 50;
    
    return 0;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    if(section < 2){
        headerView.frame = CGRectMake(0, 0, size.width, 50);
        headerView.backgroundColor = [UIColor whiteColor];
        NSString *imageName = [[self.sectionList objectAtIndex:section] objectForKey:@"image"];
        UIImage* icon = [UIImage imageNamed:imageName];

        UIImageView * iconView = [[UIImageView alloc] initWithImage:icon];
        [headerView addSubview:iconView];
        iconView.frame = CGRectMake(10, 10, 30, 30);

        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 20, 100, 20)];
        [headerView addSubview:nameLabel];

        nameLabel.text = [[self.sectionList objectAtIndex:section] objectForKey:@"title"];
    
        [headerView sizeToFit];
    
        [BWCommon setTopBorder:headerView color:[BWCommon getBorderColor]];
        [BWCommon setBottomBorder:headerView color:[BWCommon getBorderColor]];
    
    }
    return headerView;
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [BWCommon getBackgroundColor];
    return footView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MyTableViewCell * cell = [MyTableViewCell cellWithTableView:tableView];
    
    
    //NSLog(@"%@",self.statusFrames[indexPath.section][indexPath.row]);
    cell.viewFrame = self.statusFrames[indexPath.section][indexPath.row];
    
    cell.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
    if(indexPath.section == 0){
        if(indexPath.row>0){
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user-edit"]];
            [cell.contentView addSubview:icon];
            
            if(indexPath.row==1){
                icon.frame = CGRectMake(184, 12, 24, 24);
            }else{
                icon.frame = CGRectMake(120, 12, 24, 24);
            }
        }
    }
    else if(indexPath.section==2){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    
    return cell;

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        if(indexPath.row==1){
            [self editBirthday];
        }else if(indexPath.row==2){
            [self editGender];
        }
    }
    else if (indexPath.section == 2){
        
        if(indexPath.row == 0){
            MyContactWayViewController *viewController = [[MyContactWayViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if(indexPath.row == 1){
            MyBusinessInfoViewController *viewController = [[MyBusinessInfoViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if(indexPath.row == 2){
            MyAddressViewController *viewController = [[MyAddressViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if(indexPath.row == 3){
            MyAfterSalesViewController *viewController = [[MyAfterSalesViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if(indexPath.row == 4){
            MyPasswordViewController *viewController = [[MyPasswordViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        

    }
    
    [tableview deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (void) editGender{
 
    UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];

    UIAlertAction* male=[UIAlertAction actionWithTitle:@"男" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        [self updateProfile:@"gender" field_vale:@"1"];
    }];
    
    UIAlertAction* female=[UIAlertAction actionWithTitle:@"女" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        [self updateProfile:@"gender" field_vale:@"2"];
    }];
    
    UIAlertAction* no=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    [alertVc addAction:male];
    [alertVc addAction:female];
    [alertVc addAction:no];
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void) editBirthday{
    
    UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIDatePicker* datePicker=[[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        NSDate* date=[datePicker date];
        NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString* curentDatest=[formatter stringFromDate:date];
        
        [self updateProfile:@"birthday" field_vale:curentDatest];
    }];

    UIAlertAction* no=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    [alertVc.view addSubview:datePicker];
    [alertVc addAction:ok];
    [alertVc addAction:no];
    [self presentViewController:alertVc animated:YES completion:nil];
}


- (void)updateProfile: (NSString *)field_name field_vale:(NSString *) field_value
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;

    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"user/saveContactInfo"];
    NSMutableDictionary *postData = [BWCommon getTokenData:@"user/saveContactInfo"];
    

    [postData setValue:field_value forKey:field_name];
    [postData setValue:[self fetchData:@"gender"] forKey:@"gender"];
    [postData setValue:[self fetchData:@"link_man"] forKey:@"link_man"];
    [postData setValue:[self fetchData:@"link_mobile"] forKey:@"link_mobile"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        [hud removeFromSuperview];
        if(errNo == 0)
        {
            [self.userinfo setValue:field_value forKey:field_name];
            [self renderPage];
        }
        else
        {
            NSLog(@"%@",[responseObject objectForKey:@"error"]);
            
            [alert setMessage:[responseObject objectForKey:@"error"]];
            [alert show];
        }
        
    } fail:^{
        [hud removeFromSuperview];
        [alert setMessage:@"连接超时，请重试"];
        [alert show];
        NSLog(@"请求失败");
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
