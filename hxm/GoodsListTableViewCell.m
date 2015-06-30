//
//  GoodsListTableViewCell.m
//  hxm
//
//  Created by Bruce He on 15-5-30.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "GoodsListTableViewCell.h"
#import "GoodsListTableViewFrame.h"
#import "BWCommon.h"

#define NJPriceFont [UIFont systemFontOfSize:18]
#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]

@interface GoodsListTableViewCell ()


@end


@implementation GoodsListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void) layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10, 30, 90, 90 );
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *identifier = @"status";
    GoodsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[GoodsListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = NJNameFont;
        //orderNoLabel.numberOfLines = 0;
        // introLabel.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        //level
        UIColor *levelColor = [UIColor colorWithRed:82/255.0f green:204/255.0f blue:115/255.0f alpha:1];
        
        UIView *levelView = [[UIView alloc] init];
        [self.contentView addSubview:levelView];
        self.levelView = levelView;
        
        levelView.layer.cornerRadius = 3.0f;
        [levelView.layer setBorderColor:levelColor.CGColor];
        [levelView.layer setBorderWidth:1.0f];
        
        
        UILabel *levelTitle = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, 30, 20)];
        levelTitle.text = @"等级";
        levelTitle.font = NJTextFont;
        levelTitle.backgroundColor = levelColor;
        [levelTitle setTextColor:[UIColor whiteColor]];
        [levelTitle setTextAlignment:NSTextAlignmentCenter];
        
        [self.levelView addSubview:levelTitle];
        
        UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 0, 30, 20)];
        self.levelLabel = levelLabel;
        levelLabel.font = NJTextFont;
        [levelView addSubview:levelLabel];
        [levelLabel setTextColor:levelColor];
        [levelLabel setTextAlignment:NSTextAlignmentCenter];
        
        
        //limit
        UIColor *limitColor = [UIColor colorWithRed:176/255.0f green:176/255.0f blue:176/255.0f alpha:1];
        
        UIView *limitView = [[UIView alloc] init];
        [self.contentView addSubview:limitView];
        self.limitView = limitView;
        
        limitView.layer.cornerRadius = 3.0f;
        [limitView.layer setBorderColor:limitColor.CGColor];
        [limitView.layer setBorderWidth:1.0f];
        
        UILabel *limitTitle = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, 30, 20)];
        limitTitle.text = @"剩余";
        limitTitle.font = NJTextFont;
        limitTitle.backgroundColor = limitColor;
        [limitTitle setTextColor:[UIColor whiteColor]];
        [limitTitle setTextAlignment:NSTextAlignmentCenter];
        [self.limitView addSubview:limitTitle];
        
        UILabel *limitLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 0, 30, 20)];
        self.limitLabel = limitLabel;
        limitLabel.font = NJTextFont;
        [limitView addSubview:limitLabel];
        [limitLabel setTextColor:limitColor];
        [limitLabel setTextAlignment:NSTextAlignmentCenter];
        [self.limitView addSubview:limitLabel];
        
        
        //merchant
        UIView *merchantView = [[UIView alloc] init];
        [self.contentView addSubview:merchantView];
        self.merchantView = merchantView;
        
        merchantView.layer.cornerRadius = 3.0f;
        [merchantView.layer setBorderColor:limitColor.CGColor];
        [merchantView.layer setBorderWidth:1.0f];
        
        UILabel *merchantTitle = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, 30, 20)];
        merchantTitle.text = @"商家";
        merchantTitle.font = NJTextFont;
        merchantTitle.backgroundColor = limitColor;
        [merchantTitle setTextColor:[UIColor whiteColor]];
        [merchantTitle setTextAlignment:NSTextAlignmentCenter];
        [self.merchantView addSubview:merchantTitle];
        
        
        UILabel *merchantLabel = [[UILabel alloc] initWithFrame:CGRectMake(31, 0, 40, 20)];
        self.merchantLabel = merchantLabel;
        merchantLabel.font = NJTextFont;
        [merchantView addSubview:merchantLabel];
        [merchantLabel setTextColor:limitColor];
        [merchantLabel setTextAlignment:NSTextAlignmentCenter];
        
        UILabel *priceLabel = [[UILabel alloc] init];
        self.priceLabel = priceLabel;
        [self.contentView addSubview:priceLabel];
        priceLabel.font = NJPriceFont;
        [priceLabel setTextColor:[UIColor colorWithRed:219/255.0f green:0/255.0f blue:0/255.0f alpha:1]];
        
        UIView *tipsView = [[UIView alloc] init];
        
        self.tipsView = tipsView;
        [self.contentView addSubview:tipsView];
        
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 135, 20)];
        self.tipsLabel = tipsLabel;
        tipsLabel.font = [UIFont systemFontOfSize:12];
        [tipsLabel setTextColor:[UIColor colorWithRed:160/255.0f green:160/255.0f blue:160/255.0f alpha:1]];
        [self.tipsView addSubview:tipsLabel];
        
        UILabel *tips2Label = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 50, 20)];
        self.tips2Label = tips2Label;
        tips2Label.font = [UIFont systemFontOfSize:12];
        [tips2Label setTextColor:[UIColor colorWithRed:160/255.0f green:160/255.0f blue:160/255.0f alpha:1]];
        //[self.tipsView addSubview:tips2Label];
        
        UILabel *tipsValue = [[UILabel alloc] initWithFrame:CGRectMake(132, 0, 40, 20)];
        self.tipsValue = tipsValue;
        tipsValue.font = [UIFont systemFontOfSize:14];
        [tipsValue setTextAlignment:NSTextAlignmentLeft];
        [tipsValue setTextColor:[BWCommon getMainColor]];
        [self.tipsView addSubview:tipsValue];

        
        UIButton *cartButton = [[UIButton alloc] init];
        self.cartButton = cartButton;
        [cartButton setBackgroundImage:[UIImage imageNamed:@"goods-cart.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:cartButton];
        
        
        UIButton *buyButton = [[UIButton alloc] init];
        self.buyButton = buyButton;
        [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];

        buyButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:10];
        buyButton.titleLabel.numberOfLines = 0;
        
        [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buyButton setBackgroundColor:[UIColor colorWithRed:219/255.0f green:0/255.0f blue:0/255.0f alpha:1]];
        [self.contentView addSubview:buyButton];
        
        
        UIButton *auctionButton = [[UIButton alloc] init];
        self.auctionButton = auctionButton;
        [auctionButton setTitle:@"委托拍卖" forState:UIControlStateNormal];
        
        auctionButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:10];
        auctionButton.titleLabel.numberOfLines = 0;
        
        [auctionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [auctionButton setBackgroundColor:[UIColor colorWithRed:116/255.0f green:197/255.0f blue:67/255.0f alpha:1]];

        [self.contentView addSubview:auctionButton];


        
        
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

- (void)setViewFrame:(GoodsListTableViewFrame *)viewFrame
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
    
    NSString *image_url = [data objectForKey:@"photo_cd1"];
    
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:[UIImage imageNamed:@"icon.png"] options:SDWebImageCacheMemoryOnly];
    
    CGSize itemSize = CGSizeMake(90, 90);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, 120);
    [self.imageView.image drawInRect:imageRect];
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.nameLabel.text = [data objectForKey:@"flw"];
    self.levelLabel.text = [data objectForKey:@"flwlevel"];
    self.merchantLabel.text = [data objectForKey:@"seller_name"];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", [data objectForKey:@"sale_prc"]];
    self.limitLabel.text = [data objectForKey:@"ent_num"];
    self.tipsLabel.text = @"同品种同等级产品剩余：";
    self.tipsValue.text = [data objectForKey:@"sameLeft"];
    self.tips2Label.text = @"枝";

    
}
/**
 *  设置子控件的frame
 */
- (void)settingFrame
{
    
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.borderWidth=1.0;
    
    self.borderView.frame = self.viewFrame.borderViewF;
    self.nameLabel.frame = self.viewFrame.nameF;
    
    self.levelView.frame = self.viewFrame.levelF;
    
    self.limitView.frame = self.viewFrame.limitF;
    self.merchantView.frame = self.viewFrame.merchantF;
    self.priceLabel.frame = self.viewFrame.priceF;
    
    self.buyButton.frame = self.viewFrame.buyButtonF;
    self.auctionButton.frame = self.viewFrame.auctionButtonF;
    
    self.tipsView.frame = self.viewFrame.tipsF;
    
    self.cartButton.frame = self.viewFrame.cartButtonF;
    
    //[BWCommon setTopBorder:self.borderView color:[BWCommon getBackgroundColor]];
    [BWCommon setBottomBorder:self.borderView color:[BWCommon getBorderColor]];
    
}


@end
