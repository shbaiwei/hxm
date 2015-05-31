//
//  MyAfterSaleTableViewCell.m
//  hxm
//
//  Created by spring on 15/5/30.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "MyAfterSaleTableViewCell.h"
#import "MyAfterSaleTableViewFrame.h"
#import "BWCommon.h"

#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]

@interface MyAfterSaleTableViewCell() 
@property (nonatomic,weak) UIView *borderView;

@property (nonatomic,weak) UIView *statusView;
@property (nonatomic,weak) UIImageView *timeIcon;
@property (nonatomic,weak) UILabel *timeLabel;
@property (nonatomic,weak) UILabel *statusLabel;

// 名称
@property (nonatomic, weak) UILabel *orderNoLabel;


@property (nonatomic,weak) UIView *buttonView;

@property (nonatomic, weak) UIButton *cancelButton;
@property (nonatomic, weak) UIButton *detailButton;
@property (nonatomic,weak) UIButton *logisticsButton;
@end

@implementation MyAfterSaleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void) layoutSubviews{
    [super layoutSubviews];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *identifier = @"status";
    MyAfterSaleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[MyAfterSaleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        /*时间，状态栏*/
        UIView *statusView = [[UIView alloc] init];
        statusView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0];
        [self.contentView addSubview:statusView];
        self.statusView = statusView;
        
        UIImageView *time_icon = [[UIImageView alloc] init];
        [time_icon setImage:[UIImage imageNamed:@"complain-time-icon"]];
        [self.statusView addSubview:time_icon];
        self.timeIcon = time_icon;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = NJNameFont;
        timeLabel.numberOfLines = 0;
        timeLabel.text = @"2015-15-01";
        [self.statusView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        UILabel *statusLabel = [[UILabel alloc] init];
        [statusLabel.layer setMasksToBounds:YES];
        [statusLabel.layer setCornerRadius:3.0f];
        statusLabel.backgroundColor = [UIColor colorWithRed:255/255.0f green:192/255.0f blue:0/255.0f alpha:1.0f];
        statusLabel.text = @"审核中";
        statusLabel.textColor = [UIColor whiteColor];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.font = [UIFont boldSystemFontOfSize:14];;
        [self.statusView addSubview:statusLabel];
        self.statusLabel = statusLabel;
        /*时间，状态栏结束*/
        
        UILabel *orderNoLabel = [[UILabel alloc] init];
        orderNoLabel.font = NJNameFont;
        orderNoLabel.numberOfLines = 0;
      //  orderNoLabel.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:orderNoLabel];
        self.orderNoLabel = orderNoLabel;
        
        UILabel *orderFeeTitleLabel = [[UILabel alloc] init];
        orderFeeTitleLabel.font = NJNameFont;
        //orderFeeTitleLabel.numberOfLines = 0;
        

        UIView *buttonView = [[UIView alloc] init];
        [buttonView.layer setBorderColor:[UIColor colorWithRed:168/255.0f green:168/255.0f blue:168/255.0f alpha:1].CGColor ];
        [buttonView.layer setBorderWidth:1.0f];
        self.buttonView = buttonView;
        [self.contentView addSubview:buttonView];
        
        
        UIButton *cancelButton = [[UIButton alloc] init];
        self.cancelButton = cancelButton;
        [cancelButton setTitle:@"撤销投诉" forState:UIControlStateNormal];
        [cancelButton.layer setCornerRadius:4.0];
        [cancelButton.layer setBorderColor:[UIColor colorWithRed:95/255.0f green:100/255.0f blue:110/255.0f alpha:1].CGColor];
        [cancelButton.layer setBorderWidth:1.0f];
        [cancelButton setTitleColor:[UIColor colorWithRed:95/255.0f green:100/255.0f blue:110/255.0f alpha:1] forState:UIControlStateNormal];
        cancelButton.titleLabel.font = NJNameFont;
        cancelButton.tag =11;
        [cancelButton addTarget:self action:@selector(do_action:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cancelButton];
        
        
        UIButton *detailButton = [[UIButton alloc] init];
        self.detailButton = detailButton;
        [detailButton setTitle:@"查看详情" forState:UIControlStateNormal];
        [detailButton.layer setCornerRadius:4.0];
        [detailButton.layer setBorderColor:[UIColor colorWithRed:95/255.0f green:100/255.0f blue:110/255.0f alpha:1].CGColor];
        [detailButton.layer setBorderWidth:1.0f];
        [detailButton setTitleColor:[UIColor colorWithRed:95/255.0f green:100/255.0f blue:110/255.0f alpha:1] forState:UIControlStateNormal];
        detailButton.titleLabel.font = NJNameFont;
        detailButton.tag = 12;
        [detailButton addTarget:self action:@selector(do_action:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:detailButton];
        
        UIButton *logisticsButton = [[UIButton alloc] init];
        self.logisticsButton = logisticsButton;
        [logisticsButton setTitle:@"查看物流" forState:UIControlStateNormal];
        [logisticsButton.layer setCornerRadius:4.0];
        [logisticsButton.layer setBorderColor:[UIColor colorWithRed:95/255.0f green:100/255.0f blue:110/255.0f alpha:1].CGColor];
        [logisticsButton.layer setBorderWidth:1.0f];
        [logisticsButton setTitleColor:[UIColor colorWithRed:95/255.0f green:100/255.0f blue:110/255.0f alpha:1] forState:UIControlStateNormal];
        logisticsButton.titleLabel.font = NJNameFont;
        logisticsButton.tag = 13;
        [logisticsButton addTarget:self action:@selector(do_action:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:logisticsButton];
        
        
    }
    return self;
}

- (void)do_action:(UIButton *) sender
{
    switch (sender.tag) {
        case 11:
            NSLog(@"撤销投诉");
            break;
        case 12:
            NSLog(@"查看详情");
            break;
        case 13:
            NSLog(@"查看物流");
            break;
        default:
            break;
    }
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

- (void)setViewFrame:(MyAfterSaleTableViewFrame *)viewFrame
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
    
    
    self.orderNoLabel.text = [NSString stringWithFormat:@"投诉内容：%@",[data objectForKey:@"order_no"]];
    
    
    
}
/**
 *  设置子控件的frame
 */
- (void)settingFrame
{
    
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.borderWidth=1.0;
    
    self.borderView.frame = self.viewFrame.borderViewF;
    
    self.statusView.frame = self.viewFrame.statusViewF;
    self.timeIcon.frame = self.viewFrame.timeIconF;
    self.timeLabel.frame = self.viewFrame.timeLabelF;
    self.statusLabel.frame = self.viewFrame.statusLabelF;
    
    self.orderNoLabel.frame = self.viewFrame.orderNoF;
    
    self.buttonView.frame = self.viewFrame.buttonViewF;
    
    self.cancelButton.frame = self.viewFrame.cancelF;
    self.detailButton.frame = self.viewFrame.detailF;
    self.logisticsButton.frame = self.viewFrame.logisticsF;
    // 设置正文的frame
    //self.contentLabel.frame = self.viewFrame.contentF;
    
}

@end



