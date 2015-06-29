//
//  MyAddressEditViewController.h
//  hxm
//
//  Created by spring on 15/6/1.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "DetailDelegate.h"

@interface MyAddressEditViewController : UIViewController
<UITextFieldDelegate,
MBProgressHUDDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate,
DetailDelegate,
UIGestureRecognizerDelegate>
{
    
    MBProgressHUD *hud;
}
@property (nonatomic,strong) NSDictionary *addressInfo;
@property (retain, nonatomic) UITextField *areaText;
@property (strong, nonatomic) NSString *areaValue;



@end
