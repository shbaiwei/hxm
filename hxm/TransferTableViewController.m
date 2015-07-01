//
//  TransferTableViewController.m
//  hxm
//
//  Created by Bruce He on 15/7/1.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "TransferTableViewController.h"
#import "TransferTableViewCell.h"
#import "TransferTableViewFrame.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"

@interface TransferTableViewController ()
@property (nonatomic, strong) NSArray *statusFrames;

@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, retain) UITextField *field0;
@property (nonatomic, retain) UITextField *field1;
@property (nonatomic, retain) UITextField *field2;

@end

@implementation TransferTableViewController

NSArray *titleArray;
NSMutableArray *sectionArray;



CGSize size;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self pagelayout];
}

- (void) pagelayout{
    
    self.view.backgroundColor = [BWCommon getBackgroundColor];

    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title = @"我要转账";
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    
    titleArray = [[NSArray alloc] initWithObjects:@"余额到拍卖账户",@"拍卖账户到余额",@"余额到花集", nil];
    sectionArray = [[NSMutableArray alloc] initWithCapacity:3];
    sectionArray[0] = @"0";
    sectionArray[1] = @"0";
    sectionArray[2] = @"0";
    
    
    
    NSMutableArray *menus0 = [[NSMutableArray alloc] init];
    
    [menus0 addObject:[self createRow:@"会员名：" text:@""]];
    [menus0 addObject:[self createRow:@"账户余额：" text:@""]];
    [menus0 addObject:[self createRow:@"转账金额：" text:@""]];
    
    NSMutableArray *menus1 = [[NSMutableArray alloc] init];
    
    [menus1 addObject:[self createRow:@"会员名：" text:@""]];
    [menus1 addObject:[self createRow:@"账户余额：" text:@""]];
    [menus1 addObject:[self createRow:@"转账金额：" text:@""]];
    
    NSMutableArray *menus2 = [[NSMutableArray alloc] init];
    
    [menus2 addObject:[self createRow:@"会员名：" text:@""]];
    [menus2 addObject:[self createRow:@"账户余额：" text:@""]];
    [menus2 addObject:[self createRow:@"转账金额：" text:@""]];
    
    self.list = [[NSMutableArray alloc] initWithCapacity:3];

    self.list[0] = menus0;
    self.list[1] = menus1;
    self.list[2] = menus2;
    
    [self loadData:^{}];
    
    //[self.tableView setBackgroundColor:[BWCommon getBackgroundColor]];

// tap for dismissing keyboard
UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                               initWithTarget:self
                               action:@selector(dismissKeyboard)];
[self.view addGestureRecognizer:tap];
// very important make delegate useful
tap.delegate = self;


}

// tap dismiss keyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    //[self.password resignFirstResponder];
}

- (NSDictionary *) createRow:(NSString *) title  text: (NSString *) text{
    
    NSDictionary *row = [[NSMutableDictionary alloc] initWithObjectsAndKeys:title,@"title",text,@"text", nil];
    return row;
}

