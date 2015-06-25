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
@property (nonatomic,weak) UILabel *priceLabel;
@property (nonatomic,weak) UILabel *priceValue;
@property (nonatomic,weak) UILabel *statusLabel;
@property (nonatomic,weak) UILabel *inLabel;
@property (nonatomic,weak) UILabel *inValue;
@property (nonatomic,weak) UILabel *packLabel;
@property (nonatomic,weak) UILabel *packValue;
@property (nonatomic,weak) UIView *inRowView;
@property (nonatomic,weak) UIView *packRowView;



@end
