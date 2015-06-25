//
//  ConsignationDetailViewController.h
//  hxm
//
//  Created by Bruce He on 15/6/25.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailDelegate.h"
#import "MBProgressHUD.h"

@interface ConsignationDetailViewController : UIViewController
<DetailDelegate,
MBProgressHUDDelegate>
{
    MBProgressHUD *hud;
}
@end
