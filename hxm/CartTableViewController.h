//
//  CartTableViewController.h
//  hxm
//
//  Created by Bruce He on 15/6/7.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "DetailDelegate.h"

@interface CartTableViewController : UITableViewController
<MBProgressHUDDelegate,
DetailDelegate
>{
    
    MBProgressHUD *hud;
}

@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,assign) id<DetailDelegate> delegate;

@end
