//
//  MyAfterSaleTableViewCell.h
//  hxm
//
//  Created by spring on 15/5/30.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MyAfterSaleTableViewFrame.h"

@interface MyAfterSaleTableViewCell : UITableViewCell

@property (nonatomic,strong) MyAfterSaleTableViewFrame *viewFrame;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic,strong) UIButton *logisticsButton;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

