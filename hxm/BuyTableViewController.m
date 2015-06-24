//
//  BuyTableViewController.m
//  hxm
//
//  Created by Bruce He on 15/6/24.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "BuyTableViewController.h"
#import "BuyTableViewCell.h"
#import "BuyTableViewFrame.h"
#import "BWCommon.h"
#import "MJRefresh.h"
#import "AFNetworkTool.h"

@interface BuyTableViewController ()

@property (nonatomic, strong) NSArray *statusFrames;

@property (nonatomic,retain) NSMutableArray *list;

@property (nonatomic,retain) NSMutableArray *sectionList;

@property (nonatomic,retain) NSMutableArray *addresses;

@end

@implementation BuyTableViewController

NSUInteger detail_id;
NSUInteger addressIndex;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self pageLayout];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void) pageLayout{
    self.navigationItem.title = @"立即购买";
    
    UIColor *bgColor = [BWCommon getBackgroundColor];
    self.view.backgroundColor = bgColor;
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.image=[UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem=backItem;
    
    
    
    //CGRect rect = [[UIScreen mainScreen] bounds];
    //CGSize size = rect.size;
    
    
    NSMutableArray *menus0 = [[NSMutableArray alloc] init];
    
    
    NSMutableArray *menus1 = [[NSMutableArray alloc] init];

    
    self.list = [[NSMutableArray alloc] init];
    
    [self.list addObject:menus0];
    [self.list addObject:menus1];
    
    self.sectionList = [[NSMutableArray alloc] init];
    [self.sectionList addObject:@{@"title":@"确认收货地址"}];
    [self.sectionList addObject:@{@"title":@"确认订单信息"}];

    
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

    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"order/create"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"order/create"];
    [postData setValue:@"normal" forKey:@"from"];
    [postData setValue:[NSString stringWithFormat:@"%ld_1",detail_id] forKey:@"buyer_param"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    NSLog(@"%@",postData);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        
        NSLog(@"%@",responseObject);
        [hud removeFromSuperview];
        if(errNo == 0)
        {
            
            //NSLog(@"%@",json);
            
            NSDictionary * data = [responseObject objectForKey:@"data"];
            
            
            NSMutableArray *menus0 = [[NSMutableArray alloc] init];
            
            NSArray * addresses = [data objectForKey:@"address_list"];
            
            addressIndex = 0;
            
            self.addresses = [[NSMutableArray alloc] init];
            self.addresses = [addresses mutableCopy];

            for (NSInteger i=0; i<addresses.count; i++) {
                NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
                [row setObject:@"" forKey:@"title"];
                NSString *address = [[addresses objectAtIndex:i] objectForKey:@"address"];
                NSString *receiver_name = [[addresses objectAtIndex:i] objectForKey:@"receiver_name"];
                NSString *mobile = [[addresses objectAtIndex:i] objectForKey:@"mobile"];
                NSString *phone = [[addresses objectAtIndex:i] objectForKey:@"phone"];
                NSString *combineAddress = [NSString stringWithFormat:@"%@ (%@ 收) %@ %@",address,receiver_name,mobile,phone ];
                [row setObject:combineAddress forKey:@"text"];
                [menus0 addObject:row];
            }
            
            
            NSMutableArray *menus1 = [[NSMutableArray alloc] init];
            
            NSDictionary * orderInfo = [[data objectForKey:@"order_info"] objectAtIndex:0];
            
            NSMutableDictionary *goods_cd = [[NSMutableDictionary alloc] init];
            [goods_cd setObject:@"编号：" forKey:@"title"];
            [goods_cd setObject:[orderInfo objectForKey:@"goods_cd"] forKey:@"text"];
            
            NSMutableDictionary *cat_id = [[NSMutableDictionary alloc] init];
            [cat_id setObject:@"品类：" forKey:@"title"];
            [cat_id setObject:[orderInfo objectForKey:@"cat_id"] forKey:@"text"];
            
            NSMutableDictionary *color = [[NSMutableDictionary alloc] init];
            [color setObject:@"颜色：" forKey:@"title"];
            [color setObject:[orderInfo objectForKey:@"color"] forKey:@"text"];
            
            NSMutableDictionary *level_id = [[NSMutableDictionary alloc] init];
            [level_id setObject:@"等级：" forKey:@"title"];
            [level_id setObject:[orderInfo objectForKey:@"level_id"] forKey:@"text"];
            
            NSMutableDictionary *head_id = [[NSMutableDictionary alloc] init];
            [head_id setObject:@"花头：" forKey:@"title"];
            [head_id setObject:[orderInfo objectForKey:@"head_id"] forKey:@"text"];
            
            NSMutableDictionary *length = [[NSMutableDictionary alloc] init];
            [length setObject:@"长度：" forKey:@"title"];
            [length setObject:[orderInfo objectForKey:@"length"] forKey:@"text"];
            
            NSMutableDictionary *unit_id = [[NSMutableDictionary alloc] init];
            [unit_id setObject:@"单位：" forKey:@"title"];
            [unit_id setObject:[orderInfo objectForKey:@"unit_id"] forKey:@"text"];
            
            NSMutableDictionary *ent_num = [[NSMutableDictionary alloc] init];
            [ent_num setObject:@"入数：" forKey:@"title"];
            [ent_num setObject:[orderInfo objectForKey:@"ent_num"] forKey:@"text"];
            

        
            [menus1 addObject:goods_cd];
            [menus1 addObject:cat_id];
            [menus1 addObject:color];
            [menus1 addObject:level_id];
            [menus1 addObject:head_id];
            [menus1 addObject:length];
            [menus1 addObject:unit_id];
            [menus1 addObject:ent_num];
            
            self.list[0] = menus0;
            self.list[1] = menus1;
            
            self.statusFrames = nil;
            
            //NSLog(@"%@",self.list);
            
            if(callback){
                callback();
            }
            
            [self.tableView reloadData];
        }
        else
        {
            NSLog(@"%@",[responseObject objectForKey:@"error"]);
            [alert setMessage:[responseObject objectForKey:@"error"]];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } fail:^{
        [hud removeFromSuperview];
        NSLog(@"请求失败");
        [alert setMessage:@"连接超时，请重试"];
        [alert show];
    }];
    
    
}

