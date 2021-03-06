//
//  OrderDetailViewController.m
//  hxm
//
//  Created by Bruce on 15-6-1.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderCommentViewController.h"
#import "OrderNoteViewController.h"
#import "OrderComplainViewController.h"
#import "BWCommon.h"
#import "MJRefresh.h"
#import "AFNetworkTool.h"
#define NJNameFont [UIFont systemFontOfSize:14]

@interface OrderDetailViewController ()

@property (nonatomic,weak) UILabel * orderNoValue;
@property (nonatomic,weak) UILabel * orderFeeValue;
@property (nonatomic,weak) UILabel * orderTimeValue;
@property (nonatomic,weak) UILabel * orderStatusValue;
@property (nonatomic,weak) UILabel * orderAddressValue;
@property (nonatomic,weak) UILabel * trackerValue;
@property (nonatomic,weak) UIButton * payButton;
@property (nonatomic,weak) UIButton * commentButton;

@property (nonatomic,retain) XCMultiTableView * tableView;

@property (nonatomic,retain) UIScrollView *sclView;

@end

@implementation OrderDetailViewController

NSString *order_no;

NSMutableArray *headData;
NSMutableArray *leftTableData;
NSMutableArray *rightTableData;

BOOL canRate = YES;
BOOL canPayment = YES;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self pageLayout];
}

- (void)viewDidAppear:(BOOL)animated{
    
    
    //快速清理堆栈
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    
    NSInteger i = [navigationArray count];
    i-=2;
    while (i>0) {
        [navigationArray removeObjectAtIndex:i];
        i--;
    }
    self.navigationController.viewControllers = navigationArray;
}

