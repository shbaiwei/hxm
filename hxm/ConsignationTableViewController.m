//
//  ConsignationTableViewController.m
//  hxm
//
//  Created by Bruce on 15-6-2.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "ConsignationTableViewController.h"
#import "ConsignationTableViewFrame.h"
#import "ConsignationTableViewCell.h"
#import "BWCommon.h"
#import "MJRefresh.h"
#import "AFNetworkTool.h"

@interface ConsignationTableViewController ()

@property (nonatomic, strong) NSArray *statusFrames;
@property (nonatomic,assign) NSUInteger gpage;

@end

@implementation ConsignationTableViewController

@synthesize dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self pageLayout];
    
}

-(void) pageLayout{
    
    self.view.backgroundColor = [BWCommon getBackgroundColor];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title = @"委托记录";
    
    [self refreshingData:1 callback:^{}];
    
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    
}

- (NSArray *)statusFrames
{
    if (_statusFrames == nil) {
        
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:dataArray.count];
        
        for (NSDictionary *dict in dataArray) {
            // 创建模型
            ConsignationTableViewFrame *vf = [[ConsignationTableViewFrame alloc] init];
            vf.data = dict;
            [models addObject:vf];
        }
        self.statusFrames = [models copy];
    }
    return _statusFrames;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) refreshingData:(NSUInteger)page callback:(void(^)()) callback
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"delegation/queryDelegations"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"delegation/queryDelegations"];
    
    [postData setValue:@"10" forKey:@"pageSize"];
    [postData setValue:[NSString stringWithFormat:@"%ld",self.gpage] forKey:@"DelegationEntry_page"];
    
    
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
            
            [self.tableView reloadData];
            
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
        [self.tableView.header endRefreshing];
    }];
    
}

- (void )footerRereshing{
    
    [self refreshingData:++self.gpage callback:^{
        [self.tableView.footer endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ConsignationTableViewCell *cell = [[ConsignationTableViewCell alloc] init];
    cell.viewFrame = self.statusFrames[indexPath.row];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"heightForRowAtIndexPath");
    // 取出对应航的frame模型
    ConsignationTableViewFrame *vf = self.statusFrames[indexPath.row];
    NSLog(@"height = %f", vf.cellHeight);
    return vf.cellHeight;
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
