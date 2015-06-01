//
//  MyViewController.h
//  hxm
//
//  Created by Bruce He on 15-5-21.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MyViewController : UIViewController <UIActionSheetDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *hud;
}
@end
