//
//  MyViewController.m
//  hxm
//
//  Created by Bruce He on 15-5-21.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "MyViewController.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"
#import "LoginViewController.h"
#import "MyContactWayViewController.h"
#import "MyBusinessInfoViewController.h"
#import "MyAddressViewController.h"
#import "MyAfterSalesViewController.h"
#import "MyPasswordViewController.h"

@interface MyViewController ()
{
    UILabel *user_number;
    UILabel *baseinfo_telephone;
    UILabel *baseinfo_birthday;
    UILabel *baseinfo_sex;
    UIView *idcard_view;
    CGSize size;
    NSDictionary *userinfo;
}
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self pageLayout];
    [self getUserInfo];
}

- (void) pageLayout{
    
    UIColor *bgColor = [BWCommon getBackgroundColor];
    self.view.backgroundColor = bgColor;
    
    NSLog(@"%@",[BWCommon getUserInfo:@"uid"]);
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    
    
    
   [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackTranslucent];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
    //self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    self.navigationController.navigationBarHidden = YES;
    
    //self.title = @"我的";
    //self.navigationController.title = @"我的";
    
    UIImageView *topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user-bg.jpg"]];
    topView.frame = CGRectMake(0, 0, size.width, 160);
    [self.view addSubview:topView];
    
    
    UILabel *bar_title =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, topView.bounds.size.height/2)];
    bar_title.text = @"我的";
    bar_title.textAlignment = NSTextAlignmentCenter;
   // bar_title.backgroundColor = [UIColor clearColor];
    bar_title.textColor = [UIColor whiteColor];
   // bar_title.font = [UIFont fontWithName:@"Helvetica" size:14];
   // [bar_title setTextColor:[UIColor colorWithRed:0.0/255.0 green:140.0/255.0 blue:199.0/255.0 alpha:1.0]];
   // [bar_title setFont:[UIFont fontWithName:@"HelveticaNeueLTStd-ThCn" size:35]];
    [self.view addSubview:bar_title];
    
     
    user_number = [[UILabel alloc] initWithFrame:CGRectMake(0, (topView.bounds.size.height)-30, size.width, 20)];
    user_number.text = @"87290008(编号00176)";
    user_number.textAlignment = NSTextAlignmentCenter;
    user_number.textColor = [UIColor whiteColor];
    [self.view addSubview:user_number];
    
    UIImageView *user_face = [[UIImageView alloc] initWithFrame:CGRectMake(10, topView.frame.size.height-80, 80, 80)];
    [user_face.layer setCornerRadius:30.0];
    [user_face setImage:[UIImage imageNamed:@"user-face"]];
    [self.view addSubview:user_face];
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 160, size.width, size.height-160)];
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width, size.height+400);
    [self.view addSubview:sclView];
    //基础信息view
    UIView *baseinfo_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width+1, 220)];
    baseinfo_view.backgroundColor = [UIColor whiteColor];
    baseinfo_view.layer.borderWidth = 0.5;
    baseinfo_view.layer.borderColor = [[UIColor grayColor] CGColor];
    [sclView addSubview:baseinfo_view];
    
    UIImageView *baseinfo_image = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 44, 44)];
    [baseinfo_image setImage:[UIImage imageNamed:@"user-icon1"]];
    [baseinfo_view addSubview:baseinfo_image];
    
    UILabel *baseinfo_title = [[UILabel alloc] initWithFrame:CGRectMake(20+44+10, 15, 200, 44)];
    baseinfo_title.text = @"基本信息";
    [baseinfo_view addSubview:baseinfo_title];
    
    UILabel *baseinfo_line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 15+44+10, size.width, 0.5)];
    baseinfo_line1.backgroundColor = [UIColor grayColor];
    [baseinfo_view addSubview:baseinfo_line1];
    
    baseinfo_telephone = [[UILabel alloc] initWithFrame:CGRectMake(baseinfo_title.frame.origin.x, baseinfo_line1.frame.origin.y+10, 300, 30)];
    //baseinfo_telephone.text = @"手机：15221966658";
    [baseinfo_view addSubview:baseinfo_telephone];
    
    UILabel *baseinfo_line2 = [[UILabel alloc] initWithFrame:CGRectMake(baseinfo_telephone.frame.origin.x, baseinfo_telephone.frame.origin.y+30+10, size.width, 0.5)];
    baseinfo_line2.backgroundColor = [UIColor grayColor];
    [baseinfo_view addSubview:baseinfo_line2];
    
    baseinfo_birthday = [[UILabel alloc] initWithFrame:CGRectMake(baseinfo_title.frame.origin.x, baseinfo_line2.frame.origin.y+10, 150, 30)];
   // baseinfo_birthday.text = @"生日：1985-01-25";
    [baseinfo_view addSubview:baseinfo_birthday];
    
    UIButton *baseinfo_birthday_edit = [[UIButton alloc] initWithFrame:CGRectMake(baseinfo_birthday.frame.origin.x+baseinfo_birthday.frame.size.width+10, baseinfo_birthday.frame.origin.y+5, 20, 20)];
    [baseinfo_birthday_edit setBackgroundImage:[UIImage imageNamed:@"user-edit"] forState:UIControlStateNormal];
    baseinfo_birthday_edit.tag = 1;
    [baseinfo_birthday_edit addTarget:self action:@selector(do_action:) forControlEvents:UIControlEventTouchUpInside];
    [baseinfo_view addSubview:baseinfo_birthday_edit];
    
    UILabel *baseinfo_line3 = [[UILabel alloc] initWithFrame:CGRectMake(baseinfo_birthday.frame.origin.x, baseinfo_birthday.frame.origin.y+30+10, size.width, 0.5)];
    baseinfo_line3.backgroundColor = [UIColor grayColor];
    [baseinfo_view addSubview:baseinfo_line3];
    
    baseinfo_sex = [[UILabel alloc] initWithFrame:CGRectMake(baseinfo_birthday.frame.origin.x, baseinfo_line3.frame.origin.y+10, 75, 30)];
    //baseinfo_sex.text = @"性别：男";
    [baseinfo_view addSubview:baseinfo_sex];
    
    UIButton *baseinfo_sex_edit = [[UIButton alloc] initWithFrame:CGRectMake(baseinfo_sex.frame.origin.x+baseinfo_sex.frame.size.width+10, baseinfo_sex.frame.origin.y+5, 20, 20)];
    [baseinfo_sex_edit setBackgroundImage:[UIImage imageNamed:@"user-edit"] forState:UIControlStateNormal];
    baseinfo_sex_edit.tag = 2;
    [baseinfo_sex_edit addTarget:self action:@selector(do_action:) forControlEvents:UIControlEventTouchUpInside];
    [baseinfo_view addSubview:baseinfo_sex_edit];
   
    
    //身份证信息view
    idcard_view = [[UIView alloc] initWithFrame:CGRectMake(0, baseinfo_view.frame.origin.y+baseinfo_view.bounds.size.height+15, size.width+1, 230)];
    idcard_view.backgroundColor = [UIColor whiteColor];
    idcard_view.layer.borderWidth = 0.5;
    idcard_view.layer.borderColor = [[UIColor grayColor] CGColor];
    [sclView addSubview:idcard_view];
    
    
    
    /*
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, id_card_image.frame.origin.y+id_card_image.frame.size.height+10, size.height, 0.5)];
    line.backgroundColor = [UIColor grayColor];
    [idcard_view addSubview:id_card_image];
    [idcard_view addSubview:id_card_title];
    [idcard_view addSubview:line];
    
    
    NSArray *id_title_array = [[NSArray alloc] initWithObjects:@"真实姓名：花集网", @"身份证号：513822199010048135", @"有效期限：2013-05-17至2017-15－18", nil];
    UILabel *title_array_label;
    UILabel *card_title_line;
    NSInteger id_card_y_size = line.bounds.origin.y;
    for(int i=0;i<id_title_array.count;i++)
    {
        title_array_label = [[UILabel alloc] initWithFrame:CGRectMake(69, id_card_y_size+80, size.width, 40)];
        title_array_label.text = id_title_array[i];
        card_title_line = [[UILabel alloc] initWithFrame:CGRectMake(69, id_card_y_size+130, size.width, 0.5)];
        card_title_line.backgroundColor = [UIColor grayColor];
        [idcard_view addSubview:title_array_label];
        if(i<2)
        {
          [idcard_view addSubview:card_title_line];
        }
        
        id_card_y_size += 50;
    }
    */
    //其他功能view
    UIView *other_view = [[UIView alloc] initWithFrame:CGRectMake(0, idcard_view.frame.origin.y+idcard_view.bounds.size.height+15, size.width+1, 64*5+20)];
    other_view.backgroundColor = [UIColor whiteColor];
    other_view.layer.borderWidth = 0.5;
    other_view.layer.borderColor = [[UIColor grayColor] CGColor];
    [sclView addSubview:other_view];
    
    NSArray *titleArray = [[NSArray alloc] initWithObjects: @"联系方式", @"营业信息", @"收货地址管理", @"售后管理", @"密码管理", nil];
    NSArray *imageArray =[[NSArray alloc] initWithObjects:@"user-icon3", @"user-icon4", @"user-icon5" ,@"user-icon6" ,@"user-icon7" ,nil];
    NSInteger YY = 0 ;
    YY += 15;
    for(int i = 0; i < titleArray.count; i++)
    {
    
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, YY, 280, 65)];
        button.backgroundColor = [UIColor whiteColor];
        button.tag = 10 + i;
        [button addTarget:self action:@selector(do_action:) forControlEvents:UIControlEventTouchUpInside];
        [other_view addSubview:button];
        
        UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 44, 44)];
        headImageView.image = [UIImage imageNamed:imageArray[i]];
        [button addSubview:headImageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(75, 5, 130, 44)];
        label.text = titleArray[i];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
       // label.font = [UIFont systemFontOfSize:15];
        [button addSubview:label];
        
        if(i != titleArray.count-1)
        {
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x, 50, size.width, 0.5)];
            label2.backgroundColor = [UIColor grayColor];
            [button addSubview:label2];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(size.width-30, 22, 10, 13)];
        imageView.image = [UIImage imageNamed:@"user-right-array"];
        [button addSubview:imageView];
        YY += 65;
    }
    //exit button
    UIButton *exit_button = [UIButton buttonWithType:UIButtonTypeCustom];
    exit_button.frame = CGRectMake(10, other_view.frame.origin.y+other_view.bounds.size.height+30, size.width-20, 40);
    [exit_button setTag:30];
    [exit_button.layer setMasksToBounds:YES];
    [exit_button.layer setCornerRadius:3.0];
    [exit_button setTintColor:[UIColor whiteColor]];
    [exit_button setBackgroundColor:[UIColor redColor]];
    [exit_button setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [exit_button addTarget:self action:@selector(do_action:) forControlEvents:UIControlEventTouchUpInside];
    [sclView addSubview:exit_button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) getUserInfo
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"user/getUserInfoById"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"user/getUserInfoById"];
    
    NSString *user_id = [BWCommon getUserInfo:@"uid"];
    NSLog(@"uid:%@",user_id);
    [postData setValue:[NSString stringWithFormat:@"%@",user_id] forKey:@"uid"];

    
    NSLog(@"%@",url);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
       // NSLog(@"userinfo:%@",responseObject);
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        [hud removeFromSuperview];
        if(errNo == 0)
        {
            userinfo = [responseObject objectForKey:@"data"];
            NSLog(@"userinfo:%@",userinfo);
            user_number.text = [NSString stringWithFormat:@"%@(编号%@)",[userinfo objectForKey:@"real_name"],[userinfo objectForKey:@"uid_hj"]];
            baseinfo_telephone.text = [NSString stringWithFormat:@"手机：%@",[userinfo objectForKey:@"link_mobile"]];
            baseinfo_birthday.text = [NSString stringWithFormat:@"生日：%@",[userinfo objectForKey:@"birthday"]];
            NSString *gender = [userinfo objectForKey:@"gender"];
            if([gender isEqualToString:@"1"])
            {
                baseinfo_sex.text = @"性别：男";
            }
            else
            {
                baseinfo_sex.text = @"性别：女";
            }
            
            /*身份证信息部分填充*/
            UIImageView *id_card_image =[[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 44, 44)];
            [id_card_image setImage:[UIImage imageNamed:@"user-icon2"]];
            
            UILabel *id_card_title = [[UILabel alloc] initWithFrame:CGRectMake(74, 15, 100, id_card_image.frame.size.height)];
            id_card_title.text = @"身份证信息";
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, id_card_image.frame.origin.y+id_card_image.frame.size.height+10, size.height, 0.5)];
            line.backgroundColor = [UIColor grayColor];
            [idcard_view addSubview:id_card_image];
            [idcard_view addSubview:id_card_title];
            [idcard_view addSubview:line];
            
            NSString *real_name = [NSString stringWithFormat:@"真实姓名：%@",[userinfo objectForKey:@"real_name"]];
            NSString *id_card = [NSString stringWithFormat:@"身份证号：%@",[userinfo objectForKey:@"id_card"]];
            NSString *idcard_time = [NSString stringWithFormat:@"有效期限：%@至%@",[userinfo objectForKey:@"id_card_start"],[userinfo objectForKey:@"id_card_end"]];
            NSArray *id_title_array = [[NSArray alloc] initWithObjects:real_name, id_card, idcard_time, nil];
            UILabel *title_array_label;
            UILabel *card_title_line;
            NSInteger id_card_y_size = line.bounds.origin.y;
            for(int i=0;i<id_title_array.count;i++)
            {
                title_array_label = [[UILabel alloc] initWithFrame:CGRectMake(69, id_card_y_size+80, size.width, 40)];
                title_array_label.text = id_title_array[i];
                card_title_line = [[UILabel alloc] initWithFrame:CGRectMake(69, id_card_y_size+130, size.width, 0.5)];
                card_title_line.backgroundColor = [UIColor grayColor];
                [idcard_view addSubview:title_array_label];
                if(i<2)
                {
                    [idcard_view addSubview:card_title_line];
                }
                
                id_card_y_size += 50;
            }
            /*身份证信息部分填充 end*/
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

