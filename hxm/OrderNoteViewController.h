//
//  OrderNoteViewController.h
//  hxm
//
//  Created by Bruce He on 15/6/4.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailDelegate.h"
#import "MBProgressHUD.h"

@interface OrderNoteViewController : UIViewController
<OrderDetailDelegate,
UIPickerViewDelegate,
UIPickerViewDataSource,
MBProgressHUDDelegate,
UIAlertViewDelegate
>
{
    MBProgressHUD *hud;
}

@end