- (void) createOrder:(void(^)()) callback
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"order/create"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"order/create"];
    [postData setValue:@"normal" forKey:@"from"];
    [postData setValue:[NSString stringWithFormat:@"%ld_1",detail_id] forKey:@"buyer_param"];
    
    NSDictionary *address = [self.addresses objectAtIndex:addressIndex];
    [postData setValue:[address objectForKey:@"user_id"] forKey:@"buyer_id"];
    //[postData setValue:[address objectForKey:@"user_id"] forKey:@"buyer_name"];
    [postData setValue:[address objectForKey:@"receiver_name"] forKey:@"receiver_name"];
    [postData setValue:[address objectForKey:@"prov_id"] forKey:@"receiver_prov"];
    [postData setValue:[address objectForKey:@"city_id"] forKey:@"receiver_city"];
    [postData setValue:[address objectForKey:@"dist_id"] forKey:@"receiver_dist"];
    [postData setValue:[address objectForKey:@"address"] forKey:@"receiver_address"];
    [postData setValue:[address objectForKey:@"mobile"] forKey:@"receiver_mobile"];
    [postData setValue:[address objectForKey:@"phone"] forKey:@"receiver_phone"];
    [postData setValue:[address objectForKey:@"zip"] forKey:@"receiver_zip"];
    

    NSLog(@"%@",url);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        [hud removeFromSuperview];
        if(errNo == 0)
        {
            NSDictionary * data = [responseObject objectForKey:@"data"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert setMessage:[NSString stringWithFormat:@"订单创建成功，订单号：%@",[data objectForKey:@"order_no"]]];
            [alert show];
            
            if(callback){
                callback();
            }
            
            NSLog(@"%@",responseObject);
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



- (NSArray *)statusFrames
{
    if (_statusFrames == nil) {
        
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:self.list.count];
        
        for (int i=0;i < self.list.count;i++){
            
            NSMutableArray *tmp = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dict in [self.list objectAtIndex:i]) {
                // 创建模型
                BuyTableViewFrame *vf = [[BuyTableViewFrame alloc] init];
                vf.data = dict;
                //NSLog(@"%@",dict);
                [tmp addObject:vf];
            }
            
            
            [models addObject:tmp];
        }
        self.statusFrames = [models copy];
    }
    
    return _statusFrames;
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
    BuyTableViewFrame *vf = self.statusFrames[indexPath.section][indexPath.row];

    return vf.cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if(section == 0)
        return 15;
    else
        return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    BuyTableViewCell * cell = [BuyTableViewCell cellWithTableView:tableView];
    
    
    //NSLog(@"%@",self.statusFrames[indexPath.section][indexPath.row]);
    cell.viewFrame = self.statusFrames[indexPath.section][indexPath.row];
    

        if ( indexPath.section == 0 && addressIndex == indexPath.row)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            //NSLog(@"111111111111111");
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

    
    return cell;
    
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 50)];
    
    //headerView.layer.borderColor = [[UIColor grayColor] CGColor];
    //headerView.layer.borderWidth = 1.0f;
    
    
    headerView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 20)];
    [headerView addSubview:nameLabel];
    nameLabel.text = [[self.sectionList objectAtIndex:section] objectForKey:@"title"];
    
    [headerView sizeToFit];
    
    CALayer* layer = [headerView layer];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderWidth = 1;
    bottomBorder.frame = CGRectMake(-1, layer.frame.size.height, layer.frame.size.width, 1);
    [bottomBorder setBorderColor:[UIColor lightGrayColor].CGColor];
    [layer addSublayer:bottomBorder];
    
    
    return headerView;
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView* myView = [[UIView alloc] init];
    myView.backgroundColor = [BWCommon getBackgroundColor];
    
    
    
    if(section==1)
    {
        //加入
        UIButton *btnConfirm = [self footerButton:@"提交订单" bgColor:[UIColor colorWithRed:219/255.0f green:0/255.0f blue:0 alpha:1]];
        [myView addSubview: btnConfirm];

        
        [btnConfirm addTarget:self action:@selector(confirmTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        NSArray *constraints1= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[btnConfirm(==300)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btnConfirm)];
        
        NSArray *constraints2= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[btnConfirm(==50)]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btnConfirm)];

        [myView addConstraints:constraints1];
        [myView addConstraints:constraints2];
        

    }
    
    return myView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        addressIndex = indexPath.row;

    }
    [tableView reloadData];
}

-(void) confirmTouched:(id) sender{

    [self createOrder:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(UIButton *) footerButton: (NSString *) title bgColor : (UIColor *) bgColor {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:5.0];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = bgColor;
    button.tintColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

-(void) setValue:(NSUInteger)detailValue{
    
    detail_id =detailValue;
}

@end
