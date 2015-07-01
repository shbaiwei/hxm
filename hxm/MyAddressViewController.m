//
//  MyAddressViewController.m
//  hxm
//
//  Created by spring on 15/5/28.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "MyAddressViewController.h"
#import "BWCommon.h"
#import "MyAddressTableViewCell.h"
#import "MyAddressTableViewFrame.h"
#import "MJRefresh.h"
#import "AFNetworkTool.h"
#import "MyAddressEditViewController.h"

@interface MyAddressViewController ()
@property (nonatomic, strong) NSArray *statusFrames;
@property (nonatomic,assign) NSUInteger gpage;


@end

@implementation MyAddressViewController

NSMutableDictionary *addressInfo;

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
    self.navigationItem.title = @"收货地址管理";
    //创建一个右边按
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickRightButton)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    UIColor *bgColor = [BWCommon getBackgroundColor];
    
    self.view.backgroundColor = bgColor;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    [self.navigationController.navigationBar setBarTintColor:[BWCommon getMainColor]];

    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.image=[UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem=backItem;
    
    
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

- (void) clickRightButton
{
    MyAddressEditViewController *page = [[MyAddressEditViewController alloc] init];
    [self.navigationController pushViewController:page animated:YES];
}

- (void) refreshingData:(NSUInteger)page callback:(void(^)()) callback
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"user/getAddressList"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"user/getAddressList"];
    
    NSString *user_id = [BWCommon getUserInfo:@"uid"];
    NSLog(@"uid:%@",user_id);
    [postData setValue:[NSString stringWithFormat:@"%@",user_id] forKey:@"uid"];
    
    NSLog(@"%@",url);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        //NSLog(@"%@",responseObject);
        
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
    
    MyAddressTableViewCell *cell = [MyAddressTableViewCell cellWithTableView:tableview];
    
    cell.viewFrame = self.statusFrames[indexPath.row];
    
    cell.editButton.tag = indexPath.row;
    [cell.editButton addTarget:self action:@selector(do_edit:) forControlEvents:UIControlEventTouchUpInside];
    cell.delButton.tag = indexPath.row;
    [cell.delButton addTarget:self action:@selector(do_del:) forControlEvents:UIControlEventTouchUpInside];
    cell.defaultButton.tag = indexPath.row;
    [cell.defaultButton addTarget:self action:@selector(do_default:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void) do_default: (UIButton *) sender{
    addressInfo = [dataArray objectAtIndex:sender.tag];
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"系统提示" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    if ([[addressInfo objectForKey:@"is_default"] integerValue] == 0) {
        [alert setMessage:@"确定要设为默认地址吗？"];
        [alert show];
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        NSLog(@"提交默认地址设置");
        
        NSLog(@"save action");
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.delegate=self;
        
        NSString *url2 = @"user/saveAddress";
        
        NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:url2];
        
        NSMutableDictionary *postData = [BWCommon getTokenData:url2];
        
        
        [postData setValue:[addressInfo objectForKey:@"receiver_name"] forKey:@"receiver_name"];
        
        
        [postData setValue:[addressInfo objectForKey:@"address"] forKey:@"address"];
        [postData setValue:[addressInfo objectForKey:@"link_qq"] forKey:@"link_qq"];
        [postData setValue:[addressInfo objectForKey:@"link_fax"] forKey:@"link_fax"];
        [postData setValue:[addressInfo objectForKey:@"link_address"] forKey:@"link_address"];
        [postData setValue:[addressInfo objectForKey:@"prov_id"] forKey:@"prov_id"];
        [postData setValue:[addressInfo objectForKey:@"city_id"] forKey:@"city_id"];
        [postData setValue:[addressInfo objectForKey:@"dist_id"] forKey:@"dist_id"];
        [postData setValue:[addressInfo objectForKey:@"address_id"] forKey:@"address_id"];
        [postData setValue:@"1" forKey:@"is_default"];

        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        NSLog(@"%@",postData);
        
        [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
            
            // NSLog(@"userinfo:%@",responseObject);
            NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
            
            [hud removeFromSuperview];
            if(errNo == 0)
            {
                self.statusFrames = nil;
                [self.tableview reloadData];
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
}

- (void) do_edit: (UIButton *)sender
{
    //NSDictionary *address = [dataArray objectAtIndex:sender.tag];
    //NSLog(@"address:%@",address);
    MyAddressEditViewController *page = [[MyAddressEditViewController alloc] init];

    self.delegate = page;
    [self.delegate setValue:[[[dataArray objectAtIndex:sender.tag] objectForKey:@"address_id"] integerValue ]];
    
    [self.navigationController pushViewController:page animated:YES];
    

}

- (void) do_del: (UIButton *)sender
{
    //NSDictionary *address = [dataArray objectAtIndex:sender.tag];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统提示" message:@"您确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = sender.tag;
    [alert show];
    //[dataArray objectAtIndex:sender.tag];
    NSLog(@"delete action:%@",[dataArray objectAtIndex:sender.tag]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"heightForRowAtIndexPath");
    // 取出对应航的frame模型
    MyAddressTableViewFrame *vf = self.statusFrames[indexPath.row];
    NSLog(@"height = %f", vf.cellHeight);
    return vf.cellHeight;
}

- (NSArray *)statusFrames
{
    if (_statusFrames == nil) {
        
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:dataArray.count];
        
        for (NSDictionary *dict in dataArray) {
            // 创建模型
            MyAddressTableViewFrame *vf = [[MyAddressTableViewFrame alloc] init];
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (void) setTextFieldCenter:(NSArray *) items{
    
    NSInteger i = 0;
    
    for (i=0; i<[items count]; i++) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:[items objectAtIndex:i] attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    }
    
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

@end
