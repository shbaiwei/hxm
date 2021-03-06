//
//  ConsignationTableViewController.h
//  hxm
//
//  Created by Bruce on 15-6-2.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "DetailDelegate.h"


@interface ConsignationTableViewController : UITableViewController
<MBProgressHUDDelegate>
{
    MBProgressHUD *hud;
}

@property (nonatomic, retain) NSMutableArray *dataArray;

@property (nonatomic,assign) id<DetailDelegate> delegate;

@end
