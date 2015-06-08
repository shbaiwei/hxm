//
//  LoginViewController.h
//  hxm
//
//  Created by Bruce He on 15-5-14.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LoginViewController : UIViewController
<UITextFieldDelegate,
UIGestureRecognizerDelegate,
MBProgressHUDDelegate>{
    
    MBProgressHUD *hud;
}

@property (nonatomic,strong) UITextField *username;
@property (nonatomic,strong) UITextField *password;

@end
