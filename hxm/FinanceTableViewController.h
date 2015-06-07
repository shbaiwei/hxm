//
//  FinanceTableViewController.h
//  hxm
//
//  Created by Bruce He on 15-5-29.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface FinanceTableViewController : UITableViewController
<MBProgressHUDDelegate
>
{
    
    MBProgressHUD *hud;
}

@end
