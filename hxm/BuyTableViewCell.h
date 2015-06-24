//
//  BuyTableViewCell.h
//  hxm
//
//  Created by Bruce He on 15/6/24.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyTableViewFrame.h"

@interface BuyTableViewCell : UITableViewCell

@property (nonatomic,strong) BuyTableViewFrame *viewFrame;

@property (nonatomic,retain) UILabel *valueLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end