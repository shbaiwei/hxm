//
//  ApplyViewController.h
//  hxm
//
//  Created by Bruce on 15-5-19.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ApplyViewController : UIViewController
<
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UITextFieldDelegate,
UINavigationControllerDelegate,
MBProgressHUDDelegate,
UIGestureRecognizerDelegate,
UIPickerViewDelegate,
UIPickerViewDataSource,
UIAlertViewDelegate
>
{
    MBProgressHUD *hud;
    
}

- (void) snapImage;//拍照
- (void) pickImage;//从相册里找

@end
