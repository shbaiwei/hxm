//
//  OrderCommentViewController.m
//  hxm
//
//  Created by Bruce He on 15/6/4.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "OrderNoteViewController.h"
#import "BWCommon.h"

@interface OrderNoteViewController ()

@property (nonatomic,weak) UILabel *orderNoValue;
@property (nonatomic,weak) UIScrollView *sclView;

@end

@implementation OrderNoteViewController

NSString *order_no;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
}

- (void) pageLayout{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title = @"订单备注";
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    sclView.backgroundColor = [BWCommon getBackgroundColor];
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width,700);
    self.sclView = sclView;
    
    [self.view addSubview:sclView];
    
    NSUInteger padding = 15;
    UILabel *orderNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, 80, 20)];
    UILabel *orderNoValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding+80, padding, 200, 20)];
    
    orderNoLabel.text = @"订单编号：";
    orderNoLabel.font = [UIFont systemFontOfSize:16];
    
    self.orderNoValue = orderNoValueLabel;
    self.orderNoValue.text = order_no;
    
    
    [sclView addSubview:orderNoLabel];
    [sclView addSubview:orderNoValueLabel];
    
    UITextView *noteView = [[UITextView alloc] initWithFrame:CGRectMake(padding, 69, size.width-padding*2, 120)];
    
    [sclView addSubview:noteView];
    
    noteView.text = @"输入备注的内容";
    
    noteView.layer.cornerRadius = 5.0f;
    noteView.layer.borderWidth = 1.0f;
    [noteView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [noteView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *submitButton = [self footerButton:@"提交备注" bgColor:[UIColor colorWithRed:219/255.0f green:0/255.0f blue:0 alpha:1]];
    
    [submitButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.frame = CGRectMake(padding, 200, size.width-padding*2 , 40);
    [sclView addSubview:submitButton];
    
    
}

- (void) buttonTouched:(id)sender{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert setMessage:@"备注接口还未开放"];
    [alert show];
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

-(void) setValue:(NSString *)detailValue{
    order_no = detailValue;
    
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
