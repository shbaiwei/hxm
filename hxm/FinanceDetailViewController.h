//
//  FinanceDetailViewController.h
//  hxm
//
//  Created by Bruce He on 15/6/7.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "XCMultiSortTableView.h"

@interface FinanceDetailViewController : UIViewController
<
XCMultiTableViewDataSource,
MBProgressHUDDelegate>
{
    MBProgressHUD *hud;
}

@end
