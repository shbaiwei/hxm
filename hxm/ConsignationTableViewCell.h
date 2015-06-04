//
//  ConsignationTableViewCell.h
//  hxm
//
//  Created by Bruce on 15-6-2.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsignationTableViewFrame.h"

@interface ConsignationTableViewCell : UITableViewCell

@property (nonatomic,strong) ConsignationTableViewFrame *viewFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@property (nonatomic,weak) UIView *borderView;
@property (nonatomic,weak) UILabel *priceLabel;
@property (nonatomic,weak) UILabel *priceValue;
@property (nonatomic,weak) UILabel *statusLabel;
@property (nonatomic,weak) UILabel *inLabel;
@property (nonatomic,weak) UILabel *inValue;
@property (nonatomic,weak) UILabel *packLabel;
@property (nonatomic,weak) UILabel *packValue;

@end
