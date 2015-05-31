//
//  MyAddressTableViewCell.h
//  hxm
//
//  Created by spring on 15/5/30.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAddressTableViewFrame.h"

@interface MyAddressTableViewCell : UITableViewCell

@property (nonatomic,strong) MyAddressTableViewFrame *viewFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end