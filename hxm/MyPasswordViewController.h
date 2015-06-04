//
//  MyPasswordViewController.h
//  hxm
//
//  Created by spring on 15/5/28.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MyPasswordViewController : UIViewController<MBProgressHUDDelegate>
{
    MBProgressHUD *hud;
}
@property(nonatomic,retain) NSString *mobile;
@end
