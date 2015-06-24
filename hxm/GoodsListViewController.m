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
#import "CartTableViewController.h"
#import "GoodsDetailViewController.h"
#import "ConsignationFormViewController.h"
#import "BuyTableViewController.h"
#import "BWCommon.h"
#import "MJRefresh.h"
#import "AFNetworkTool.h"
#import "YCXMenu.h"

@interface GoodsListViewController ()
@property (nonatomic, strong) NSArray *statusFrames;
@property (nonatomic,assign) NSUInteger gpage;

@property (nonatomic , strong) NSMutableArray *items;

@end

@implementation GoodsListViewController

@synthesize dataArray;
@synthesize tableview;

@synthesize items = _items;


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
    
    //right bar
    UIBarButtonItem *listItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"right-dot.png"] style:UIBarButtonItemStylePlain target:self action:@selector(listTouched:)];
    //listItem.title=@"";
    //listItem.image=[UIImage imageNamed:@"right-dot.png"];
    self.navigationItem.rightBarButtonItem=listItem;
    
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, size.width, 50)];
    searchView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:searchView];
    
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, size.width, size.height)];
    tableview.delegate = self;
    tableview.dataSource = self;
    
    tableview.backgroundColor = [BWCommon getBackgroundColor];
    
    
    self.gpage = 1;
    
    
    [self.view addSubview:tableview];
    
    [self refreshingData:1 callback:^{}];
    
    [self.tableview addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    [self.tableview addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    
    //[self.tableview.footer setTitle:@"No data" forState:MJRefreshFooterStateRefreshing];
    
    //UIView *view = [UIView new];
    
    //view.backgroundColor = [UIColor clearColor];
    //[tableview setTableFooterView:view];
    
    tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) listTouched:(id) sender{
    NSLog(@"listTouched");
    
    //[YCXMenu setHasShadow:YES];
    //[YCXMenu setBackgrounColorEffect:YCXMenuBackgrounColorEffectGradient];
    [YCXMenu setTintColor:[BWCommon getMainColor]];
    [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, 64, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
        NSLog(@"%@",item);
    }];
    
}

- (NSMutableArray *)items {
    if (!_items) {
        // set title
        
        //set logout button
        YCXMenuItem *cartItem = [YCXMenuItem menuItem:@"购物车" image:nil target:self action:@selector(cartTouched:)];
        cartItem.alignment = NSTextAlignmentCenter;
        
        //set item
        _items = [@[cartItem,
                    [YCXMenuItem menuItem:@"客服热线"
                                    image:nil
                                      tag:102
                                 userInfo:@{@"title":@"Menu"}]
                    ] mutableCopy];
    }
    return _items;
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

    
    if(!cell.buyButton.tag)
    {
        cell.buyButton.tag = indexPath.row;
        cell.auctionButton.tag = indexPath.row;
        cell.cartButton.tag = indexPath.row;
    
        [cell.buyButton addTarget:self action:@selector(buyButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [cell.auctionButton addTarget:self action:@selector(auctionButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [cell.cartButton addTarget:self action:@selector(cartButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

-(void) buyButtonTouched:(UIButton *)sender{
   // NSLog(@"%ld",sender.tag);
    
    NSUInteger detail_id;
    detail_id = [[[dataArray objectAtIndex:[sender tag]] objectForKey:@"ent_id"] integerValue];
    
    BuyTableViewController * buyTableViewController = [[BuyTableViewController alloc] init];
    self.delegate = buyTableViewController;
    [self.navigationController pushViewController:buyTableViewController animated:YES];
    [self.delegate setValue:detail_id];

    
}

-(void) auctionButtonTouched:(UIButton *)sender{
    //NSLog(@"%ld",sender.tag);
    
    NSUInteger detail_id;
    detail_id = [[[dataArray objectAtIndex:[sender tag]] objectForKey:@"ent_id"] integerValue];
    
    ConsignationFormViewController * consignationFormViewController = [[ConsignationFormViewController alloc] init];
    self.delegate = consignationFormViewController;
    [self.navigationController pushViewController:consignationFormViewController animated:YES];
    [self.delegate setValue:detail_id];
}

-(void) cartTouched:(id)sender{
    //NSLog(@"%ld",sender.tag);
    CartTableViewController * cartViewController = [[CartTableViewController alloc] init];
    self.delegate = cartViewController;
    [self.navigationController pushViewController:cartViewController animated:YES];
}

-(void) cartButtonTouched:(UIButton *)sender{
    //NSLog(@"%ld",sender.tag);
    
    NSUInteger detail_id;
    detail_id = [[[dataArray objectAtIndex:[sender tag]] objectForKey:@"ent_id"] integerValue];
    
    //加入购物车
    
    __weak GoodsListViewController *weakSelf = self;
    
    [self addToCart:detail_id callback:^{
        
        CartTableViewController * cartViewController = [[CartTableViewController alloc] init];
        weakSelf.delegate = cartViewController;
        [weakSelf.navigationController pushViewController:cartViewController animated:YES];
        [weakSelf.delegate setValue:detail_id];
    }];
}

-(void) addToCart: (NSUInteger) ent_id callback:(void(^)()) callback{
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"cart/AddToCart"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"cart/AddToCart"];
    
    [postData setValue:[NSString stringWithFormat:@"%ld",ent_id] forKey:@"id"];
    [postData setValue:@"1" forKey:@"quantity"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    NSLog(@"%@",url);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        NSLog(@"%@",responseObject);
        
        if(errNo == 0)
        {
            if(callback){
                callback();
            }
        }
        else
        {
            NSLog(@"%@",[responseObject objectForKey:@"error"]);
            [alert setMessage:[responseObject objectForKey:@"error"]];
            [alert show];
        }
        
    } fail:^{
        NSLog(@"请求失败");
        [alert setMessage:@"请求超时"];
        [alert show];
    }];

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
    detail_id = [[[dataArray objectAtIndex:[indexPath row]] objectForKey:@"ent_id"] integerValue];
     
     GoodsDetailViewController *detailViewController = [[GoodsDetailViewController alloc] init];
     
     detailViewController.hidesBottomBarWhenPushed = YES;
     self.delegate = detailViewController;
     [self.navigationController pushViewController:detailViewController animated:YES];
     [self.delegate setValue:detail_id];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSMutableDictionary *dic = [self.dataArray objectAtIndex:indexPath.section];
   // NSMutableDictionary *infoDic = [dic objectForKey:@"dic"];
    if (indexPath.row==[self.dataArray count]-1) {
        
        cell.separatorInset = UIEdgeInsetsMake(10, 0, 0, 0);
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    NSUInteger width = self.view.frame.size.width;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
    headView.backgroundColor = [BWCommon getBackgroundColor];
    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, width - 40, 40)];
    [headView addSubview:searchField];
    
    searchField.backgroundColor = [UIColor colorWithRed:250/255.0f green:250/255.0f  blue:250/255.0f  alpha:1];
    searchField.layer.cornerRadius = 5.0f;
    searchField.layer.borderColor = [BWCommon getMainColor].CGColor;
    searchField.layer.borderWidth = 1.0f;
    searchField.placeholder = @"搜索您想找的商品";
    
    searchField.borderStyle = UITextBorderStyleRoundedRect;

    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods-q.png"]];
    searchField.leftView = icon;
    searchField.leftViewMode = UITextFieldViewModeAlways;
    
    
    [BWCommon setBottomBorder:headView color:[BWCommon getBackgroundColor]];

    return headView;

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
