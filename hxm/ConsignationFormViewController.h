//
//  ConsignationFormViewController.h
//  hxm
//
//  Created by Bruce He on 15/6/24.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailDelegate.h"
#import "MBProgressHUD.h"

@interface ConsignationFormViewController : UIViewController
<DetailDelegate,
MBProgressHUDDelegate,
UITextFieldDelegate,
UIGestureRecognizerDelegate>
{
    MBProgressHUD *hud;
}

@end