- (void) loadData:(void(^)()) callback
{
    
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"account/getAccountInfoById"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"account/getAccountInfoById"];
    
    NSLog(@"%@",url);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        NSLog(@"%@",responseObject);

        if(errNo == 0)
        {

            NSDictionary * data = [responseObject objectForKey:@"data"];
            
            
            NSMutableArray *menus0 = [[NSMutableArray alloc] init];
            
            [menus0 addObject:[self createRow:@"会员名：" text:[BWCommon getUserInfo:@"username"] ]];
            [menus0 addObject:[self createRow:@"账户余额：" text:[data objectForKey:@"balance"] ]];
            [menus0 addObject:[self createRow:@"转账金额：" text:@""]];
            
            NSMutableArray *menus1 = [[NSMutableArray alloc] init];
            
            [menus1 addObject:[self createRow:@"会员名：" text:[BWCommon getUserInfo:@"username"] ]];
            [menus1 addObject:[self createRow:@"账户余额：" text:[data objectForKey:@"auction"] ]];
            [menus1 addObject:[self createRow:@"转账金额：" text:@""]];
            
            NSMutableArray *menus2 = [[NSMutableArray alloc] init];
            
            [menus2 addObject:[self createRow:@"会员名：" text:[BWCommon getUserInfo:@"username"] ]];
            [menus2 addObject:[self createRow:@"账户余额：" text:[data objectForKey:@"balance"] ]];
            [menus2 addObject:[self createRow:@"转账金额：" text:@""]];
            
            
            self.list[0] = menus0;
            self.list[1] = menus1;
            self.list[2] = menus2;
            
            self.statusFrames = nil;
            
            //NSLog(@"%@",self.list);
            
            [self.tableView reloadData];
        }
        else
        {
            NSLog(@"%@",[responseObject objectForKey:@"error"]);
        }
        
    } fail:^{
        NSLog(@"请求失败");
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    
    if([[sectionArray objectAtIndex:section]  isEqual: @"1"])
    {
        return 4;
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == 3)
        return 60;

    return 48;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (NSArray *)statusFrames
{
    if (_statusFrames == nil) {
        
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:titleArray.count];
        
        for (int i=0;i < titleArray.count;i++){
            
            NSMutableArray *tmp = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dict in [self.list objectAtIndex:i]) {
                // 创建模型
                TransferTableViewFrame *vf = [[TransferTableViewFrame alloc] init];
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

- (void) doTouched:(UIButton *) sender{
    
    NSString *price ;
    NSString *apiName;
    if(sender.tag == 0){
        price = self.field0.text;
        apiName = @"account/balanceToAuction";
    }
    else if(sender.tag == 1){
        price = self.field1.text;
        apiName = @"account/auctionToBalance";
    }
    else if(sender.tag == 2){
        price = self.field2.text;
        apiName = @"account/balanceToHuaji";
    }
    NSLog(@"%@",price);

    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:apiName];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:apiName];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统提示" message:@"请先输入金额" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    if([price isEqual:@""])
    {
        
        [alert show];
        return;
    }
    
    [postData setValue:price forKey:@"amount"];
    
    NSLog(@"%@",postData);
    //load data
    
    
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        
        NSLog(@"%@",responseObject);
        if(errNo == 0)
        {
            
            //NSLog(@"%@",json);
            //[alert setMessage:@"操作成功！"];
            
            [self loadData:^{}];
        }
        else
        {
            NSLog(@"%@",[responseObject objectForKey:@"error"]);
            [alert setMessage:[responseObject objectForKey:@"error"]];
            [alert show];
        }
        
    } fail:^{

        NSLog(@"请求失败");
        [alert setMessage:@"连接超时，请重试"];
        [alert show];
    }];

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(indexPath.row == 3)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell11"];
        }
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, size.width - 40, 40)];
        [button setBackgroundColor:[BWCommon getRedColor]];
        button.layer.cornerRadius = 5.0f;
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [button setTitle:@"确定转账" forState:UIControlStateNormal];
        
        button.tag = indexPath.section;
        [button addTarget:self action:@selector(doTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:button];
        
        return cell;
    }
    else
    {
    
        TransferTableViewCell * cell = [TransferTableViewCell cellWithTableView:tableView];
        cell.viewFrame = self.statusFrames[indexPath.section][indexPath.row];
        cell.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
        if(indexPath.row == 2){
            UITextField *amountField = [[UITextField alloc] initWithFrame:CGRectMake(125, 10, size.width-130, 30)];
            //amountField.backgroundColor = [UIColor grayColor];
            amountField.placeholder = @"输入金额";
            amountField.font = [UIFont systemFontOfSize:14];
            amountField.tag = indexPath.section;
            amountField.keyboardType = UIKeyboardTypeDecimalPad;
            [cell.contentView addSubview:amountField];
            if(indexPath.section == 0)
                self.field0 = amountField;
            else if(indexPath.section == 1)
                self.field1 = amountField;
            else if(indexPath.section == 2)
                self.field2 = amountField;
            //fieldArray[indexPath.section] = amountField;
        }
        
        return cell;
    }

}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    NSInteger dwidth = self.view.frame.size.width;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dwidth, 15)];
    
    footView.backgroundColor = [BWCommon getBackgroundColor];
    
    return footView;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSInteger dwidth = self.view.frame.size.width;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dwidth, 50)];
    
    headView.backgroundColor = [UIColor whiteColor];
    
    UIButton * myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = CGRectMake(0, 0, dwidth, 50);
    [headView addSubview:myButton];
    

    NSInteger icon1 = section + 1;
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"account-%ld",(long)icon1]]];
    
    icon.frame = CGRectMake(10, 10, 30, 30);
    
    [myButton addSubview:icon];
    myButton.tag = section;
    
    [myButton addTarget:self action:@selector(sectionTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 20, 120, 20)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    
    titleLabel.text = [titleArray objectAtIndex:section];
    
    [myButton addSubview:titleLabel];
    
    [headView sizeToFit];
    
    [BWCommon setBottomBorder:headView color:[BWCommon getBorderColor]];
    
    return headView;
}

-(void) sectionTouched:(UIButton *) sender{
    
    sectionArray[0] = @"0";
    sectionArray[1] = @"0";
    sectionArray[2] = @"0";
    
    sectionArray[sender.tag] = @"1";
    
    [[self tableView] reloadData];
    //NSIndexSet *set = [NSIndexSet indexSetWithIndex:sender.tag];
    //[self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
