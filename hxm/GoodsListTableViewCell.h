//
//  GoodsListTableViewCell.h
//  hxm
//
//  Created by Bruce He on 15-5-30.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListTableViewFrame.h"
#import "UIImageView+WebCache.h"

@interface GoodsListTableViewCell : UITableViewCell

@property (nonatomic,strong) GoodsListTableViewFrame *viewFrame;

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

@property  (nonatomic, weak) UILabel *disableLabel;

// 名称
@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UIView  *tipsView;

@property (nonatomic, weak) UILabel *tipsLabel;
@property (nonatomic, weak) UILabel *tips2Label;
@property (nonatomic, weak) UILabel *tipsValue;

@end
