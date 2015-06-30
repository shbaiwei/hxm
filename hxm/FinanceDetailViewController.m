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

@property (nonatomic,retain) UIView *searchView;
@property (nonatomic,retain) UIView *baseView;

@property (nonatomic,retain) UIView *row1;

@property (nonatomic,retain) UIView *rowAmount;
@property (nonatomic,retain) UIView *rowDate;
@property (nonatomic,retain) UIView *rowNumber;
@property (nonatomic,retain) UITextField *dateField1;
@property (nonatomic,retain) UITextField *dateField2;

@property (nonatomic,retain) UITextField *amountField1;
@property (nonatomic,retain) UITextField *amountField2;
@property (nonatomic,retain) UITextField *numberField;
@property (nonatomic,retain) UIDatePicker *datePicker;

@end

@implementation FinanceDetailViewController

NSMutableArray *headData;
NSMutableArray *leftTableData;
NSMutableArray *rightTableData;

CGSize size;

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
    size = rect.size;
    
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
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 170)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.sclView addSubview:baseView];
    
    UIImageView *icon1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finance-2.png"]];
    icon1.frame = CGRectMake(0, 0, 30, 30);
    [baseView addSubview:icon1];
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 16, 200, 20)];
    title1.text = @"账户基本情况";
    title1.font = [UIFont systemFontOfSize:16];
    //[baseView addSubview:title1];
    
    UIButton *accountMenu = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 190, 30)];
    [accountMenu addSubview:icon1];
    [accountMenu setTitle:@"账户基本情况" forState:UIControlStateNormal];
    [accountMenu setTitleColor:[BWCommon getRGBColor:0x000000] forState:UIControlStateNormal];
    accountMenu.titleLabel.font = [UIFont systemFontOfSize:16];
    [accountMenu setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    [baseView addSubview:accountMenu];
    
    [accountMenu addTarget:self action:@selector(accountMenuTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    self.baseView = baseView;
    
   
    
    NSUInteger y=40;
     UILabel * accountMoney=[[UILabel alloc] initWithFrame:CGRectMake(90, 10, 100, 20)];
    UIView * row1 = [self createRow:@"账户余额：" label:accountMoney];
    row1.frame = CGRectMake(40, y, size.width - 40, 40);
    [BWCommon setBottomBorder:row1 color:[BWCommon getBorderColor]];
    [baseView addSubview:row1];
    
    self.accountMoney = accountMoney;
    
    self.row1 = row1;
    
    y += 40;
    
    UILabel * auctionMoney=[[UILabel alloc] initWithFrame:CGRectMake(90, 10, 100, 20)];
    UIView * row2 = [self createRow:@"拍卖金额：" label:auctionMoney];
    row2.frame = CGRectMake(40, y, size.width - 40, 40);
    [BWCommon setBottomBorder:row2 color:[BWCommon getBorderColor]];
    [baseView addSubview:row2];
    
    self.auctionMoney = auctionMoney;
    
    y += 40;
    UILabel * lMoney=[[UILabel alloc] initWithFrame:CGRectMake(90, 10, 100, 20)];
    UIView * row3 = [self createRow:@"保证金额：" label:lMoney];
    row3.frame = CGRectMake(40, y, size.width - 40, 40);
    [baseView addSubview:row3];
    
    self.lMoney = lMoney;
    
    [BWCommon setBottomBorder:baseView color:[BWCommon getBorderColor]];
    
    

    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 180, size.width, 40)];
    searchView.backgroundColor = [UIColor whiteColor];
    [BWCommon setTopBorder:searchView color:[BWCommon getBorderColor]];
    [BWCommon setBottomBorder:searchView color:[BWCommon getBorderColor]];
    [self.sclView addSubview:searchView];
    
    
    UIImageView *icon2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finance-3.png"]];
    icon2.frame = CGRectMake(0, 0, 30, 30);
    [searchView addSubview:icon2];
    UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(50, 16, 200, 20)];
    title2.text = @"高级搜索";
    title2.font = [UIFont systemFontOfSize:16];
    //[searchView addSubview:title2];
    
    UIButton *searchMenu = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 150, 30)];
    [searchMenu addSubview:icon2];
    [searchMenu setTitle:@"高级搜索" forState:UIControlStateNormal];
    [searchMenu setTitleColor:[BWCommon getRGBColor:0x000000] forState:UIControlStateNormal];
    searchMenu.titleLabel.font = [UIFont systemFontOfSize:16];
    [searchMenu setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];

    [searchView addSubview:searchMenu];
    
    [searchMenu addTarget:self action:@selector(searchMenuTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    self.searchView = searchView;
    
    //加入框
    //流水号
    
    y = 35;
    UIView * rowNumber = [self createFieldRow:@"流水号    |"];
    rowNumber.frame = CGRectMake(40, y, size.width - 40, 32);
    //[BWCommon setBottomBorder:rowNumber color:[BWCommon getBorderColor]];
    [searchView addSubview:rowNumber];
    self.rowNumber = rowNumber;
    [rowNumber setHidden:YES];
    
    UITextField *numberField = [[UITextField alloc] initWithFrame:CGRectMake(75, 8, size.width - 130, 25)];
    [rowNumber addSubview:numberField];
    numberField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.numberField = numberField;
    
    y+=30;
    UIView * rowAmount = [self createFieldRow:@"金额区间 |"];
    rowAmount.frame = CGRectMake(40, y, size.width - 40, 30);
    //[BWCommon setBottomBorder:rowAmount color:[BWCommon getBorderColor]];
    [searchView addSubview:rowAmount];
    self.rowAmount = rowAmount;
    [rowAmount setHidden:YES];
    
    NSUInteger awidth = (size.width - 130-20)/2;
    
    UILabel *midLabel = [[UILabel alloc] initWithFrame:CGRectMake(80+awidth, 10, 20, 20)];
    [rowAmount addSubview:midLabel];
    midLabel.text = @"~ |";
    midLabel.font = [UIFont systemFontOfSize:14];

    UITextField *amountField1 = [[UITextField alloc] initWithFrame:CGRectMake(75, 8, awidth, 25)];
    //[amountField1 setBackgroundColor:[UIColor greenColor]];
    amountField1.keyboardType = UIKeyboardTypeDecimalPad;
    [amountField1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [rowAmount addSubview:amountField1];
    UITextField *amountField2 = [[UITextField alloc] initWithFrame:CGRectMake(80+awidth+20, 8, awidth, 25)];
    //[amountField2 setBackgroundColor:[UIColor greenColor]];
    amountField2.keyboardType = UIKeyboardTypeDecimalPad;
    [amountField2 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [rowAmount addSubview:amountField2];
    
    self.amountField1 = amountField1;
    self.amountField2 = amountField2;
    
    y+=30;
    UIView * rowDate = [self createFieldRow:@"起止日期 |"];
    rowDate.frame = CGRectMake(40, y, size.width - 40, 30);
    [searchView addSubview:rowDate];
    self.rowDate = rowDate;
    [rowDate setHidden:YES];
    
    UILabel * midLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(80+awidth, 10, 20, 20)];
    midLabel2.text = @"~ |";
    midLabel2.font = [UIFont systemFontOfSize:14];
    
    UITextField *dateField1 = [[UITextField alloc] initWithFrame:CGRectMake(75, 8, awidth, 25)];
    [dateField1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [rowDate addSubview:dateField1];
    UITextField *dateField2 = [[UITextField alloc] initWithFrame:CGRectMake(80+awidth+20, 8, awidth, 25)];
    dateField2.keyboardType = UIKeyboardTypeDecimalPad;
    [dateField2 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [rowDate addSubview:dateField2];
    
    [rowDate addSubview:midLabel2];
    
    self.dateField1 = dateField1;
    self.dateField2 = dateField2;
    dateField1.tag=1;
    dateField2.tag=2;
    
    
    UIDatePicker* datePicker=[[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    self.datePicker = datePicker;
    
    [self setPickerView:dateField1];
    [self setPickerView:dateField2];
    
    numberField.font = [UIFont systemFontOfSize:14];
    dateField1.font = [UIFont systemFontOfSize:14];
    dateField2.font = [UIFont systemFontOfSize:14];
    amountField1.font = [UIFont systemFontOfSize:14];
    amountField2.font = [UIFont systemFontOfSize:14];
    dateField1.textAlignment = NSTextAlignmentCenter;
    dateField2.textAlignment = NSTextAlignmentCenter;
    amountField1.textAlignment = NSTextAlignmentCenter;
    amountField2.textAlignment = NSTextAlignmentCenter;
    

    y+=38;
    UIButton *searchButton = [self footerButton:@"搜索" bgColor:[BWCommon getRedColor]];
    searchButton.frame = CGRectMake(20, y, size.width-40, 30);
    [searchView addSubview:searchButton];
    
    [searchButton addTarget:self action:@selector(searchTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    // very important make delegate useful
    tap.delegate = self;

}

- (void) searchTouched : (id) sender{
    [self loadList:^{
    }];
}
- (void) setPickerView:(UITextField *) field{
    

    //datePicker.tag = field.tag;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    //doneButton.tag = field.tag;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouched:)];
    
    [toolBar setItems:[NSArray arrayWithObjects:cancelButton,[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],doneButton,nil ]];
    field.inputView = self.datePicker;
    field.inputAccessoryView = toolBar;
}

-(void) doneTouched:(UIBarButtonItem *) sender{
    
    NSDate* date=[self.datePicker date];
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* curentDatest=[formatter stringFromDate:date];
    
    NSLog(@"%@",curentDatest);
    
    if (self.dateField1.resignFirstResponder == YES){
        self.dateField1.text = curentDatest;
    }
    if (self.dateField2.resignFirstResponder == YES){
        self.dateField2.text = curentDatest;
    }
    
    [self.dateField1 resignFirstResponder];
    [self.dateField2 resignFirstResponder];
}
-(void) cancelTouched:(id) sender{
    [self.dateField1 resignFirstResponder];
    [self.dateField2 resignFirstResponder];
}

- (void) showDatePicker:(UITextField*)field{
    
    UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIDatePicker* datePicker=[[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        NSDate* date=[datePicker date];
        NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString* curentDatest=[formatter stringFromDate:date];
        field.text = curentDatest;
    }];
    
    UIAlertAction* no=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    [alertVc.view addSubview:datePicker];
    [alertVc addAction:ok];
    [alertVc addAction:no];
    [self presentViewController:alertVc animated:YES completion:nil];
}


-(UIButton *) footerButton: (NSString *) title bgColor : (UIColor *) bgColor {
    
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

- (void) searchMenuTouched:(id)sender{
    
    [UIView animateWithDuration:0.1 animations:^{
        self.baseView.frame = CGRectMake(0, 0, size.width, 40);
        self.searchView.frame = CGRectMake(0, 50, size.width, 170);
        [self.row1 setHidden:YES];
        [self.rowNumber setHidden:NO];
        [self.rowDate setHidden:NO];
        [self.rowAmount setHidden:NO];
    }];
}

- (void) accountMenuTouched:(id)sender{
    
    [UIView animateWithDuration:0.1 animations:^{
        self.baseView.frame = CGRectMake(0, 0, size.width, 170);
        self.searchView.frame = CGRectMake(0, 180, size.width, 40);
        [self.row1 setHidden:NO];
        [self.rowNumber setHidden:YES];
        [self.rowDate setHidden:YES];
        [self.rowAmount setHidden:YES];
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

    [postData setValue:self.numberField.text forKey:@"bill_id"];
    [postData setValue:self.amountField1.text forKey:@"amount_min"];
    [postData setValue:self.amountField1.text forKey:@"amount_max"];
    [postData setValue:self.dateField1.text forKey:@"time_start"];
    [postData setValue:self.dateField2.text forKey:@"time_end"];

    
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

- (UIView *) createFieldRow:(NSString *) title{
    
    UIView * row = [[UIView alloc] init];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 80, 20)];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [row addSubview:titleLabel];
    return row;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// tap dismiss keyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    //[self.password resignFirstResponder];
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
