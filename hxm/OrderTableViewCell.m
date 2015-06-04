//
//  MixTableViewCell.m
//  pinpintong
//
//  Created by Bruce He on 15-4-4.
//  Copyright (c) 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "OrderTableViewFrame.h"
#import "BWCommon.h"

#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]

@interface OrderTableViewCell ()

@property (nonatomic,weak) UIView *borderView;
// 名称
@property (nonatomic, weak) UILabel *orderNoLabel;
/**
 *  地址
 */
@property (nonatomic, weak) UILabel *orderFeeLabel;
@property (nonatomic, weak) UILabel *orderFeeTitleLabel;

@property (nonatomic,weak) UIView *buttonView;


@property (nonatomic,weak) UILabel *timeLabel;

@end


@implementation OrderTableViewCell

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
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *identifier = @"status";
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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

        
        UILabel *orderNoLabel = [[UILabel alloc] init];
        orderNoLabel.font = NJNameFont;
        orderNoLabel.numberOfLines = 0;
        // introLabel.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:orderNoLabel];
        self.orderNoLabel = orderNoLabel;
        
        UILabel *orderFeeTitleLabel = [[UILabel alloc] init];
        orderFeeTitleLabel.font = NJNameFont;
        //orderFeeTitleLabel.numberOfLines = 0;
        
        [self.contentView addSubview:orderFeeTitleLabel];
        self.orderFeeTitleLabel = orderFeeTitleLabel;
        
        UILabel *orderFeeLabel = [[UILabel alloc] init];
        orderFeeLabel.font = NJNameFont;
        orderFeeLabel.numberOfLines = 0;
        orderFeeLabel.textColor = [UIColor colorWithRed:219/255.0f green:0/255.0f blue:0/255.0f alpha:1];
        
        [self.contentView addSubview:orderFeeLabel];
        self.orderFeeLabel = orderFeeLabel;
        
        UIView *buttonView = [[UIView alloc] init];
        [buttonView.layer setBorderColor:[UIColor colorWithRed:168/255.0f green:168/255.0f blue:168/255.0f alpha:1].CGColor ];
        [buttonView.layer setBorderWidth:1.0f];
        self.buttonView = buttonView;
        [self.contentView addSubview:buttonView];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = NJNameFont;
        timeLabel.numberOfLines = 0;
        timeLabel.textColor = [UIColor colorWithRed:116/255.0f green:197/255.0f blue:67/255.0f alpha:1];
        self.timeLabel = timeLabel;
        
        [self.contentView addSubview:timeLabel];
        
        
        UIButton *commentButton = [[UIButton alloc] init];
        self.commentButton = commentButton;
        [commentButton setTitle:@"评价订单" forState:UIControlStateNormal];
        [commentButton.layer setCornerRadius:4.0];
        [commentButton.layer setBorderColor:[UIColor colorWithRed:95/255.0f green:100/255.0f blue:110/255.0f alpha:1].CGColor];
        [commentButton.layer setBorderWidth:1.0f];
        [commentButton setTitleColor:[UIColor colorWithRed:95/255.0f green:100/255.0f blue:110/255.0f alpha:1] forState:UIControlStateNormal];
        commentButton.titleLabel.font = NJNameFont;
        
        [self.contentView addSubview:commentButton];

        
        UIButton *noteButton = [[UIButton alloc] init];
        self.noteButton = noteButton;
        [noteButton setTitle:@"备注订单" forState:UIControlStateNormal];
        [noteButton.layer setCornerRadius:4.0];
        [noteButton.layer setBorderColor:[UIColor colorWithRed:95/255.0f green:100/255.0f blue:110/255.0f alpha:1].CGColor];
        [noteButton.layer setBorderWidth:1.0f];
        [noteButton setTitleColor:[UIColor colorWithRed:95/255.0f green:100/255.0f blue:110/255.0f alpha:1] forState:UIControlStateNormal];
        noteButton.titleLabel.font = NJNameFont;
        
        [self.contentView addSubview:noteButton];
        
        
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

- (void)setViewFrame:(OrderTableViewFrame *)viewFrame
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
    
    NSArray *photos = [data objectForKey:@"photo"];
    
    NSString *image_url = [photos objectAtIndex:0];
    
    
    [self.imageView setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image_url]]]];
    
    CGSize itemSize = CGSizeMake(90, 90);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, 120);
    [self.imageView.image drawInRect:imageRect];
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    self.orderNoLabel.text = [NSString stringWithFormat:@"订单编号：%@",[data objectForKey:@"order_no"]];
    
    self.orderFeeLabel.text = [NSString stringWithFormat:@"¥ %@",[data objectForKey:@"order_fee"]];
    
    self.orderFeeTitleLabel.text = @"订单金额：";
    
    self.timeLabel.text = [data objectForKey:@"create_time"];
    
    
}
/**
 *  设置子控件的frame
 */
- (void)settingFrame
{
    
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.borderWidth=1.0;
    
    self.borderView.frame = self.viewFrame.borderViewF;
    self.orderNoLabel.frame = self.viewFrame.orderNoF;
    self.orderFeeLabel.frame = self.viewFrame.orderFeeF;
    self.orderFeeTitleLabel.frame = self.viewFrame.orderFeeTitleF;
    
    self.buttonView.frame = self.viewFrame.buttonViewF;
    
    self.timeLabel.frame = self.viewFrame.timeF;
    
    self.commentButton.frame = self.viewFrame.commentF;
    self.noteButton.frame = self.viewFrame.noteF;
    // 设置正文的frame
    //self.contentLabel.frame = self.viewFrame.contentF;
    
}


@end
