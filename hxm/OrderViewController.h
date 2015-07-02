//
//  OrderViewController.h
//  hxm
//
//  Created by Bruce on 15-5-19.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "OrderDetailDelegate.h"
#import "DOPDropDownMenu.h"
#import "MJRefresh.h"

@interface OrderViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate,
MBProgressHUDDelegate,
DOPDropDownMenuDataSource,
DOPDropDownMenuDelegate
>{
    
    MBProgressHUD *hud;
    NSMutableArray *_items;
    NSMutableArray *_itemsKeys;
    
    
    NSMutableArray *dataArray; //创建个数组来放我们的数据
}

@property (nonatomic,retain) NSMutableArray *items;
@property (nonatomic,retain) NSMutableArray *itemsKeys;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,assign) id<OrderDetailDelegate> delegate;
@end
