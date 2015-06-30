//
//  OrderComplainViewController.h
//  hxm
//
//  Created by Bruce He on 15/6/30.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailDelegate.h"
#import "MBProgressHUD.h"

@interface OrderComplainViewController : UIViewController
<OrderDetailDelegate,
MBProgressHUDDelegate,
UIAlertViewDelegate,
UIGestureRecognizerDelegate>
{
    MBProgressHUD *hud;
}

@end
