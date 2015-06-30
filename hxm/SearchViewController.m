//
//  SearchViewController.m
//  hxm
//
//  Created by Bruce He on 15/6/30.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "SearchViewController.h"
#import "BWCommon.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
}

- (void) pageLayout{
    
    self.view.backgroundColor = [BWCommon getBackgroundColor];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, size.width, size.height)];
    sclView.backgroundColor = [BWCommon getBackgroundColor];
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width,900);
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 70)];
    headView.backgroundColor = [BWCommon getRGBColor:0xffffff];
    
    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(20, 30, size.width - 90, 30)];
    searchField.layer.cornerRadius = 5.0f;
    searchField.borderStyle = UITextBorderStyleRoundedRect;
    //[searchField.layer setBorderWidth:1.0f];
    //[searchField.layer setBorderColor:[BWCommon getBorderColor].CGColor];
    searchField.placeholder = @"请输入关键词搜索";
    [searchField setBackgroundColor:[BWCommon getBackgroundColor]];
    searchField.font = [UIFont systemFontOfSize:14];
    searchField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    searchField.leftViewMode = UITextFieldViewModeAlways;
    searchField.clearButtonMode=UITextFieldViewModeWhileEditing;
    searchField.delegate = self;
    
    NSString *keyword = [BWCommon getUserInfo:@"keyword"];
    searchField.text = keyword;
    
    
    [headView addSubview:searchField];
    
    [searchField becomeFirstResponder];
    
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width - 70, 36, 60, 20)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[BWCommon getMainColor] forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    
    [headView addSubview:cancelButton];
    
    [cancelButton addTarget:self action:@selector(cancelTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:headView];
    [self.view addSubview:sclView];
    
    UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
    hotLabel.text  = @"热门搜索";
    hotLabel.font = [UIFont systemFontOfSize:14];
    hotLabel.textColor = [BWCommon getRGBColor:0x666666];
    
    UIView *hotView = [[UIView alloc] initWithFrame:CGRectMake(10, 40, size.width-20, 80)];
    //hotView.backgroundColor = [UIColor whiteColor];
    
    NSUInteger swidth = (size.width - 20)/ 3 - 2;
    
    UIButton *hot1 = [self createTextButton:@"玫瑰"];
    hot1.frame = CGRectMake(0, 0, swidth, 30);
    
    UIButton *hot2 = [self createTextButton:@"卡罗拉"];
    hot2.frame = CGRectMake(swidth+2, 0, swidth, 30);
    
    UIButton *hot3 = [self createTextButton:@"百合"];
    hot3.frame = CGRectMake(swidth*2+4, 0, swidth, 30);
    
    [hotView addSubview:hot1];
    [hotView addSubview:hot2];
    [hotView addSubview:hot3];
    
    [sclView addSubview:hotLabel];
    [sclView addSubview:hotView];
}

- (UIButton *) createTextButton:(NSString *) title{
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[BWCommon getRGBColor:0x444444] forState:UIControlStateNormal];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button addTarget:self action:@selector(textButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    
    [BWCommon setUserInfo:@"keyword" value:textField.text];
    [self backToView];
    return YES;
}

- (void) textButtonTouched: (UIButton *)sender{
    NSLog(@"%@",sender.titleLabel.text);
    
    
    [BWCommon setUserInfo:@"keyword" value:sender.titleLabel.text];
    [self backToView];
}

- (void) cancelTouched:(id) sender{
    [BWCommon setUserInfo:@"keyword" value:@""];
    [self backToView];
}
-(void) backToView{
    [self dismissViewControllerAnimated:NO completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"do" object:self];
    }];
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

@end
