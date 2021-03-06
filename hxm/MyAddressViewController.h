//
//  MyAddressViewController.h
//  hxm
//
//  Created by spring on 15/5/28.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "DetailDelegate.h"

@interface MyAddressViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *hud;
    NSMutableArray *_items;
    NSMutableArray *_itemsKeys;
    
    
    NSMutableArray *dataArray; //创建个数组来放我们的数据
}

@property (nonatomic,retain) NSMutableArray *items;
@property (nonatomic,retain) NSMutableArray *itemsKeys;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,retain) NSMutableArray *dataArray;

@property (nonatomic,assign) id<DetailDelegate> delegate;
@end
