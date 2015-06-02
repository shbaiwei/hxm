//
//  FinanceViewController.h
//  hxm
//
//  Created by Bruce on 15-6-1.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface FinanceViewController : UIViewController
<MBProgressHUDDelegate>{
    
    MBProgressHUD *hud;
}

@end
