//
//  PayViewController.h
//  hxm
//
//  Created by Bruce on 15-7-1.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface PayViewController : UIViewController
<
MBProgressHUDDelegate,
UIGestureRecognizerDelegate>
{
    MBProgressHUD *hud;
}
@end
