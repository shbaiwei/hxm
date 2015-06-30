//
//  MyAddressTableViewCell.m
//  hxm
//
//  Created by spring on 15/5/30.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//
#import "MyAddressTableViewCell.h"
#import "MyAddressTableViewFrame.h"
#import "BWCommon.h"
#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]

@interface MyAddressTableViewCell()
@property (nonatomic,weak) UIView *borderView;

@property (nonatomic,weak) UIView *statusView;
@property (nonatomic,weak) UIImageView *timeIcon;
@property (nonatomic,weak) UILabel *timeLabel;

// 名称
@property (nonatomic, weak) UIButton *addressButton;
@property (nonatomic,weak) UILabel *nameLabel;
@property (nonatomic,weak) UILabel *detailLabel;
//@property (nonatomic,weak) UIImageView *rigthImageIcon;

@end

@implementation MyAddressTableViewCell

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
    MyAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[MyAddressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
        

        [self.contentView addSubview:view];
        self.borderView = view;
        
        /*时间，状态栏*/
        UIView *statusView = [[UIView alloc] init];
        statusView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0];
        [self.contentView addSubview:statusView];
        self.statusView = statusView;
        
        
        
        UIImageView *time_icon = [[UIImageView alloc] init];
        [time_icon setImage:[UIImage imageNamed:@"address-noselect-icon"]];
        [self.statusView addSubview:time_icon];
        self.timeIcon = time_icon;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = NJNameFont;
        timeLabel.numberOfLines = 0;
        timeLabel.text = @"设为默认地址";
        //timeLabel.textColor = [BWCommon getMainColor];
        [timeLabel setTextColor:[BWCommon getRGBColor:0x666666]];

        //[self.statusView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        UIButton *defaultButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 10, 100, 20)];
        [defaultButton setTitle:@"设为默认地址" forState:UIControlStateNormal];
        [defaultButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [defaultButton setTitleColor:[BWCommon getRGBColor:0x666666] forState:UIControlStateNormal];
        
        //defaultButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        defaultButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.defaultButton = defaultButton;
        [self.statusView addSubview:defaultButton];
        
        UIButton *delButton = [[UIButton alloc] init];
        [delButton setBackgroundImage:[UIImage imageNamed:@"address-delete-icon"] forState:UIControlStateNormal];
        [self.statusView addSubview:delButton];
        self.delButton = delButton;
        
        UIButton *editButton = [[UIButton alloc] init];
        [editButton setBackgroundImage:[UIImage imageNamed:@"user-edit"] forState:UIControlStateNormal];
        [self.statusView addSubview:editButton];
        self.editButton = editButton;
        

        
        UIButton *addressButton = [[UIButton alloc] init];
        [self.contentView addSubview:addressButton];
        self.addressButton = addressButton;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = @"test";
        nameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [addressButton addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel *detailLabel = [[UILabel alloc] init];
        //detailLabel.text = @"浙江－杭州－下城区 \n建国东路236号诚信大厦11楼 \n15221966658";
        
        detailLabel.font = NJNameFont;
        [detailLabel setTextColor:[BWCommon getRGBColor:0x666666]];
        detailLabel.numberOfLines = 0;
        
        
        
        [addressButton addSubview:detailLabel];
        self.detailLabel = detailLabel;
        
        
        
        UILabel *orderFeeTitleLabel = [[UILabel alloc] init];
        orderFeeTitleLabel.font = NJNameFont;
        //orderFeeTitleLabel.numberOfLines = 0;
        
        
        
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

- (void)setViewFrame:(MyAddressTableViewFrame *)viewFrame
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
    
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",[data objectForKey:@"receiver_name"]];
    
    NSMutableArray *areaArray = [[NSMutableArray alloc] init];
    
    areaArray[0] = [BWCommon getRegionById:[[data objectForKey:@"prov_id"]integerValue]];
    areaArray[1] = [BWCommon getRegionById:[[data objectForKey:@"city_id"]integerValue]];
    
    if([[data objectForKey:@"dist_id"] integerValue] > 0)
    {
        areaArray[2] = [BWCommon getRegionById:[[data objectForKey:@"dist_id"]integerValue]];
    }
    
    NSString *detail = [NSString stringWithFormat:@"%@\n%@\n%@",[areaArray componentsJoinedByString:@" - " ],[data objectForKey:@"address"],[data objectForKey:@"mobile"]];
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:detail];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:20];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [detail length])];
    [self.detailLabel setAttributedText:attributedString1];
    self.detailLabel.text = detail;
    [self.detailLabel sizeToFit];
    
    if([[data objectForKey:@"is_default"]integerValue] > 0 ){
        
        [self.defaultButton setTitle:@"默认地址" forState:UIControlStateNormal];
        [self.defaultButton setTitleColor:[BWCommon getMainColor] forState:UIControlStateNormal];

    }
    
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
    self.delButton.frame = self.viewFrame.delButtonF;
    self.editButton.frame = self.viewFrame.editButtonF;
    self.addressButton.frame = self.viewFrame.addressButtonF;
    self.nameLabel.frame = self.viewFrame.nameLabelF;
    self.detailLabel.frame = self.viewFrame.detailLabelF;
    //self.rigthImageIcon.frame = self.viewFrame.rigthImageIconF;
    
    // 设置正文的frame
    //self.contentLabel.frame = self.viewFrame.contentF;
    
}

@end



