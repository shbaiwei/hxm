//
//  GoodsListTableViewCell.h
//  hxm
//
//  Created by Bruce He on 15-5-30.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListTableViewFrame.h"

@interface GoodsListTableViewCell : UITableViewCell

@property (nonatomic,strong) GoodsListTableViewFrame *viewFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
