//
//  PasswordLoginViewController.h
//  hxm
//
//  Created by spring on 15/5/29.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface PasswordLoginViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>
{
    UITextField *password;
    UITextField *newpassword;
    UITextField *confirmpassword;
}
@property (nonatomic,retain) NSString *mobile;
@property (nonatomic ,retain) UITextField *password;
@property (nonatomic,retain) UITextField *newpassword;
@property (nonatomic,retain) UITextField *confirmpassword;

-(IBAction)backgroundTap:(id)sender;
-(UITextField *) createTextFieldWithTitle:(NSString *) title yy:(NSInteger)yy;
@end
