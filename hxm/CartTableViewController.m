//
//  CartTableViewController.m
//  hxm
//
//  Created by Bruce He on 15/6/7.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "CartTableViewController.h"

#import "BuyTableViewController.h"
#import "CartTableViewCell.h"
#import "CartTableViewFrame.h"
#import "BWCommon.h"
#import "MJRefresh.h"
#import "AFNetworkTool.h"

@interface CartTableViewController ()

@property (nonatomic, strong) NSArray *statusFrames;
@property (nonatomic, retain) UIButton *btnCheckout;
@property (nonatomic, retain) UILabel *priceLabel;
@property (nonatomic, retain) UILabel *feeLabel;

@end

@implementation CartTableViewController

NSUInteger ent_id;

@synthesize dataArray;

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
    self.navigationItem.title = @"购物车";
    
    dataArray  = [[NSMutableArray alloc] init];
    
    
    //加入
    CGFloat width = self.view.frame.size.width;
    UIButton *btnCheckout = [[UIButton alloc] initWithFrame:CGRectMake(width - 100, 20, 80, 40)];
    btnCheckout.layer.cornerRadius = 5.0f;
    [btnCheckout setTitle:@"结算" forState:UIControlStateNormal];
    [btnCheckout setBackgroundColor:[UIColor colorWithRed:116/255.0f green:197/255.0f blue:67/255.0f alpha:1]];
    
    self.btnCheckout = btnCheckout;
    [self.btnCheckout setHidden:YES];
    
    [btnCheckout addTarget:self action:@selector(checkoutTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - 240, 22, 130, 20)];
    [priceLabel setTextColor:[BWCommon getRedColor]];
    priceLabel.textAlignment = NSTextAlignmentRight;
    self.priceLabel = priceLabel;
    
    UILabel *feeLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - 190, 42, 80, 20)];
    feeLabel.font = [UIFont systemFontOfSize:14];
    feeLabel.textAlignment = NSTextAlignmentRight;
    [feeLabel setTextColor:[UIColor grayColor]];
    self.feeLabel = feeLabel;
    
    
    [self loadData:^{}];
    
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
}

- (void) checkoutTouched:(id) sender{
   
    
    BuyTableViewController * buyTableViewController = [[BuyTableViewController alloc] init];
    self.delegate = buyTableViewController;
    [self.navigationController pushViewController:buyTableViewController animated:YES];
    
    NSLog(@"checkoutTouched    %ld",ent_id);
    [self.delegate setValue:ent_id];
}

- (void) loadData:(void(^)()) callback
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"cart/getCarts"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"cart/getCarts"];
    
    NSLog(@"%@",url);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        [hud removeFromSuperview];
        if(errNo == 0)
        {
            
            
            dataArray = [[responseObject objectForKey:@"data"] mutableCopy];
            
            NSLog(@"%@",dataArray);
            self.statusFrames = nil;
            
            if([dataArray count] == 1 ){
                [self.btnCheckout setHidden:NO];
                
                //计算总价
                float totalPrice = 0.0f;
                for(NSInteger i=0;i<dataArray.count;i++){
                    totalPrice += [[dataArray[i] objectForKey:@"quantity"] floatValue] * [[dataArray[i] objectForKey:@"sale_prc"] floatValue];
                }
                
                [self.priceLabel setText:[NSString stringWithFormat:@"合计：¥ %.02f",totalPrice]];
                [self.feeLabel setText:@"不含运费"];
            }
            else{
                [self.btnCheckout setHidden:YES];
                
                [self.priceLabel setText:@""];
                [self.feeLabel setText:@""];
            }
            


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
    
    [self loadData:^{
        [self.tableView.header endRefreshing];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

    return [[self dataArray] count];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath      //当在Cell上滑动时会调用此函数
{
        
    return  UITableViewCellEditingStyleDelete;  //返回此值时,Cell会做出响应显示Delete按键,点击Delete后会调用下面的函数,别给传递UITableViewCellEditingStyleDelete参数

    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"%ld",indexPath.row);
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CartTableViewCell *cell = [CartTableViewCell cellWithTableView:tableView];
    
    cell.viewFrame = self.statusFrames[indexPath.row];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"heightForRowAtIndexPath");
    // 取出对应航的frame模型
    CartTableViewFrame *vf = self.statusFrames[indexPath.row];
    NSLog(@"height = %f", vf.cellHeight);
    return vf.cellHeight;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView* myView = [[UIView alloc] init];
    myView.backgroundColor = [BWCommon getBackgroundColor];
    
    
    
    if(section==0)
    {

        [myView addSubview: self.btnCheckout];
        [myView addSubview:self.priceLabel];
        [myView addSubview:self.feeLabel];
        
        
        //UILabel *subtotalLabel = UILabel

    }
    
    return myView;
}


- (NSArray *)statusFrames
{
    if (_statusFrames == nil) {
        
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:dataArray.count];
        
        for (NSDictionary *dict in dataArray) {
            // 创建模型
            CartTableViewFrame *vf = [[CartTableViewFrame alloc] init];
            vf.data = dict;
            [models addObject:vf];
        }
        self.statusFrames = [models copy];
    }
    return _statusFrames;
}

- (void) setValue:(NSUInteger)detailValue{
    
    ent_id = detailValue;
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
