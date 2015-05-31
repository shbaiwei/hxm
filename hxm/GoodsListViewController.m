//
//  GoodsListTableViewController.m
//  hxm
//
//  Created by Bruce He on 15-5-30.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "GoodsListViewController.h"
#import "GoodsListTableViewCell.h"
#import "GoodsListTableViewFrame.h"
#import "GoodsDetailViewController.h"
#import "BWCommon.h"
#import "MJRefresh.h"
#import "AFNetworkTool.h"

@interface GoodsListViewController ()
@property (nonatomic, strong) NSArray *statusFrames;
@property (nonatomic,assign) NSUInteger gpage;

@end

@implementation GoodsListViewController

@synthesize dataArray;
@synthesize tableview;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self pageLayout];
}

- (void) pageLayout{
    
    self.view.backgroundColor = [BWCommon getBackgroundColor];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title = @"在售商品";
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.image=[UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem=backItem;
    
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, size.width, 50)];
    searchView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:searchView];
    
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, size.width, size.height)];
    tableview.delegate = self;
    tableview.dataSource = self;
    
    self.gpage = 1;
    
    
    [self.view addSubview:tableview];
    
    [self refreshingData:1 callback:^{}];
    
    [self.tableview addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    [self.tableview addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    [tableview setTableFooterView:view];
}

- (void) refreshingData:(NSUInteger)page callback:(void(^)()) callback
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"goods/queryGoods"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"goods/queryGoods"];
    
    [postData setValue:@"10" forKey:@"pageSize"];
    [postData setValue:[NSString stringWithFormat:@"%ld",page] forKey:@"GoodsEntry_page"];
    
    
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
            
            [self.tableview reloadData];
            
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [[self dataArray] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsListTableViewCell *cell = [GoodsListTableViewCell cellWithTableView:tableView];
    
    cell.viewFrame = self.statusFrames[indexPath.row];
    cell.buyButton.tag = indexPath.row;
    cell.auctionButton.tag = indexPath.row;
    cell.cartButton.tag = indexPath.row;
    
    [cell.buyButton addTarget:self action:@selector(buyButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [cell.auctionButton addTarget:self action:@selector(auctionButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [cell.cartButton addTarget:self action:@selector(cartButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void) buyButtonTouched:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
}

-(void) auctionButtonTouched:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
}


-(void) cartButtonTouched:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"heightForRowAtIndexPath");
    // 取出对应航的frame模型
    GoodsListTableViewFrame *vf = self.statusFrames[indexPath.row];
    NSLog(@"height = %f", vf.cellHeight);
    return vf.cellHeight;
}

- (NSArray *)statusFrames
{
    if (_statusFrames == nil) {
        
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:dataArray.count];
        
        for (NSDictionary *dict in dataArray) {
            // 创建模型
            GoodsListTableViewFrame *vf = [[GoodsListTableViewFrame alloc] init];
            vf.data = dict;
            [models addObject:vf];
        }
        self.statusFrames = [models copy];
    }
    return _statusFrames;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSUInteger detail_id;
    detail_id = [[[dataArray objectAtIndex:[indexPath row]] objectForKey:@"goods_id"] integerValue];
     
     GoodsDetailViewController *detailViewController = [[GoodsDetailViewController alloc] init];
     
     detailViewController.hidesBottomBarWhenPushed = YES;
     self.delegate = detailViewController;
     [self.navigationController pushViewController:detailViewController animated:YES];
     [self.delegate setValue:detail_id];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
