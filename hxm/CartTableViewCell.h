//
//  CartTableViewCell.h
//  hxm
//
//  Created by Bruce He on 15/6/7.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "CartTableViewFrame.h"

@interface CartTableViewCell : UITableViewCell


@property (nonatomic,strong) CartTableViewFrame *viewFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,weak) UIView *borderView;

@property (nonatomic, weak) UIButton *buyButton;

@property (nonatomic, weak) UIButton *auctionButton;
@property (nonatomic, weak) UIButton *cartButton;

@property (nonatomic,weak) UIView *levelView;

@property (nonatomic,weak) UIView *limitView;

@property (nonatomic,weak) UIView *merchantView;

@property (nonatomic,weak) UILabel *levelLabel;

@property (nonatomic,weak) UILabel *limitLabel;

@property (nonatomic,weak) UILabel *merchantLabel;

@property  (nonatomic, weak) UILabel *priceLabel;
// 名称
@property (nonatomic, weak) UILabel *nameLabel;

@end
