//
//  FinanceDetailViewController.m
//  hxm
//
//  Created by Bruce He on 15/6/7.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "FinanceDetailViewController.h"
#import "BWCommon.h"
#import "MJRefresh.h"
#import "AFNetworkTool.h"

@interface FinanceDetailViewController ()

@property (nonatomic,retain) XCMultiTableView * tableView;

@property (nonatomic,retain) UIScrollView *sclView;
@property (nonatomic,retain) UILabel *accountMoney;
@property (nonatomic,retain) UILabel *auctionMoney;
@property (nonatomic,retain) UILabel *lMoney;

@end

@implementation FinanceDetailViewController

NSMutableArray *headData;
NSMutableArray *leftTableData;
NSMutableArray *rightTableData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
}

-(void) viewWillAppear:(BOOL)animated{
    
    //[self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"alpha.png"] forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

-(void) viewWillDisappear:(BOOL)animated{

    //[self.navigationController.navigationBar setBackgroundColor:[BWCommon getMainColor]];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"green.png"] forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.alpha = 1;
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void) pageLayout{
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    sclView.backgroundColor = [BWCommon getBackgroundColor];
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width,700);
    self.sclView = sclView;
    
    [self.view addSubview:sclView];
    
    self.view.backgroundColor = [BWCommon getBackgroundColor];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title = @"对账单";
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 160)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.sclView addSubview:baseView];
    
    UIImageView *icon1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finance-2.png"]];
    icon1.frame = CGRectMake(10, 10, 30, 30);
    [baseView addSubview:icon1];
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 16, 200, 20)];
    title1.text = @"账户基本情况";
    title1.font = [UIFont systemFontOfSize:16];
    [baseView addSubview:title1];
    
   
    
    NSUInteger y=40;
     UILabel * accountMoney=[[UILabel alloc] initWithFrame:CGRectMake(90, 10, 100, 20)];
    UIView * row1 = [self createRow:@"账户余额：" label:accountMoney];
    row1.frame = CGRectMake(50, y, size.width - 50, 40);
    [BWCommon setBottomBorder:row1 color:[BWCommon getBorderColor]];
    [baseView addSubview:row1];
    
    self.accountMoney = accountMoney;
    
    y += 40;
    
    UILabel * auctionMoney=[[UILabel alloc] initWithFrame:CGRectMake(90, 10, 100, 20)];
    UIView * row2 = [self createRow:@"拍卖金额：" label:auctionMoney];
    row2.frame = CGRectMake(50, y, size.width - 50, 40);
    [BWCommon setBottomBorder:row2 color:[BWCommon getBorderColor]];
    [baseView addSubview:row2];
    
    self.auctionMoney = auctionMoney;
    
    y += 40;
    UILabel * lMoney=[[UILabel alloc] initWithFrame:CGRectMake(90, 10, 100, 20)];
    UIView * row3 = [self createRow:@"保证金额：" label:lMoney];
    row3.frame = CGRectMake(50, y, size.width - 50, 40);
    [baseView addSubview:row3];
    
    self.lMoney = lMoney;
    
    [BWCommon setBottomBorder:baseView color:[BWCommon getBorderColor]];
    
    

    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 170, size.width, 50)];
    searchView.backgroundColor = [UIColor whiteColor];
    [BWCommon setTopBorder:searchView color:[BWCommon getBorderColor]];
    [BWCommon setBottomBorder:searchView color:[BWCommon getBorderColor]];
    [self.sclView addSubview:searchView];
    
    
    UIImageView *icon2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finance-3.png"]];
    icon2.frame = CGRectMake(10, 10, 30, 30);
    [searchView addSubview:icon2];
    UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(50, 16, 200, 20)];
    title2.text = @"高级搜索";
    title2.font = [UIFont systemFontOfSize:16];
    [searchView addSubview:title2];
    
    
    
    //搜索列表
    UIView *resultView = [[UIView alloc] initWithFrame:CGRectMake(0, 230, size.width, 50)];
    
    [BWCommon setTopBorder:resultView color:[BWCommon getBorderColor]];
    //[BWCommon setBottomBorder:resultView color:[BWCommon getBorderColor]];
    resultView.backgroundColor = [UIColor whiteColor];
    
    UILabel *resultTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 90, 20)];
    resultTitleLabel.text = @"搜索结果";
    resultTitleLabel.font = [UIFont systemFontOfSize:16 weight:10];
    [resultView addSubview:resultTitleLabel];
    
    UIImageView *tipsView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order-tips.png"]];
    
    [resultView addSubview:tipsView];
    
    tipsView.frame = CGRectMake(size.width-80, 10, 65, 36);
    
    [self.sclView addSubview:resultView];
    
    
    [self initData];
    
    XCMultiTableView *tableView = [[XCMultiTableView alloc] initWithFrame:CGRectMake(0, 284, size.width, 300)];
    tableView.leftHeaderEnable = YES;
    tableView.datasource = self;
    tableView.leftHeaderWidth = 160;
    tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView = tableView;
    [self.sclView addSubview:tableView];
    
    //[self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    [self loadData:^{
        
        [self loadList:^{
            
        }];
        
    }];

}

