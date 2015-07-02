//
//  TransferTableViewController.h
//  hxm
//
//  Created by Bruce He on 15/7/1.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface TransferTableViewController : UITableViewController
<
MBProgressHUDDelegate,
UIGestureRecognizerDelegate>
{
    MBProgressHUD *hud;
}

@end
