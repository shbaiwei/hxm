//
//  GoodsListTableViewController.h
//  hxm
//
//  Created by Bruce He on 15-5-30.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "DetailDelegate.h"

@interface GoodsListViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate,
MBProgressHUDDelegate>{
    
    MBProgressHUD *hud;
}

@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,assign) id<DetailDelegate> delegate;

@end
