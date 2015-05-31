//
//  FinanceTableViewController.m
//  hxm
//
//  Created by Bruce He on 15-5-29.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "FinanceTableViewController.h"
#import "FinanceTableViewCell.h"
#import "BWCommon.h"
#import "MJRefresh.h"
#import "AFNetworkTool.h"

@interface FinanceTableViewController ()

@property (nonatomic,retain) NSMutableArray *list;

@property (nonatomic,retain) NSMutableArray *sectionList;

@end

@implementation FinanceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pageLayout];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) pageLayout{
    self.navigationItem.title = @"财务管理";
    
    UIColor *bgColor = [BWCommon getBackgroundColor];
    
    self.view.backgroundColor = bgColor;
    
    //CGRect rect = [[UIScreen mainScreen] bounds];
    //CGSize size = rect.size;
    
    
    NSMutableArray *menus0 = [[NSMutableArray alloc] init];
    
    [menus0 addObject:@{@"title":@"会员名：",@"text":@"brucehe3"}];
    [menus0 addObject:@{@"title":@"手机号码：",@"text":@"18621320482"}];
    
    NSMutableArray *menus1 = [[NSMutableArray alloc] init];
    
    [menus1 addObject:@{@"title":@"可用余额：",@"text":@"111111"}];
    [menus1 addObject:@{@"title":@"拍卖金额：",@"text":@"222222"}];
    [menus1 addObject:@{@"title":@"保证金额：",@"text":@"333333"}];
    
    self.list = [[NSMutableArray alloc] init];
    
    [self.list addObject:menus0];
    [self.list addObject:menus1];
    
    self.sectionList = [[NSMutableArray alloc] init];
    [self.sectionList addObject:@{@"title":@"账户信息"}];
    [self.sectionList addObject:@{@"title":@"账户余额"}];
    
 
    [self loadData:^{}];
    
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
}

- (void) headerRefreshing{
    
    [self loadData:^{
        [self.tableView.header endRefreshing];
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
            
            
            
            if(callback){
                callback();
            }
            
            [self.tableView reloadData];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return [self.sectionList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.list objectAtIndex:section] count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if(section == 0)
        return 15;
    else
        return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell0";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[FinanceTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    NSInteger section = [indexPath indexAtPosition:0];
    NSInteger row = [indexPath indexAtPosition:1];
    
    NSArray *data = [[NSArray alloc] initWithArray:[self.list objectAtIndex:section]];
    
    cell.textLabel.text = [[data objectAtIndex:row] objectForKey:@"title"];
    
    return cell;

}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 50)];
    
    //headerView.layer.borderColor = [[UIColor grayColor] CGColor];
    //headerView.layer.borderWidth = 1.0f;
    

        headerView.backgroundColor = [UIColor whiteColor];
    
        NSString *imageName = [NSString stringWithFormat:@"finance-%ld.png",(long)(section+1)];
        UIImage* icon = [UIImage imageNamed:imageName];
    
        UIImageView * iconView = [[UIImageView alloc] initWithImage:icon];
        [headerView addSubview:iconView];
        iconView.frame = CGRectMake(10, 10, 36, 36);
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 20, 100, 20)];
        [headerView addSubview:nameLabel];
    
        nameLabel.text = [[self.sectionList objectAtIndex:section] objectForKey:@"title"];
        

    
    
    return headerView;
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView* myView = [[UIView alloc] init];
    myView.backgroundColor = [BWCommon getBackgroundColor];
    
    if(section==1)
    {
        
    }
    
    return myView;
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
