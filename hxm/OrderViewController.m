//
//  OrderViewController.m
//  hxm
//
//  Created by Bruce on 15-5-19.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "OrderViewController.h"
#import "BWCommon.h"
#import "OrderTableViewCell.h"
#import "OrderTableViewFrame.h"
#import "OrderDetailViewController.h"
#import "OrderCommentViewController.h"
#import "OrderNoteViewController.h"
#import "MJRefresh.h"
#import "AFNetworkTool.h"


@interface OrderViewController ()
@property (nonatomic, strong) NSArray *statusFrames;
@property (nonatomic,assign) NSUInteger gpage;
@property (nonatomic,assign) NSUInteger order_type;
@property (nonatomic,assign) NSString * status_search;
@property (nonatomic,assign) NSString * OrderInfo_sort;

@property (nonatomic,strong) DOPDropDownMenu *menu;
//@property (nonatomic, strong) NSArray *classifys;
@property (nonatomic, strong) NSArray *status;
@property (nonatomic, strong) NSArray *trade;
@property (nonatomic, strong) NSArray *sort;
@property (nonatomic, strong) NSArray *sort_value;
@property (nonatomic, strong) NSArray *status_value;

@end

@implementation OrderViewController

@synthesize items = _items;
@synthesize itemsKeys = _itemsKeys;
@synthesize tableview;
@synthesize dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) pageLayout{
    self.navigationItem.title = @"我的订单";
    
    UIColor *bgColor = [BWCommon getBackgroundColor];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.image=[UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem=backItem;
    
    self.view.backgroundColor = bgColor;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    //筛选方式
    /*
    UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, size.width, 40)];
    filterView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:filterView];
    
    UIButton *tradeButton = [self createFilterButton:@"交易方式"];
    
    [filterView addSubview:tradeButton];
    
    UIButton *statusButton = [self createFilterButton:@"订单状态"];
    
    [filterView addSubview:statusButton];
    
    NSArray *constraints1= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[tradeButton(<=100)]-20-[statusButton(<=100)]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tradeButton,statusButton)];
    
    NSArray *constraints2= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[tradeButton(<=40)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tradeButton)];
    NSArray *constraints3= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[statusButton(<=40)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(statusButton)];
    
    [filterView addConstraints:constraints1];
    [filterView addConstraints:constraints2];
    [filterView addConstraints:constraints3];*/
    
    

    
    //self.classifys = @[@"交易方式",@"订单状态"];
    self.trade = @[@"交易方式",@"订购",@"委托拍卖",@"在线拍卖",@"调配"];
    self.status = @[@"订单状态",@"等待付款",@"等待发货",@"已发货",@"交易成功",@"待评价",@"退款中",@"已关闭"];
    self.sort = @[@"排序方式",@"成交时间最新",@"订单金额高到低",@"订单金额低到高",@"商品箱数多到少",@"商品箱数少到多"];
    self.sort_value = @[@"",@"create_time.desc",@"order_fee.desc",@"order_fee",@"total_num.desc",@"total_num"];
    self.status_value = @[@"",@"WAIT_PAY",@"WAIT_SEND",@"WAIT_CONFIRM",@"SUCCESS",@"WAIT_RATE",@"REFUNDING",@"DROP"];
    
    
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 42, size.width, size.height-90)];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.rowHeight = 180;
    
    [self.view addSubview:tableview];
    
    // 添加下拉菜单
    self.menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    [self.menu setSeparatorColor:[UIColor whiteColor]];
    //self.menu.indicatorColor = [BWCommon getMainColor];
    //self.menu.textSelectedColor = [BWCommon getMainColor];
    //self.menu.textColor = [BWCommon getMainColor];

    self.menu.delegate = self;
    self.menu.dataSource = self;
    
    [self.view addSubview:self.menu];
    
    self.gpage = 1;
    self.order_type = 0;
    self.status_search = 0;
    
    [self.tableview setHidden:YES];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableview setTableFooterView:v];

    [self refreshingData:1 callback:^{
        //[self.tableview.header endRefreshing];
    }];
    
    [self.tableview addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];

    [self.tableview addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    
    //self.tableview add
    //self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

- (UIButton *) createFilterButton:(NSString *) name{
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:name forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    //btn.titleLabel.frame = CGRectMake(0, 0, 70, 30);
    
    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    
    //UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order-arrow.png"]];
    [btn setBackgroundImage:[UIImage imageNamed:@"order-arrow.png"] forState:UIControlStateNormal];
    
    //[BWCommon setBottomBorder:btn color:[BWCommon getMainColor]];
    
    return btn;
    
    
}


- (void) refreshingData:(NSUInteger)page callback:(void(^)()) callback
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.mode = MBProgressHUDModeCustomView;
    hud.delegate=self;
    
    
    

    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"order/queryOrders"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"order/queryOrders"];
    
    url = [url stringByAppendingFormat:@"?OrderInfo_page=%ld&order_type=%ld&status_search=%@&OrderInfo_sort=%@",page,self.order_type,self.status_search,self.OrderInfo_sort];
    
    //[postData setValue:[NSString stringWithFormat:@"%ld",page] forKey:@"OrderInfo_page"];
    //[postData setValue:[NSString stringWithFormat:@"%ld",self.order_type] forKey:@"order_type"];
    //[postData setValue:[NSString stringWithFormat:@"%ld",self.status_search] forKey:@"status_search"];
    //[postData setValue:[NSString stringWithFormat:@"%@",self.OrderInfo_sort] forKey:@"OrderInfo_sort"];
    
    //NSLog(@"%@",postData);
    
    NSLog(@"%@",url);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        [hud removeFromSuperview];
        if(errNo == 0)
        {
            
            //NSArray *data = [[NSArray alloc] init];
            
            if(page == 1)
            {
                dataArray = [[responseObject objectForKey:@"data"] mutableCopy];
            }
            else
            {
                [dataArray addObjectsFromArray:[[responseObject objectForKey:@"data"] mutableCopy]];
                
            }
            
            NSLog(@"%@",[responseObject objectForKey:@"data"]);
            self.statusFrames = nil;
            
            [self.tableview setHidden:NO];
            [self.tableview reloadData];
            
           /* __weak OrderViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            */
            
            
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

- (void) headerRefreshing{
    
    self.gpage = 1;
    [self refreshingData:1 callback:^{
        [self.tableview.header endRefreshing];
    }];
    
}

- (void )footerRereshing{
    
    [self refreshingData:++self.gpage callback:^{
        [self.tableview.footer endRefreshing];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

// DOP Dropdown Menu begin
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    
    return 3;
    
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return self.trade.count;
    }
    else if(column == 1) {
         return self.status.count;
    }
    else if(column == 2) {
        return self.sort.count;
    }
    
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    
    if (indexPath.column == 0) {

        
        return self.trade[indexPath.row];
    }
    else if(indexPath.column == 1){

        return self.status[indexPath.row];
    }
    else
    {
        return self.sort[indexPath.row];
    }
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    

    
    return 0;
    
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    
    if (indexPath.column == 0) {
        
        if (indexPath.row == 0) {
            
            return self.trade[indexPath.item];
            
        }
        
    }
    else if(indexPath.column == 1) {

        if (indexPath.row == 0) {
            
            return self.status[indexPath.item];
            
        }
    }
    else if(indexPath.column == 2) {
        
        if (indexPath.row == 0) {
            
            return self.sort[indexPath.item];
            
        }
    }
    
    return nil;
    
}
-(void) menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    if(indexPath.column == 0){
        
        //NSLog(@"item %ld",indexPath.item);
        //NSLog(@"row %ld",indexPath.row);
        
        self.order_type = (int)indexPath.row;
        [self refreshingData:1 callback:^{}];
    }
    else if(indexPath.column == 1){
        
        self.status_search = [self.status_value objectAtIndex:indexPath.row];
        [self refreshingData:1 callback:^{}];
    }
    else if(indexPath.column == 2){
        
        self.OrderInfo_sort = [self.sort_value objectAtIndex:indexPath.row];
        [self refreshingData:1 callback:^{}];
    }
}

//DOP Dropdown menu end.

/* 这个函数是指定显示多少cells*/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self dataArray] count];//这个是指定加载数据的多少即显示多少个cell，如果这个地方弄错了会崩溃的哟
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrderTableViewCell *cell = [OrderTableViewCell cellWithTableView:tableview];
    
    cell.viewFrame = self.statusFrames[indexPath.row];
    
    if( ! cell.commentButton.tag)
    {
        cell.commentButton.tag = indexPath.row;
        cell.noteButton.tag = indexPath.row;
    
    
        [cell.commentButton addTarget:self action:@selector(commentButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [cell.noteButton addTarget:self action:@selector(noteButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return cell;
}

- (void) commentButtonTouched:(id) sender{

    NSString * order_no;
    order_no = [[dataArray objectAtIndex:[sender tag]] objectForKey:@"order_no"];
    
    OrderCommentViewController * commentViewController = [[OrderCommentViewController alloc] init];
    self.delegate = commentViewController;
    commentViewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:commentViewController animated:YES];
    
    [self.delegate setValue:order_no];
}

- (void) noteButtonTouched:(id) sender{
    
    NSString * order_no;
    order_no = [[dataArray objectAtIndex:[sender tag]] objectForKey:@"order_no"];
    
    OrderNoteViewController * noteViewController = [[OrderNoteViewController alloc] init];
    self.delegate = noteViewController;
    noteViewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:noteViewController animated:YES];
    
    [self.delegate setValue:order_no];
}


- (NSArray *)statusFrames
{
    if (_statusFrames == nil) {
        
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:dataArray.count];
        
        for (NSDictionary *dict in dataArray) {
            // 创建模型
            OrderTableViewFrame *vf = [[OrderTableViewFrame alloc] init];
            vf.data = dict;
            [models addObject:vf];
        }
        self.statusFrames = [models copy];
    }
    return _statusFrames;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * order_no;
    order_no = [[dataArray objectAtIndex:[indexPath row]] objectForKey:@"order_no"];
    
    OrderDetailViewController *detailViewController = [[OrderDetailViewController alloc] init];
    
    detailViewController.hidesBottomBarWhenPushed = YES;
    self.delegate = detailViewController;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [self.delegate setValue:order_no];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    
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
