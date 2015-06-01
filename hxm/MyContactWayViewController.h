//
//  MyContactWayViewController.h
//  
//
//  Created by spring on 15/5/28.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface MyContactWayViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate>
@property (nonatomic, strong) NSDictionary *userinfo;

@end
