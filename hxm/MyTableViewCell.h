//
//  MyTableViewCell.h
//  hxm
//
//  Created by Bruce He on 15/6/26.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTableViewFrame.h"

@interface MyTableViewCell : UITableViewCell

@property (nonatomic,strong) MyTableViewFrame *viewFrame;

@property (nonatomic,retain) UILabel *valueLabel;
@property (nonatomic,retain) UIImageView *iconImage;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