//操作集合
- (void)do_action:(UIView *)sender
{
    //NSLog(@"do action");
    NSLog(@"%ld",sender.tag);
    switch (sender.tag) {
        case 1: //eidt birthday
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"system message" message:@"edit birthday" delegate:nil cancelButtonTitle:@"confirm" otherButtonTitles: nil];
            alert.tag = 60;
            [alert show];
            NSLog(@"edit birthday");
            break;
        }
        case 2: //edit sex
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:@"请选择性别"
                                          delegate:self
                                          cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:@"男",@"女",nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            actionSheet.tag = 11;
            [actionSheet showInView:self.view];
            NSLog(@"edit sex");
            break;
        }
        case 10: //联系方式 
        {
            MyContactWayViewController *page = [[MyContactWayViewController alloc] init];
            page.userinfo = userinfo;
            [self.navigationController pushViewController:page animated:YES];
            // [page setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            //[self presentViewController:page animated:YES completion:nil];
            break;
        }
        case 11: //营业信息
        {
            MyBusinessInfoViewController *page = [[MyBusinessInfoViewController alloc] init];
            [self.navigationController pushViewController:page animated:YES];
            break;
        }
        case 12: //收货地址管理
        {
            MyAddressViewController *page = [[MyAddressViewController alloc] init];
            [self.navigationController pushViewController:page animated:YES];
            break;
        }
        case 13: //售后管理
        {
            MyAfterSalesViewController *page = [[MyAfterSalesViewController alloc] init];
            [self.navigationController pushViewController:page animated:YES];
            break;
        }
        case 14: //密码管理
        {
            MyPasswordViewController *page = [[MyPasswordViewController alloc] init];
            page.mobile = [userinfo objectForKey:@"link_mobile"];
            [self.navigationController pushViewController:page animated:YES];
            break;
        }
        case 30: //exit button action
        {
            NSLog(@"do exit action");
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:@"确认要退出吗？"
                                          delegate:self
                                          cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:@"确定"
                                          otherButtonTitles:nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            actionSheet.tag = 12;
            [actionSheet showInView:self.view];
          
            break;
        }
        default:
            NSLog(@"other");
            break;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case 11: //choose sex action
            NSLog(@"%ld",(long)buttonIndex);
            break;
        case 12: //exit action
        {
            if (buttonIndex == 0) {
                NSLog(@"confirm");
                LoginViewController *login_controller = [[LoginViewController alloc] init];
                [login_controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                [self presentViewController:login_controller animated:YES completion:nil];
            }else if (buttonIndex == 1) {
                NSLog(@"cancel");
            }

        }
            break;
        default:
            break;
    }
    }
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}



@end
