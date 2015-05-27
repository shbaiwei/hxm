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

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
}

- (void) pageLayout{
    
    UIColor *bgColor = [BWCommon getBackgroundColor];
    self.view.backgroundColor = bgColor;
    
    NSLog(@"%@",[BWCommon getUserInfo:@"uid"]);
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
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
    
    UILabel *user_number = [[UILabel alloc] initWithFrame:CGRectMake(0, (topView.bounds.size.height)-30, size.width, 20)];
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
    
    UILabel *baseinfo_telephone = [[UILabel alloc] initWithFrame:CGRectMake(baseinfo_title.frame.origin.x, baseinfo_line1.frame.origin.y+10, 200, 30)];
    baseinfo_telephone.text = @"手机：15221966658";
    [baseinfo_view addSubview:baseinfo_telephone];
    
    UILabel *baseinfo_line2 = [[UILabel alloc] initWithFrame:CGRectMake(baseinfo_telephone.frame.origin.x, baseinfo_telephone.frame.origin.y+30+10, size.width, 0.5)];
    baseinfo_line2.backgroundColor = [UIColor grayColor];
    [baseinfo_view addSubview:baseinfo_line2];
    
    UILabel *baseinfo_birthday = [[UILabel alloc] initWithFrame:CGRectMake(baseinfo_title.frame.origin.x, baseinfo_line2.frame.origin.y+10, 150, 30)];
    baseinfo_birthday.text = @"生日：1985-01-25";
    [baseinfo_view addSubview:baseinfo_birthday];
    
    UIButton *baseinfo_birthday_edit = [[UIButton alloc] initWithFrame:CGRectMake(baseinfo_birthday.frame.origin.x+baseinfo_birthday.frame.size.width+10, baseinfo_birthday.frame.origin.y+5, 20, 20)];
    [baseinfo_birthday_edit setBackgroundImage:[UIImage imageNamed:@"user-edit"] forState:UIControlStateNormal];
    baseinfo_birthday_edit.tag = 1;
    [baseinfo_birthday_edit addTarget:self action:@selector(do_action:) forControlEvents:UIControlEventTouchUpInside];
    [baseinfo_view addSubview:baseinfo_birthday_edit];
    
    UILabel *baseinfo_line3 = [[UILabel alloc] initWithFrame:CGRectMake(baseinfo_birthday.frame.origin.x, baseinfo_birthday.frame.origin.y+30+10, size.width, 0.5)];
    baseinfo_line3.backgroundColor = [UIColor grayColor];
    [baseinfo_view addSubview:baseinfo_line3];
    
    UILabel *baseinfo_sex = [[UILabel alloc] initWithFrame:CGRectMake(baseinfo_birthday.frame.origin.x, baseinfo_line3.frame.origin.y+10, 75, 30)];
    baseinfo_sex.text = @"性别：男";
    [baseinfo_view addSubview:baseinfo_sex];
    
    UIButton *baseinfo_sex_edit = [[UIButton alloc] initWithFrame:CGRectMake(baseinfo_sex.frame.origin.x+baseinfo_sex.frame.size.width+10, baseinfo_sex.frame.origin.y+5, 20, 20)];
    [baseinfo_sex_edit setBackgroundImage:[UIImage imageNamed:@"user-edit"] forState:UIControlStateNormal];
    baseinfo_sex_edit.tag = 2;
    [baseinfo_sex_edit addTarget:self action:@selector(do_action:) forControlEvents:UIControlEventTouchUpInside];
    [baseinfo_view addSubview:baseinfo_sex_edit];
   
    
    //身份证信息view
    UIView *idcard_view = [[UIView alloc] initWithFrame:CGRectMake(0, baseinfo_view.frame.origin.y+baseinfo_view.bounds.size.height+15, size.width+1, 230)];
    idcard_view.backgroundColor = [UIColor whiteColor];
    idcard_view.layer.borderWidth = 0.5;
    idcard_view.layer.borderColor = [[UIColor grayColor] CGColor];
    [sclView addSubview:idcard_view];
    
    UIImageView *id_card_image =[[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 44, 44)];
    [id_card_image setImage:[UIImage imageNamed:@"user-icon2"]];
    
    UILabel *id_card_title = [[UILabel alloc] initWithFrame:CGRectMake(74, 15, 100, id_card_image.frame.size.height)];
    id_card_title.text = @"身份证信息";
    
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
    //其他功能view
    UIView *other_view = [[UIView alloc] initWithFrame:CGRectMake(0, idcard_view.frame.origin.y+idcard_view.bounds.size.height+15, size.width+1, 64*5+20)];
    other_view.backgroundColor = [UIColor whiteColor];
    other_view.layer.borderWidth = 0.5;
    other_view.layer.borderColor = [[UIColor grayColor] CGColor];
    [sclView addSubview:other_view];
    
    NSArray *titleArray = [[NSArray alloc] initWithObjects: @"联系方式", @"营业信息", @"收货地址管理", @"售后管理", @"密码管理", nil];
    NSArray *imageArray =[[NSArray alloc] initWithObjects:@"user-icon3", @"user-icon4", @"user-icon5" ,@"user-icon6" ,@"user-icon7" ,nil];
    NSInteger y_size = 0;
    UIView *other_small_view;
    UIImageView *image_icon;
    UILabel *title_label;
    UIImageView *right_icon;
    UILabel *line_label;
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    for(int i = 0; i < [titleArray count]; i++)
    {
        
        other_small_view = [[UIView alloc] initWithFrame:CGRectMake(0, y_size, size.width, 64)];
        //other_small_view.backgroundColor = [UIColor redColor];
        image_icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 44, 44)];
        [image_icon setImage:[UIImage imageNamed:imageArray[i]]];
       
        
        title_label = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 200, 44)];
        [title_label setText:titleArray[i]];
        //title_label.tag = 10+i;
        //title_label.userInteractionEnabled = YES;
        //[title_label addGestureRecognizer:singleTap];
        
        right_icon = [[UIImageView alloc] initWithFrame:CGRectMake(size.width-20, 20, 11, 20)];
        [right_icon setImage:[UIImage imageNamed:@"user-right-array"]];
        
        line_label = [[UILabel alloc] initWithFrame:CGRectMake(title_label.frame.origin.x, 55, size.width-80, 0.5)];
        line_label.backgroundColor = [UIColor grayColor];
        
        [other_small_view addSubview:image_icon];
        [other_small_view addSubview:title_label];
        [other_small_view addSubview:right_icon];
        [other_small_view addSubview:line_label];
        other_small_view.tag = 10 +i;
        other_small_view.userInteractionEnabled = YES;
        [other_small_view addGestureRecognizer:singleTap];
        //[other_small_view setTag:10+i];
        [other_view addSubview:other_small_view];
        
        y_size += 64;
        
    }
    
    //exit button
    UIButton *exit_button = [UIButton buttonWithType:UIButtonTypeCustom];
    exit_button.frame = CGRectMake(10, other_view.frame.origin.y+other_view.bounds.size.height+30, size.width-20, 50);
    [exit_button setTag:30];
    [exit_button.layer setMasksToBounds:YES];
    [exit_button.layer setCornerRadius:5.0];
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
//操作集合
- (void)do_action:(UIView *)sender
{
    NSLog(@"do action");
    switch (sender.tag) {
        case 1: //eidt birthday
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"system message" message:@"edit birthday" delegate:nil cancelButtonTitle:@"confirm" otherButtonTitles: nil];
            [alert show];
            NSLog(@"edit birthday");
            break;
        }
        case 2: //edit sex
        {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"system message" message:@"edit sex" delegate:nil cancelButtonTitle:@"confirm" otherButtonTitles: nil];
            [alert show];
            NSLog(@"edit sex");
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
    if (buttonIndex == 0) {
        NSLog(@"confirm");
        LoginViewController *login_controller = [[LoginViewController alloc] init];
        [login_controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentViewController:login_controller animated:YES completion:nil];
    }else if (buttonIndex == 1) {
        NSLog(@"cancel");
    }
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}


-(void)handleSingleTap:(UITapGestureRecognizer *)sender

{
    UIView *uiview = sender.view;
    NSLog(@"%ld",(long)uiview.tag);
    
    CGPoint point = [sender locationInView:self.view];
    
    NSLog(@"handleSingleTap!pointx:%f,y:%f",point.x,point.y);
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    
    return YES;
    
}
@end
