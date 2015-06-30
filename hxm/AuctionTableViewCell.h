//
//  AuctionTableViewCell.h
//  hxm
//
//  Created by Bruce He on 15/6/25.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuctionTableViewFrame.h"
#import "UIImageView+WebCache.h"

@interface AuctionTableViewCell : UITableViewCell

@property (nonatomic,strong) AuctionTableViewFrame *viewFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@property (nonatomic,weak) UIView *borderView;
@property (nonatomic,weak) UILabel *aucNoLabel;
@property (nonatomic,weak) UILabel *aucNoValue;
@property (nonatomic,weak) UILabel *statusLabel;
@property (nonatomic,weak) UILabel *channelLabel;
@property (nonatomic,weak) UILabel *channelValue;
@property (nonatomic,weak) UILabel *catLabel;
@property (nonatomic,weak) UILabel *catValue;
@property (nonatomic,weak) UILabel *cat2Label;
@property (nonatomic,weak) UILabel *cat2Value;
@property (nonatomic,weak) UIView *channelRowView;
@property (nonatomic,weak) UIView *catRowView;
@property (nonatomic,weak) UIView *cat2RowView;



@end
