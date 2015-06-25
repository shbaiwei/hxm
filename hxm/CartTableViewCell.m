//
//  GoodsListTableViewCell.m
//  hxm
//
//  Created by Bruce He on 15-5-30.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "CartTableViewCell.h"
#import "CartTableViewFrame.h"
#import "BWCommon.h"

#define NJPriceFont [UIFont systemFontOfSize:16]
#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]

@interface CartTableViewCell ()


@end


@implementation CartTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void) layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10, 60, 90, 90 );
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *identifier = @"status";
    CartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[CartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 让自定义Cell和系统的cell一样, 一创建出来就拥有一些子控件提供给我们使用
        
        UIView *view = [[UIView alloc] init];
        
        view.backgroundColor = [BWCommon getBackgroundColor];
        
        //[view.layer setBorderColor:[BWCommon getBorderColor].CGColor];
        //[view.layer setBorderWidth:1.0f];
        
        //view.layer.shadowColor = [UIColor grayColor].CGColor;
        //view.layer.shadowOffset = CGSizeMake(1, 1);
        //view.layer.shadowOpacity = 0.2;
        //view.layer.shadowRadius = 1;
        
        [self.contentView addSubview:view];
        self.borderView = view;
        
        
        UIView *headerView = [[UIView alloc] init];
        self.headerView = headerView;
        
        UIImageView *sellerIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seller-icon.png"]];
        sellerIcon.frame = CGRectMake(4, 0, 18, 18);
        [self.headerView addSubview:sellerIcon];
        
        UILabel *sellerLabel = [[UILabel alloc] init];
        sellerLabel.font = NJNameFont;
        self.sellerLabel = sellerLabel;
        sellerLabel.frame = CGRectMake(26, 0, 100, 20);
        
        [self.headerView addSubview:sellerLabel];
        [self.contentView addSubview:headerView];
        
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = NJNameFont;
        //orderNoLabel.numberOfLines = 0;
        // introLabel.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;

    
        
        UILabel *priceLabel = [[UILabel alloc] init];
        self.priceLabel = priceLabel;
        [self.contentView addSubview:priceLabel];
        priceLabel.font = NJNameFont;
        
        UILabel *quantityLabel = [[UILabel alloc] init];
        self.quantityLabel = quantityLabel;
        [self.contentView addSubview:quantityLabel];
        quantityLabel.font = NJNameFont;
        
        
        UILabel *quantity2Label = [[UILabel alloc] init];
        self.quantity2Label = quantity2Label;
        [self.contentView addSubview:quantity2Label];
        quantity2Label.font = NJNameFont;
        
        UILabel *subtotalLabel = [[UILabel alloc] init];
        self.subtotalLabel = subtotalLabel;
        [self.contentView addSubview:subtotalLabel];
        subtotalLabel.font = NJNameFont;
        [subtotalLabel setTextColor:[UIColor colorWithRed:219/255.0f green:0/255.0f blue:0/255.0f alpha:1]];


        
        
        
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

- (void)setViewFrame:(CartTableViewFrame *)viewFrame
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
    
    NSString *image_url = [[data objectForKey:@"photo"] objectAtIndex:0];
    
    
    [self.imageView setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image_url]]]];
    
    CGSize itemSize = CGSizeMake(90, 90);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, 120);
    [self.imageView.image drawInRect:imageRect];
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.sellerLabel.text = [data objectForKey:@"seller_name"];
    
    self.nameLabel.text = [data objectForKey:@"goods_cd"];
    
    self.quantityLabel.text =[NSString stringWithFormat:@"%@支", [data objectForKey:@"ent_num"]];
    self.quantity2Label.text =[NSString stringWithFormat:@"X%@", [data objectForKey:@"quantity"]];
    
    float subtotal = [[data objectForKey:@"quantity"] integerValue] * [[data objectForKey:@"ent_num"] integerValue] * [[data objectForKey:@"sale_prc"] floatValue];
    self.subtotalLabel.text =[NSString stringWithFormat:@"小计：%0.2f", subtotal];

    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", [data objectForKey:@"sale_prc"]];
    
    
}
/**
 *  设置子控件的frame
 */
- (void)settingFrame
{
    
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.borderWidth=1.0;
    
    
    self.borderView.frame = self.viewFrame.borderViewF;
    
    self.headerView.frame = self.viewFrame.headerF;
    
    self.quantityLabel.frame = self.viewFrame.quantityF;
    self.quantity2Label.frame = self.viewFrame.quantity2F;
    self.subtotalLabel.frame = self.viewFrame.subtotalF;
    
    self.nameLabel.frame = self.viewFrame.nameF;
    
    self.priceLabel.frame = self.viewFrame.priceF;
    
    [BWCommon setTopBorder:self.borderView color:[BWCommon getBorderColor]];
    //[BWCommon setBottomBorder:self.contentView color:[BWCommon getBorderColor]];
    
    [BWCommon setBottomBorder:self.borderView color:[BWCommon getBorderColor]];
    
    [BWCommon setBottomBorder:self.headerView color:[BWCommon getBorderColor]];
    
}


@end
