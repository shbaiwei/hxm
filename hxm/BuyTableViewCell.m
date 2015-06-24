//
//  FinanceTableViewCell.m
//  hxm
//
//  Created by Bruce He on 15-5-29.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "BuyTableViewCell.h"
#import "BuyTableViewFrame.h"

#define NJNameFont [UIFont systemFontOfSize:14]


@interface BuyTableViewCell ()

@end

@implementation BuyTableViewCell


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
    
    //self.accessoryType = UITableViewCellAccessoryNone;
    
    
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *identifier = @"cell0";
    BuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[BuyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *valueLabel = [[UILabel alloc] init];
        
        self.valueLabel = valueLabel;
        [self.contentView addSubview:valueLabel];
    }
    
    return self;
}

- (void)setViewFrame:(BuyTableViewFrame *)viewFrame
{
    _viewFrame = viewFrame;
    
    // 1.给子控件赋值数据
    [self settingData];
    [self settingFrame];
}

/**
 *  设置子控件的数据
 */
- (void)settingData
{
    
    NSDictionary *data = self.viewFrame.data;
    
    
    self.textLabel.text = [data objectForKey:@"title"];
    self.valueLabel.text = [data objectForKey:@"text"];
    
    
}

/**
 *  设置子控件的frame
 */
- (void)settingFrame
{
    
    self.textLabel.frame = self.viewFrame.textF;
    self.textLabel.font = [UIFont systemFontOfSize:16 weight:10];
    
    self.valueLabel.frame = self.viewFrame.valueF;
    self.valueLabel.font = NJNameFont;
    self.valueLabel.numberOfLines = 0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
