//
//  ConsignationTableViewCell.m
//  hxm
//
//  Created by Bruce on 15-6-2.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "ConsignationTableViewCell.h"
#import "ConsignationTableViewFrame.h"
#import "BWCommon.h"


#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]
#define NJStatusFont [UIFont systemFontOfSize:10]

@implementation ConsignationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10, 25, 90, 90 );
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{

    static NSString *identifier = @"status";
    ConsignationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[ConsignationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 让自定义Cell和系统的cell一样, 一创建出来就拥有一些子控件提供给我们使用
        
        UIView *view = [[UIView alloc] init];
        
        view.backgroundColor = [BWCommon getBackgroundColor];
        
        
        [self.contentView addSubview:view];
        self.borderView = view;
        
        UILabel *priceLabel = [[UILabel alloc] init];
        self.priceLabel = priceLabel;
        priceLabel.text = @"委托价";
        [priceLabel setTextColor:[BWCommon getRedColor]];
        [self.contentView addSubview:priceLabel];
        priceLabel.font = NJNameFont;
        
        UILabel *priceValue = [[UILabel alloc] init];
        self.priceValue = priceValue;
        [self.contentView addSubview:priceValue];
        [priceValue setTextColor:[BWCommon getRedColor]];
        
        UILabel *statusLabel = [[UILabel alloc] init];
        self.statusLabel = statusLabel;
        statusLabel.font = NJStatusFont;
        statusLabel.textAlignment = NSTextAlignmentCenter;
        [statusLabel setTextColor:[UIColor whiteColor]];
        
        [statusLabel setBackgroundColor:[BWCommon getMainColor]];
        
        [self.contentView addSubview:statusLabel];
        
        UIView *inRowView = [[UIView alloc] init];
        [self.contentView addSubview:inRowView];
        self.inRowView = inRowView;
        
        UILabel *inLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1, 62, 20)];
        self.inLabel = inLabel;
        
        inLabel.text = @"商品入数";
        [inRowView addSubview:inLabel];
        [inRowView setBackgroundColor:[UIColor lightGrayColor]];
        
        inLabel.font = NJTextFont;
        [inLabel setTextColor:[UIColor whiteColor]];
        //[inLabel setBackgroundColor:[UIColor whi]];
        
        UILabel *inValue = [[UILabel alloc] initWithFrame:CGRectMake(67, 1, 62, 20)];
        self.inValue = inValue;
        [inRowView addSubview:inValue];
        [inValue setBackgroundColor:[UIColor whiteColor]];
        inValue.textAlignment = NSTextAlignmentCenter;
        inValue.font = NJTextFont;
        
        UIView *packRowView = [[UIView alloc] init];
        [self.contentView addSubview:packRowView];
        self.packRowView = packRowView;
        
        [packRowView setBackgroundColor:[UIColor lightGrayColor]];
        
        UILabel *packLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1, 62, 20)];
        self.packLabel = packLabel;
        packLabel.text = @"已委托数量";
        [packRowView addSubview:packLabel];
        
        packLabel.font = NJTextFont;
        [packLabel setTextColor:[UIColor whiteColor]];
        //[packLabel setBackgroundColor:[UIColor lightGrayColor]];
        
        UILabel *packValue = [[UILabel alloc] initWithFrame:CGRectMake(67, 1, 62, 20)];
        self.packValue = packValue;
        [packRowView addSubview:packValue];
        packValue.font = NJTextFont;
        [packValue setBackgroundColor:[UIColor whiteColor]];
        packValue.textAlignment = NSTextAlignmentCenter;
        
        
    }
    return self;
}

/**
 *  计算文本的宽高
 *
 *  @param str     需要计算的文本
 *  @param font    文本显示的字体
 *  @param maxSize 文本显示的范围
 *
 *  @return 文本占用的真实宽高
 */
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

- (void)setViewFrame:(ConsignationTableViewFrame *)viewFrame
{
    _viewFrame = viewFrame;
    
    // 1.给子控件赋值数据
    [self settingData];
    // 2.设置frame
    [self settingFrame];
}

/**
 *  设置子控件的数据
 */
- (void)settingData
{
    
    NSDictionary *data = self.viewFrame.data;

    NSString *image_url = [data objectForKey:@"img1"];
    
    //[self.imageView sd_setImageWithURL:[NSURL URLWithString:image_url]];
    //[self.imageView sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageProgressiveDownload];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:[UIImage imageNamed:@"icon.png"] options:SDWebImageCacheMemoryOnly];
    
    self.priceValue.text = [NSString stringWithFormat:@"¥ %@",[data objectForKey:@"price"]];
    self.inValue.text = [data objectForKey:@"ent_num"];
    self.packValue.text = [NSString stringWithFormat:@"%@ 箱", [data objectForKey:@"etr_qty"] ];
    self.statusLabel.text =[data objectForKey:@"status"];
    
    
    
}
/**
 *  设置子控件的frame
 */
- (void)settingFrame
{
    
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.borderWidth=1.0;
    
    self.borderView.frame = self.viewFrame.borderViewF;
    self.priceLabel.frame = self.viewFrame.priceLabelF;
    self.priceValue.frame = self.viewFrame.priceValueF;
    self.statusLabel.frame = self.viewFrame.statusLabelF;
    //self.inLabel.frame = self.viewFrame.inLabelF;
    //self.inValue.frame = self.viewFrame.inValueF;
    //self.packLabel.frame = self.viewFrame.packLabelF;
    //self.packValue.frame = self.viewFrame.packValueF;
    
    self.inRowView.frame = self.viewFrame.inRowF;
    self.packRowView.frame = self.viewFrame.packRowF;


    
}



@end
