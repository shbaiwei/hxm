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
@property (nonatomic,weak) UIView *headerView;

@property (nonatomic,weak) UILabel *sellerLabel;


@property (nonatomic,weak) UILabel *quantityLabel;
@property (nonatomic,weak) UILabel *quantity2Label;

@property (nonatomic,weak) UILabel *subtotalLabel;

@property (nonatomic,weak) UILabel *merchantLabel;

@property  (nonatomic, weak) UILabel *priceLabel;
// 名称
@property (nonatomic, weak) UILabel *nameLabel;

@end