- (void) pageLayout{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title = @"订单详细";
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.image=[UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem=backItem;
    
    [self.navigationItem.backBarButtonItem setTarget:self];
    [self.navigationItem.backBarButtonItem setAction:@selector(backTouched:)];

    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    sclView.backgroundColor = [BWCommon getBackgroundColor];
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width,700);
    self.sclView = sclView;
    
    [self.view addSubview:sclView];
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 80)];
    infoView.backgroundColor = [UIColor whiteColor];
    
    [sclView addSubview:infoView];
    
    NSUInteger padding = 15;
    UILabel *orderNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, 80, 20)];
    UILabel *orderNoValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding+80, padding, 200, 20)];
    
    UILabel *orderFeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding+30, 80, 20)];
    UILabel *orderFeeValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding+80, padding+30, 200, 20)];
    
    orderNoLabel.text = @"订单编号：";
    orderNoLabel.font = [UIFont systemFontOfSize:16];
    orderFeeLabel.text = @"订单金额：";
    orderFeeLabel.font = [UIFont systemFontOfSize:16];
    orderFeeValueLabel.font = [UIFont systemFontOfSize:18];
    [orderFeeValueLabel setTextColor:[UIColor colorWithRed:219/255.0f green:0/255.0f blue:0/255.0f alpha:1]];
    
    self.orderNoValue = orderNoValueLabel;
    self.orderFeeValue = orderFeeValueLabel;
    
    [infoView addSubview:orderNoLabel];
    [infoView addSubview:orderNoValueLabel];
    [infoView addSubview:orderFeeLabel];
    [infoView addSubview:orderFeeValueLabel];
    
    [BWCommon setBottomBorder:infoView color:[BWCommon getBorderColor]];
    //order status
    UIView * orderView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, size.width, 262)];
    orderView.backgroundColor = [UIColor whiteColor];
    
    [BWCommon setTopBorder:orderView color:[BWCommon getBorderColor]];
    
    [sclView addSubview:orderView];
    
    //下单时间
    
    UIView *timeView = [self createRow:@"下单时间："];
    timeView.frame = CGRectMake(0, 0, size.width, 50);
    [BWCommon setBottomBorder:timeView color:[UIColor lightGrayColor]];
    
    
    UILabel *orderTimeValue = [[UILabel alloc] initWithFrame:CGRectMake(95, 15, 200, 20)];
    self.orderTimeValue = orderTimeValue;
    orderTimeValue.font = NJNameFont;
    [timeView addSubview:orderTimeValue];
    [orderView addSubview:timeView];
    
    //当前状态
    UIView *statusView = [self createRow:@"当前状态："];
    statusView.frame = CGRectMake(0, 51, size.width, 50);
    [BWCommon setBottomBorder:statusView color:[UIColor lightGrayColor]];
    
    UILabel *orderStatusValue = [[UILabel alloc] initWithFrame:CGRectMake(95, 15, 200, 20)];
    self.orderStatusValue = orderStatusValue;
    orderStatusValue.font = NJNameFont;
    [statusView addSubview:orderStatusValue];
    [orderView addSubview:statusView];
    
    
    UIButton *payButton = [self coloredButton:@"去付款" bgColor:[UIColor colorWithRed:219/255.0f green:0/255.0f blue:0/255.0f alpha:1]];
    payButton.frame = CGRectMake(size.width - 90, 61, 80, 30);
    self.payButton = payButton;
    [payButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [orderView addSubview:payButton];
    [payButton setHidden:NO];
    
    [payButton addTarget:self action:@selector(payTouched:) forControlEvents:UIControlEventTouchUpInside];

    
    //收货地址
    UIView *addressView = [self createRow:@"收货地址："];
    addressView.frame = CGRectMake(0, 102, size.width, 80);
    [BWCommon setBottomBorder:addressView color:[UIColor lightGrayColor]];
    
    UILabel *orderAddressValue = [[UILabel alloc] initWithFrame:CGRectMake(95, 10, size.width-110, 46)];
    self.orderAddressValue = orderAddressValue;
    orderAddressValue.font = NJNameFont;
    orderAddressValue.numberOfLines = 0;
    [addressView addSubview:orderAddressValue];
    [orderView addSubview:addressView];
    
    //物流信息
    UIView *trackerView = [self createRow:@"物流信息："];
    trackerView.frame = CGRectMake(0, 183, size.width, 80);
    [BWCommon setBottomBorder:trackerView color:[UIColor lightGrayColor]];
    
    UILabel *trackerValue = [[UILabel alloc] initWithFrame:CGRectMake(95, 10, size.width-110, 46)];
    self.trackerValue = trackerValue;
    trackerValue.font = NJNameFont;
    trackerValue.numberOfLines = 0;
    [trackerView addSubview:trackerValue];
    [orderView addSubview:trackerView];

    
    //商品列表
    UIView *goodsView = [[UIView alloc] initWithFrame:CGRectMake(0, 365, size.width, 50)];
    
    [BWCommon setTopBorder:goodsView color:[BWCommon getBorderColor]];
    [BWCommon setBottomBorder:goodsView color:[BWCommon getBorderColor]];
    goodsView.backgroundColor = [UIColor whiteColor];
    
    UILabel *goodsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 90, 20)];
    goodsTitleLabel.text = @"商品清单";
    goodsTitleLabel.font = [UIFont systemFontOfSize:16 weight:10];
    [goodsView addSubview:goodsTitleLabel];
    
    UIImageView *tipsView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order-tips.png"]];
    
    [goodsView addSubview:tipsView];
    
    tipsView.frame = CGRectMake(size.width-80, 10, 65, 36);
    
    [sclView addSubview:goodsView];
    
    
    [self initData];
    
    XCMultiTableView *tableView = [[XCMultiTableView alloc] initWithFrame:CGRectMake(0, 416, size.width, 160)];
    tableView.leftHeaderEnable = YES;
    tableView.datasource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView = tableView;
    [sclView addSubview:tableView];
    
    [sclView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    UIView *actionView = [[UIView alloc] initWithFrame:CGRectMake(0, 586, size.width, 50)];
    
    UIButton *commentButton = [self createButton:@"评 论"];
    UIButton *noteButton = [self createButton:@"备 注"];
    UIButton *complainButton = [self createButton:@"投 诉"];
    
    self.commentButton = commentButton;

    //UIButton *trackerButton = [self createButton:@"查看物流"];
    [actionView addSubview:commentButton];
    [actionView addSubview:noteButton];
    [actionView addSubview:complainButton];
    //[actionView addSubview:trackerButton];
    
    [commentButton addTarget:self action:@selector(commentButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [noteButton addTarget:self action:@selector(noteButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [complainButton addTarget:self action:@selector(complainButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSArray *constraints1= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[commentButton(<=90)]-[noteButton(<=90)]-[complainButton(<=90)]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(commentButton,noteButton,complainButton)];
    
    NSArray *constraints2= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[commentButton(<=30)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(commentButton)];
    NSArray *constraints3= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[noteButton(<=30)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(noteButton)];
    NSArray *constraints4= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[complainButton(<=30)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(complainButton)];
    //NSArray *constraints5= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[trackerButton(<=30)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(trackerButton)];

    [actionView addConstraints:constraints1];
    [actionView addConstraints:constraints2];
    [actionView addConstraints:constraints3];
    [actionView addConstraints:constraints4];
    //[actionView addConstraints:constraints5];
    
    [sclView addSubview:actionView];
    
    
    
    
    
    [self loadData:order_no callback:^{}];
    
}

- (void) payTouched: (id) sender{
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付确认" message:@"优先从余额账户、拍卖账户扣除商品费用、服务费用，运费冻结到保证金账户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    
    [alert show];

}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        
        __weak OrderDetailViewController *weakSelf = self;
        [self payOrder:order_no callback:^{
            [weakSelf loadData:order_no callback:^{}];
        }];
    }
}

- (void) payOrder:(NSString *) order_no callback:(void(^)()) callback{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"order/pay"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"order/pay"];
    
    [postData setValue:order_no forKey:@"order_no"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    
    NSLog(@"%@",order_no);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        [hud removeFromSuperview];
        if(errNo == 0)
        {
            
            NSLog(@"%@",[responseObject objectForKey:@"data"]);
            [alert setMessage:[NSString stringWithFormat:@"订单号：%@ 支付成功！",order_no]];
            [alert show];
            if(callback){
                callback();
            }
            
            //NSLog(@"%@",json);
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

-(void) backTouched: (id) sender{
    
    NSLog(@"backTouched!!!!!!!!");
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}


- (void) commentButtonTouched:(id) sender{
    
    if(canRate == NO){
        return;
    }

    OrderCommentViewController * commentViewController = [[OrderCommentViewController alloc] init];
    self.delegate = commentViewController;
    commentViewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:commentViewController animated:YES];
    
    [self.delegate setValue:order_no];
    
}

- (void) complainButtonTouched:(id) sender{
    
    OrderComplainViewController * complainViewController = [[OrderComplainViewController alloc] init];
    self.delegate = complainViewController;
    complainViewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:complainViewController animated:YES];
    [self.delegate setValue:order_no];
    
}

- (void) noteButtonTouched:(id) sender{
    
    OrderNoteViewController * noteViewController = [[OrderNoteViewController alloc] init];
    self.delegate = noteViewController;
    noteViewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:noteViewController animated:YES];
    
    [self.delegate setValue:order_no];
}

- (void) setValue:(NSString *)detailValue{
    
    order_no = detailValue;
    
}

- (UIButton *) createButton:(NSString *) title{
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [btn setTitle:title forState:UIControlStateNormal];
    
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn.layer setCornerRadius:4.0];
    [btn.layer setBorderColor:[UIColor colorWithRed:95/255.0f green:100/255.0f blue:110/255.0f alpha:1].CGColor];
    [btn.layer setBorderWidth:1.0f];
    [btn setTitleColor:[UIColor colorWithRed:95/255.0f green:100/255.0f blue:110/255.0f alpha:1] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    return btn;
}

- (void) headerRefreshing{
    
    [self loadData:order_no callback:^{
        [self.sclView.header endRefreshing];
    }];
    
}


- (void) loadData:(NSString *) order_no callback:(void(^)()) callback{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"order/getOrderInfoById"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"order/getOrderInfoById"];
    
    [postData setValue:order_no forKey:@"order_no"];
    
    NSLog(@"%@",order_no);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        [hud removeFromSuperview];
        if(errNo == 0)
        {
            
            NSLog(@"%@",[responseObject objectForKey:@"data"]);
            
            [self renderPage:[responseObject objectForKey:@"data"]];
            
            if(callback){
                callback();
            }
            
            //NSLog(@"%@",json);
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

- (void) renderPage:(NSDictionary *) data{
    
    self.orderNoValue.text = [data objectForKey:@"order_no"];
    self.orderFeeValue.text = [NSString stringWithFormat:@"¥ %@",[data objectForKey:@"order_fee"]];
    
    self.orderTimeValue.text = [data objectForKey:@"create_time"];
    self.orderStatusValue.text = [data objectForKey:@"status_cn"];
    
    //NSUInteger status = [[data objectForKey:@"status"]integerValue];
    

    
    NSString *address = [data objectForKey:@"address"];
    
    CGSize addressSize = [BWCommon sizeWithString:address font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(220, MAXFLOAT)];
    
    self.orderAddressValue.frame = CGRectMake(96, 10, addressSize.width, addressSize.height);
    
    self.orderAddressValue.text = address;
    
    NSString *tracker = [data objectForKey:@"shipping"];
    
    CGSize trackerSize = [BWCommon sizeWithString:tracker font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(220, MAXFLOAT)];
    
    self.trackerValue.frame = CGRectMake(96, 10, trackerSize.width, trackerSize.height);
    self.trackerValue.text = tracker;
    
    if([[data objectForKey:@"canRate"] integerValue] == 0){
        canRate = NO;
        [self.commentButton setBackgroundColor:[BWCommon getRGBColor:0xeeeeee]];
    }
    

    if([[data objectForKey:@"canPayment"] integerValue] == 0){
        canPayment = NO;
        [self.payButton setHidden:YES];

    }
    
    NSArray * goodsList = [[NSArray alloc] initWithArray:[data objectForKey:@"goods_list"]];
    
    
    NSUInteger goodsLength = [goodsList count];
    
    leftTableData = [NSMutableArray arrayWithCapacity:goodsLength];
    rightTableData = [NSMutableArray arrayWithCapacity:goodsLength];
    
    NSMutableArray *one = [NSMutableArray arrayWithCapacity:goodsLength];
    NSMutableArray *oneR = [NSMutableArray arrayWithCapacity:goodsLength];
    for(int i=0;i<goodsLength;i++){
        
        [one addObject:[goodsList[i] objectForKey:@"goods_cd"]];
        
        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:13];
        
        [ary addObject:[goodsList[i] objectForKey:@"fcname"]];
        [ary addObject:[goodsList[i] objectForKey:@"name"]];
        [ary addObject:[goodsList[i] objectForKey:@"fconame"]];
        [ary addObject:[goodsList[i] objectForKey:@"flname"]];
        [ary addObject:[goodsList[i] objectForKey:@"fhname"]];
        [ary addObject:[goodsList[i] objectForKey:@"length"]];
        [ary addObject:[goodsList[i] objectForKey:@"funame"]];
        [ary addObject:[goodsList[i] objectForKey:@"price"]];
        [ary addObject:[goodsList[i] objectForKey:@"ent_num"]];
        [ary addObject:[goodsList[i] objectForKey:@"num"]];
        [ary addObject:[goodsList[i] objectForKey:@"num"]];
        [ary addObject:[goodsList[i] objectForKey:@"total_fee"]];
        [ary addObject:[goodsList[i] objectForKey:@"buyer_type"]];
        
        [oneR addObject:ary];
    }
    
    [leftTableData addObject:one];
    [rightTableData addObject:oneR];
    
    [self.tableView reloadData];
    
}


- (void) initData{
    headData = [NSMutableArray arrayWithCapacity:13];
    [headData addObject:@"品类"];
    [headData addObject:@"品种"];
    [headData addObject:@"颜色"];
    [headData addObject:@"等级"];
    [headData addObject:@"花头"];
    [headData addObject:@"长度"];
    [headData addObject:@"单位"];
    [headData addObject:@"单价"];
    [headData addObject:@"装箱数"];
    [headData addObject:@"数量"];
    [headData addObject:@"总数量"];
    [headData addObject:@"商品总价"];
    [headData addObject:@"交易方式"];
    
    
    leftTableData = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *one = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < 1; i++) {
         [one addObject:@""];
     }
    //NSMutableArray *two = [NSMutableArray arrayWithCapacity:10];
    //for (int i = 3; i < 10; i++) {
   //     [two addObject:[NSString stringWithFormat:@"ki-%d", i]];
   // }
    [leftTableData addObject:one];
    
    
    
    rightTableData = [NSMutableArray arrayWithCapacity:1];
    
    NSMutableArray *oneR = [NSMutableArray arrayWithCapacity:13];
    for (int i = 0; i < 1; i++) {
        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:13];
        for (int j = 0; j < 13; j++) {
                [ary addObject:@""];
        }
        [oneR addObject:ary];
    }
    [rightTableData addObject:oneR];
    


}


