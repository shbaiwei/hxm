//
//  MyAfterSalesViewController.m
//  hxm
//
//  Created by spring on 15/5/28.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "MyAfterSalesViewController.h"
#import "BWCommon.h"
#import "MyAfterSaleTableViewCell.h"
#import "MyAfterSaleTableViewFrame.h"
#import "MJRefresh.h"
#import "AFNetworkTool.h"

@interface MyAfterSalesViewController ()
@property (nonatomic, strong) NSArray *statusFrames;
@property (nonatomic,assign) NSUInteger gpage;
@end

@implementation MyAfterSalesViewController
@synthesize items = _items;
@synthesize itemsKeys = _itemsKeys;
@synthesize tableview;
@synthesize dataArray;
- (void)viewDidLoad {
    [super viewDidLoad];
   // self.title = @"售后管理";
    // Do any additional setup after loading the view.
    [self pageLayout];
}

-(void) pageLayout{
    self.navigationItem.title = @"售后管理";
    
    UIColor *bgColor = [BWCommon getBackgroundColor];
    
    self.view.backgroundColor = bgColor;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    tableview.delegate = self;
    tableview.dataSource = self;
    
    [self.view addSubview:tableview];
    
    self.gpage = 1;
    [self refreshingData:1 callback:^{
        //[self.tableview.header endRefreshing];
    }];
    
    [self.tableview addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    //[self.tableview addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    
}


- (void) refreshingData:(NSUInteger)page callback:(void(^)()) callback
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"complain/queryComplains"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"complain/queryComplains"];
    
    NSString *user_id = [BWCommon getUserInfo:@"uid"];
    NSLog(@"uid:%@",user_id);
    [postData setValue:[NSString stringWithFormat:@"%@",user_id] forKey:@"uid"];
    

    
    NSLog(@"%@",url);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
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
            
           // NSLog(@"%@",dataArray);
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
    
    MyAfterSaleTableViewCell *cell = [MyAfterSaleTableViewCell cellWithTableView:tableview];
    
    cell.viewFrame = self.statusFrames[indexPath.row];
    
    cell.cancelButton.tag = indexPath.row;
    [cell.cancelButton addTarget:self action:@selector(do_cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.detailButton.tag = indexPath.row;
    [cell.detailButton addTarget:self action:@selector(do_detail:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.logisticsButton.tag = indexPath.row;
    [cell.logisticsButton addTarget:self action:@selector(do_logistics:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

//撤销投诉
- (void) do_cancel:(UIButton *) btn
{
    NSDictionary *data = [dataArray objectAtIndex:btn.tag];
    NSString *order_id = [data objectForKey:@"order_no"];
    NSLog(@"撤销操作：%@",order_id);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统提示" message:@"您确定要撤销该投诉吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = btn.tag;
    [alert show];
}

//查看详情
- (void) do_detail:(UIButton *) btn
{
    NSDictionary *data = [dataArray objectAtIndex:btn.tag];
    NSString *order_id = [data objectForKey:@"order_no"];
    NSLog(@"查看详情：%@",order_id);
}

//查看物流
- (void) do_logistics:(UIButton *) btn
{
    NSDictionary *data = [dataArray objectAtIndex:btn.tag];
    NSString *order_id = [data objectForKey:@"order_no"];
    NSLog(@"查看物流：%@",order_id);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"heightForRowAtIndexPath");
    // 取出对应航的frame模型
    MyAfterSaleTableViewFrame *vf = self.statusFrames[indexPath.row];
    NSLog(@"height = %f", vf.cellHeight);
    return vf.cellHeight;
}

- (NSArray *)statusFrames
{
    if (_statusFrames == nil) {
        
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:dataArray.count];
        
        for (NSDictionary *dict in dataArray) {
            // 创建模型
            MyAfterSaleTableViewFrame *vf = [[MyAfterSaleTableViewFrame alloc] init];
            vf.data = dict;
            [models addObject:vf];
        }
        self.statusFrames = [models copy];
    }
    return _statusFrames;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSUInteger detail_id;
    /*detail_id = [[[dataArray objectAtIndex:[indexPath row]] objectForKey:@"id"] integerValue];
     
     MixDetailViewController *detailViewController = [[MixDetailViewController alloc] init];
     
     detailViewController.hidesBottomBarWhenPushed = YES;
     self.delegate = detailViewController;
     
     [self.navigationController pushViewController:detailViewController animated:YES];
     
     [self.delegate setValue:detail_id];*/
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    // 进入页面隐藏标签栏
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    // 离开页面显示标签栏
    self.tabBarController.tabBar.hidden = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
}
@end
