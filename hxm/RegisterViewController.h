//
//  RegisterViewController.h
//  hxm
//
//  Created by Bruce on 15-5-14.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface RegisterViewController : UIViewController
<UITextFieldDelegate,
UIGestureRecognizerDelegate,
MBProgressHUDDelegate>{
    
    MBProgressHUD *hud;
}


@end
