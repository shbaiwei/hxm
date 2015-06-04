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
    [filterView addConstraints:constraints3];
    
    
   
    
    
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, size.width, size.height-146)];
    tableview.delegate = self;
    tableview.dataSource = self;
    
    [self.view addSubview:tableview];
    
    self.gpage = 1;
    [self refreshingData:1 callback:^{
        //[self.tableview.header endRefreshing];
    }];
    
    [self.tableview addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    [self.tableview addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];

}

- (UIButton *) createFilterButton:(NSString *) name{
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:name forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    
    return btn;
    
    
}


- (void) refreshingData:(NSUInteger)page callback:(void(^)()) callback
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    

    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"order/queryOrders"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"order/queryOrders"];
    
    [postData setValue:[NSString stringWithFormat:@"%ld",page] forKey:@"OrderInfo_page"];
    
    
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
            
            NSLog(@"%@",dataArray);
            self.statusFrames = nil;
            
            [tableview reloadData];
            
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

/* 这个函数是指定显示多少cells*/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self dataArray] count];//这个是指定加载数据的多少即显示多少个cell，如果这个地方弄错了会崩溃的哟
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrderTableViewCell *cell = [OrderTableViewCell cellWithTableView:tableview];
    
    cell.viewFrame = self.statusFrames[indexPath.row];
    
    cell.commentButton.tag = indexPath.row;
    cell.noteButton.tag = indexPath.row;
    
    
    [cell.commentButton addTarget:self action:@selector(commentButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [cell.noteButton addTarget:self action:@selector(noteButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"heightForRowAtIndexPath");
    // 取出对应航的frame模型
    OrderTableViewFrame *vf = self.statusFrames[indexPath.row];
    NSLog(@"height = %f", vf.cellHeight);
    return vf.cellHeight;
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
