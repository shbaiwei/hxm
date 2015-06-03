//
//  PasswordSaleViewController.h
//  hxm
//
//  Created by spring on 15/5/29.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface PasswordSaleViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>
{
    UITextField *code;
    UITextField *password;
    UITextField *confirmpassword;
}
@property (nonatomic,retain) NSString *mobile;
@property (nonatomic ,retain) UITextField *code;
@property (nonatomic,retain) UITextField *password;
@property (nonatomic,retain) UITextField *confirmpassword;
@end
