//
//  TransferTableViewCell.h
//  hxm
//
//  Created by Bruce He on 15/7/1.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransferTableViewFrame.h"

@interface TransferTableViewCell : UITableViewCell

@property (nonatomic,strong) TransferTableViewFrame *viewFrame;

@property (nonatomic,retain) UILabel *valueLabel;


+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
