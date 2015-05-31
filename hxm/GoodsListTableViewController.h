//
//  GoodsListTableViewController.h
//  hxm
//
//  Created by Bruce He on 15-5-30.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface GoodsListTableViewController : UITableViewController
<MBProgressHUDDelegate>{
    
    MBProgressHUD *hud;
}

@property (nonatomic,retain) NSMutableArray *dataArray;

@end
