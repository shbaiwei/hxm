//
//  GoodsDetailViewController.h
//  hxm
//
//  Created by Bruce He on 15-5-31.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailDelegate.h"
#import "MBProgressHUD.h"

@interface GoodsDetailViewController : UIViewController
<DetailDelegate,
MBProgressHUDDelegate>
{
    MBProgressHUD *hud;
}

@end
