//
//  BuyTableViewController.h
//  hxm
//
//  Created by Bruce He on 15/6/24.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "DetailDelegate.h"
#import "OrderDetailDelegate.h"

@interface BuyTableViewController : UITableViewController
<MBProgressHUDDelegate,
DetailDelegate,
UIAlertViewDelegate
>
{
    MBProgressHUD *hud;
}

@property (nonatomic,assign) id<OrderDetailDelegate> delegate;
@end
