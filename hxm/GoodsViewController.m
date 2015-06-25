//
//  GoodsViewController.m
//  hxm
//
//  Created by Bruce on 15-5-19.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "GoodsViewController.h"
#import "BWCommon.h"
#import "GoodsTableViewCell.h"
#import "GoodsListViewController.h"
#import "ConsignationTableViewController.h"
#import "AuctionTableViewController.h"

@interface GoodsViewController ()

@property (nonatomic,retain) NSMutableArray *list;

@end

@implementation GoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
}

-(void) pageLayout{
    self.navigationItem.title = @"商品管理";
    
    UIColor *bgColor = [BWCommon getBackgroundColor];
    
    self.view.backgroundColor = bgColor;
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.image=[UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem=backItem;
    
    //CGRect rect = [[UIScreen mainScreen] bounds];
    //CGSize size = rect.size;

    NSMutableArray *menus0 = [[NSMutableArray alloc] init];
    NSMutableDictionary *row0 = [[NSMutableDictionary alloc] init];
    [row0 setValue:@"在售商品" forKey:@"title"];
    UIImage *icon = [UIImage imageNamed:@"goods-1.png"];
    [row0 setValue:icon forKey:@"image"];
    
    [menus0 addObject:row0];
    
    NSMutableArray *menus1 = [[NSMutableArray alloc] init];
    
    row0 = [[NSMutableDictionary alloc] init];
    [row0 setValue:@"委托记录" forKey:@"title"];
    icon = [UIImage imageNamed:@"goods-2.png"];
    [row0 setValue:icon forKey:@"image"];
    [menus1 addObject:row0];
    
    NSMutableArray *menus2 = [[NSMutableArray alloc] init];
    row0 = [[NSMutableDictionary alloc] init];
    [row0 setValue:@"拍卖顺序" forKey:@"title"];
    icon = [UIImage imageNamed:@"goods-3.png"];
    [row0 setValue:icon forKey:@"image"];
    
    [menus2 addObject:row0];
    
    
    self.list = [[NSMutableArray alloc] init];
    
    [self.list addObject:menus0];
    [self.list addObject:menus1];
    [self.list addObject:menus2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return [self.list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.list objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *identifier = @"cell0";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[GoodsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    NSInteger section = [indexPath indexAtPosition:0];
    NSInteger row = [indexPath indexAtPosition:1];
    
    NSArray *data = [[NSArray alloc] initWithArray:[self.list objectAtIndex:section]];
    
    cell.textLabel.text = [[data objectAtIndex:row] objectForKey:@"title"];
    cell.imageView.image = [[data objectAtIndex:row] objectForKey:@"image"];
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    myView.backgroundColor = [BWCommon getBackgroundColor];

    
    [BWCommon setBottomBorder:myView color:[BWCommon getBorderColor]];
    

    return myView;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView* myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    myView.backgroundColor = [BWCommon getBackgroundColor];

    
    [BWCommon setTopBorder:myView color:[BWCommon getBorderColor]];
    
    return myView;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSUInteger detail_id;
    //detail_id = [[[dataArray objectAtIndex:[indexPath row]] objectForKey:@"id"] integerValue];
    
    /*UserInfoTableViewController *userInfoTableViewController = [[UserInfoTableViewController alloc] init];
     userInfoTableViewController.hidesBottomBarWhenPushed = YES;
     
     [self.navigationController pushViewController:userInfoTableViewController animated:YES];
     */
    
    NSInteger row = [indexPath indexAtPosition:0];
    if(row == 0){
        //在售商品
        GoodsListViewController *goodsListViewController = [[GoodsListViewController alloc] init];
        goodsListViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodsListViewController animated:YES];
        
    }
    else if(row == 1){
        //委托记录
        ConsignationTableViewController *consignationViewController = [[ConsignationTableViewController alloc] init];
        consignationViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:consignationViewController animated:YES];
        
    }
    else if(row==2){
        //拍卖顺序
        AuctionTableViewController *consignationViewController = [[AuctionTableViewController alloc] init];
        consignationViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:consignationViewController animated:YES];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
