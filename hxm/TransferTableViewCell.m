//
//  FinanceTableViewCell.m
//  hxm
//
//  Created by Bruce He on 15-5-29.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "TransferTableViewCell.h"
#import "TransferTableViewFrame.h"
#import "BWCommon.h"

#define NJNameFont [UIFont systemFontOfSize:16]


@interface TransferTableViewCell ()

@end

@implementation TransferTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

-(void) layoutSubviews{
    [super layoutSubviews];
    
    /*self.imageView.bounds = CGRectMake(10, 10, 30, 30);
     self.imageView.frame = CGRectMake(10, 10, 30, 30);
     self.imageView.contentMode = UIViewContentModeScaleAspectFill;
     */
    
    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = 55;
    self.textLabel.frame = tmpFrame;
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //self.accessoryType = UITableViewCellAccessoryNone;
    
    
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *identifier = @"cell0";
    TransferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //if (cell == nil) {
    
    cell = [[TransferTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    //}
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

- (void)setViewFrame:(TransferTableViewFrame *)viewFrame
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
    [self.textLabel setTextColor:[BWCommon getRGBColor:0x333333]];
    self.textLabel.font = [UIFont systemFontOfSize:14 weight:10];
    
    self.valueLabel.frame = self.viewFrame.valueF;
    self.valueLabel.font = [UIFont systemFontOfSize:14];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
