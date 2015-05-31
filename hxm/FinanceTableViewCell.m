//
//  FinanceTableViewCell.m
//  hxm
//
//  Created by Bruce He on 15-5-29.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "FinanceTableViewCell.h"

@implementation FinanceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void) layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.bounds = CGRectMake(25, 5, 44, 44);
    self.imageView.frame = CGRectMake(25, 5, 44, 44);
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = 30;
    self.textLabel.frame = tmpFrame;
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.accessoryType = UITableViewCellAccessoryNone;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