- (NSArray *)arrayDataForTopHeaderInTableView:(XCMultiTableView *)tableView {
    return [headData copy];
}
- (NSArray *)arrayDataForLeftHeaderInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    return [leftTableData objectAtIndex:section];
}

- (NSArray *)arrayDataForContentInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    return [rightTableData objectAtIndex:section];
}


- (NSUInteger)numberOfSectionsInTableView:(XCMultiTableView *)tableView {
    return [leftTableData count];
}

- (CGFloat)tableView:(XCMultiTableView *)tableView contentTableCellWidth:(NSUInteger)column {

    return 80.0f;
}

- (CGFloat)tableView:(XCMultiTableView *)tableView cellHeightInRow:(NSUInteger)row InSection:(NSUInteger)section {
    if (section == 0) {
        return 30.0f;
    }else {
        return 0.0f;
    }
}
- (CGFloat)topHeaderHeightInTableView:(XCMultiTableView *)tableView{
    return 20;
}

- (UIColor *)tableView:(XCMultiTableView *)tableView bgColorInSection:(NSUInteger)section InRow:(NSUInteger)row InColumn:(NSUInteger)column {
    if (row == 1 && section == 0) {
        //return [UIColor redColor];
    }
    return [UIColor clearColor];
}

- (UIColor *)tableView:(XCMultiTableView *)tableView headerBgColorInColumn:(NSUInteger)column {
    if (column == -1) {
        //return [UIColor redColor];
    }else if (column == 1) {
        //return [UIColor grayColor];
    }
    return [UIColor clearColor];
}


- (UIView *) createRow:(NSString *) title {

    UIView *view = [[UIView alloc] init];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
    titleLabel.font = [UIFont systemFontOfSize:16 weight:12];
    [view addSubview:titleLabel];
    titleLabel.text = title;
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIButton *) coloredButton: (NSString *) title bgColor : (UIColor *) bgColor {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:5.0];
    //button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = bgColor;
    button.tintColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
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
