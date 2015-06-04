//
//  OrderDetailViewController.h
//  hxm
//
//  Created by Bruce on 15-6-1.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailDelegate.h"
#import "XCMultiSortTableView.h"
#import "MBProgressHUD.h"

@interface OrderDetailViewController : UIViewController
<OrderDetailDelegate,
XCMultiTableViewDataSource,
MBProgressHUDDelegate>
{
    MBProgressHUD *hud;
}

@property (nonatomic,assign) id<OrderDetailDelegate> delegate;
@end
