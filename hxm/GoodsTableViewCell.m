//
//  GoodsTableViewCell.m
//  hxm
//
//  Created by Bruce He on 15-5-29.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "GoodsTableViewCell.h"

@implementation GoodsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void) layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.bounds = CGRectMake(25, 5, 36, 36);
    self.imageView.frame = CGRectMake(25, 5, 36, 36);
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    

    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = 70;
    self.textLabel.frame = tmpFrame;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
