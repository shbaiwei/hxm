//
//  NearbyTableViewCell.h
//  easyshanghai
//
//  Created by Bruce He on 15-5-21.
//  Copyright (c) 2015年 shanghai baiwei network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderTableViewFrame.h"
#import "UIImageView+WebCache.h"

@interface OrderTableViewCell : UITableViewCell

@property (nonatomic,strong) OrderTableViewFrame *viewFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) UIButton *commentButton;
@property (nonatomic, weak) UIButton *noteButton;

@end
