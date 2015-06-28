//
//  MyBusinessInfoViewController.h
//  hxm
//
//  Created by spring on 15/5/28.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MyBusinessInfoViewController : UIViewController
<UITextFieldDelegate,
UIActionSheetDelegate,
MBProgressHUDDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate,
UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSDictionary *userinfo;
@property (nonatomic, strong) NSDictionary *business_types;
@end
