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
    self.imageView.frame = CGRectMake(10, 10, 90, 90 );
    
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
        [priceLabel setTextColor:[UIColor redColor]];
        [self.contentView addSubview:priceLabel];
        priceLabel.font = NJNameFont;
        
        UILabel *priceValue = [[UILabel alloc] init];
        self.priceValue = priceValue;
        [self.contentView addSubview:priceValue];
        [priceValue setTextColor:[UIColor redColor]];
        
        UILabel *statusLabel = [[UILabel alloc] init];
        self.statusLabel = statusLabel;
        statusLabel.font = NJStatusFont;
        statusLabel.textAlignment = NSTextAlignmentCenter;
        [statusLabel setTextColor:[UIColor whiteColor]];
        
        [statusLabel setBackgroundColor:[BWCommon getMainColor]];
        
        [self.contentView addSubview:statusLabel];
        
        UILabel *inLabel = [[UILabel alloc] init];
        self.inLabel = inLabel;
        
        inLabel.text = @"商品入数";
        [self.contentView addSubview:inLabel];
        inLabel.font = NJTextFont;
        [inLabel setTextColor:[UIColor whiteColor]];
        [inLabel setBackgroundColor:[UIColor lightGrayColor]];
        
        UILabel *inValue = [[UILabel alloc] init];
        self.inValue = inValue;
        [self.contentView addSubview:inValue];
        inValue.font = NJTextFont;
        
        UILabel *packLabel = [[UILabel alloc] init];
        self.packLabel = packLabel;
        packLabel.text = @"已委托数量";
        [self.contentView addSubview:packLabel];
        packLabel.font = NJTextFont;
        [packLabel setTextColor:[UIColor whiteColor]];
        [packLabel setBackgroundColor:[UIColor lightGrayColor]];
        
        UILabel *packValue = [[UILabel alloc] init];
        self.packValue = packValue;
        [self.contentView addSubview:packValue];
        packValue.font = NJTextFont;
        
        
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

    NSString *image_url = [data objectForKey:@""];
    
    [self.imageView setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image_url]]]];
    
    CGSize itemSize = CGSizeMake(90, 90);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, 120);
    [self.imageView.image drawInRect:imageRect];
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
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
    self.inLabel.frame = self.viewFrame.inLabelF;
    self.inValue.frame = self.viewFrame.inValueF;
    self.packLabel.frame = self.viewFrame.packLabelF;
    self.packValue.frame = self.viewFrame.packValueF;
    

    
}



@end
