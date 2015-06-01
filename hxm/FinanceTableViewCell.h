//
//  FinanceTableViewCell.h
//  hxm
//
//  Created by Bruce He on 15-5-29.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinanceTableViewFrame.h"

@interface FinanceTableViewCell : UITableViewCell

@property (nonatomic,strong) FinanceTableViewFrame *viewFrame;

@property (nonatomic,retain) UILabel *valueLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
