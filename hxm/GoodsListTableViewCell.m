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

#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]

@interface GoodsListTableViewCell ()

@property (nonatomic,weak) UIView *borderView;

@property (nonatomic, weak) UIButton *buyButton;
// 名称
@property (nonatomic, weak) UILabel *nameLabel;
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
    self.imageView.frame = CGRectMake(15, 30, 90, 90 );
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
        
        [view.layer setBorderColor:[UIColor colorWithRed:168/255.0f green:168/255.0f blue:168/255.0f alpha:1].CGColor ];
        [view.layer setBorderWidth:1.0f];
        
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
        
        UIButton *buyButton = [[UIButton alloc] init];
        self.buyButton = buyButton;
        [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [buyButton.layer setCornerRadius:4.0];
        [buyButton.layer setBorderColor:[UIColor colorWithRed:95/255.0f green:100/255.0f blue:110/255.0f alpha:1].CGColor];
        [buyButton.layer setBorderWidth:1.0f];
        [buyButton setTitleColor:[UIColor colorWithRed:95/255.0f green:100/255.0f blue:110/255.0f alpha:1] forState:UIControlStateNormal];
        buyButton.titleLabel.font = NJNameFont;
        
        [self.contentView addSubview:buyButton];

        
        
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
    
}


@end
