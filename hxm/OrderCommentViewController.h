//
//  OrderCommentViewController.h
//  hxm
//
//  Created by Bruce He on 15/6/4.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailDelegate.h"
#import "MBProgressHUD.h"

@interface OrderCommentViewController : UIViewController
<OrderDetailDelegate,
MBProgressHUDDelegate,
UIAlertViewDelegate,
UIGestureRecognizerDelegate>
{
    MBProgressHUD *hud;
}

@end