- (void) loadData:(void(^)()) callback
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"account/getAccountInfoById"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"account/getAccountInfoById"];
    
    NSLog(@"%@",url);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        
        NSLog(@"%@",responseObject);
        [hud removeFromSuperview];
        if(errNo == 0)
        {
            
            //NSLog(@"%@",json);
            
            NSDictionary * data = [responseObject objectForKey:@"data"];
            
            self.accountMoney.text = [data objectForKey:@"balance"];
            self.auctionMoney.text = [data objectForKey:@"auction"];
            self.lMoney.text = [data objectForKey:@"guarantee"];
            
            if(callback){
                callback();
            }
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

- (void) loadList:(void(^)()) callback{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"account/queryDetails"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"account/queryDetails"];
    
    //[postData setValue:order_no forKey:@"order_no"];
    
    //NSLog(@"%@",order_no);
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


- (void) renderPage:(NSArray *) data{
    
     //NSArray * goodsList = [[NSArray alloc] initWithArray:[data objectForKey:@"goods_list"]];
    
    NSUInteger length = [data count];
    
    leftTableData = [NSMutableArray arrayWithCapacity:length];
    rightTableData = [NSMutableArray arrayWithCapacity:length];
    
    NSMutableArray *one = [NSMutableArray arrayWithCapacity:length];
    NSMutableArray *oneR = [NSMutableArray arrayWithCapacity:length];
    for(int i=0;i<length;i++){
        
        [one addObject:[data[i] objectForKey:@"create_time"]];
        
        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:6];
        
        [ary addObject:[data[i] objectForKey:@"bill_no"]];
        [ary addObject:[data[i] objectForKey:@"pay_name"]];
        [ary addObject:[data[i] objectForKey:@"status"]];
        [ary addObject:[data[i] objectForKey:@"amount_in"]];
        [ary addObject:[data[i] objectForKey:@"amount_out"]];
        [ary addObject:[data[i] objectForKey:@"balance"]];
        
        [oneR addObject:ary];
    }
    
    [leftTableData addObject:one];
    [rightTableData addObject:oneR];
    
    [self.tableView reloadData];


    
}


- (void) initData{
    headData = [NSMutableArray arrayWithCapacity:6];
    //[headData addObject:@"流水号"];
    [headData addObject:@"流水号"];
    [headData addObject:@"交易类型"];
    [headData addObject:@"状态"];
    [headData addObject:@"收入"];
    [headData addObject:@"支出"];
    [headData addObject:@"余额"];
    
    
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
    
    NSMutableArray *oneR = [NSMutableArray arrayWithCapacity:6];
    for (int i = 0; i < 1; i++) {
        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:6];
        for (int j = 0; j < 7; j++) {
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
    if (column == 0) {
        return 150.0f;
    }
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


- (UIView *) createRow:(NSString *) title  label : (UILabel *) label{
    
    UIView * row = [[UIView alloc] init];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 80, 20)];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:16 weight:10];
    [row addSubview:titleLabel];
    [row addSubview:label];
    return row;
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
