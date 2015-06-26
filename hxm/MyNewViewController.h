//
//  MyNewViewController.h
//  hxm
//
//  Created by Bruce He on 15/6/26.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MyNewViewController : UIViewController
<MBProgressHUDDelegate,
UITableViewDataSource,
UITableViewDelegate>
{
    
    MBProgressHUD *hud;
}

@property (nonatomic,strong) UITableView *tableview;
@end
