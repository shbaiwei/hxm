//
//  ConsignationTableViewCell.m
//  hxm
//
//  Created by Bruce on 15-6-2.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "AuctionTableViewCell.h"
#import "AuctionTableViewFrame.h"
#import "BWCommon.h"


#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]
#define NJStatusFont [UIFont systemFontOfSize:10]

@implementation AuctionTableViewCell

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
    AuctionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[AuctionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        UILabel *aucNoLabel = [[UILabel alloc] init];
        self.aucNoLabel = aucNoLabel;
        aucNoLabel.text = @"拍卖顺序：";
        [aucNoLabel setTextColor:[BWCommon getRedColor]];
        [self.contentView addSubview:aucNoLabel];
        aucNoLabel.font = NJNameFont;
        
        UILabel *aucNoValue = [[UILabel alloc] init];
        self.aucNoValue = aucNoValue;
        [self.contentView addSubview:aucNoValue];
        [aucNoValue setTextColor:[BWCommon getRedColor]];
        
        UILabel *statusLabel = [[UILabel alloc] init];
        self.statusLabel = statusLabel;
        statusLabel.font = NJStatusFont;
        statusLabel.textAlignment = NSTextAlignmentCenter;
        [statusLabel setTextColor:[UIColor whiteColor]];
        
        [statusLabel setBackgroundColor:[BWCommon getMainColor]];
        
        [self.contentView addSubview:statusLabel];
        
        UIView *channelRowView = [[UIView alloc] init];
        [self.contentView addSubview:channelRowView];
        self.channelRowView = channelRowView;
        
        UILabel *channelLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1, 62, 20)];
        self.channelLabel = channelLabel;
        
        channelLabel.text = @"拍卖频道";
        [channelRowView addSubview:channelLabel];
        [channelRowView setBackgroundColor:[UIColor lightGrayColor]];
        
        channelLabel.font = NJTextFont;
        [channelLabel setTextColor:[UIColor whiteColor]];
        //[inLabel setBackgroundColor:[UIColor whi]];
        
        UILabel *channelValue = [[UILabel alloc] initWithFrame:CGRectMake(67, 1, 62, 20)];
        self.channelValue = channelValue;
        [channelRowView addSubview:channelValue];
        [channelValue setBackgroundColor:[UIColor whiteColor]];
        channelValue.textAlignment = NSTextAlignmentCenter;
        channelValue.font = NJTextFont;
        
        UIView *catRowView = [[UIView alloc] init];
        [self.contentView addSubview:catRowView];
        self.catRowView = catRowView;
        
        [catRowView setBackgroundColor:[UIColor lightGrayColor]];
        
        UILabel *catLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1, 62, 20)];
        self.catLabel = catLabel;
        catLabel.text = @"品 类";
        [catRowView addSubview:catLabel];
        
        catLabel.font = NJTextFont;
        [catLabel setTextColor:[UIColor whiteColor]];
        //[packLabel setBackgroundColor:[UIColor lightGrayColor]];
        
        UILabel *catValue = [[UILabel alloc] initWithFrame:CGRectMake(67, 1, 62, 20)];
        self.catValue = catValue;
        [catRowView addSubview:catValue];
        catValue.font = NJTextFont;
        [catValue setBackgroundColor:[UIColor whiteColor]];
        catValue.textAlignment = NSTextAlignmentCenter;
        
        
        
        UIView *cat2RowView = [[UIView alloc] init];
        [self.contentView addSubview:cat2RowView];
        self.cat2RowView = cat2RowView;
        
        [cat2RowView setBackgroundColor:[UIColor lightGrayColor]];
        
        UILabel *cat2Label = [[UILabel alloc] initWithFrame:CGRectMake(5, 1, 62, 20)];
        self.cat2Label = cat2Label;
        cat2Label.text = @"品 种";
        [cat2RowView addSubview:cat2Label];
        
        cat2Label.font = NJTextFont;
        [cat2Label setTextColor:[UIColor whiteColor]];
        //[packLabel setBackgroundColor:[UIColor lightGrayColor]];
        
        UILabel *cat2Value = [[UILabel alloc] initWithFrame:CGRectMake(67, 1, 62, 20)];
        self.cat2Value = cat2Value;
        [cat2RowView addSubview:cat2Value];
        cat2Value.font = NJTextFont;
        [cat2Value setBackgroundColor:[UIColor whiteColor]];
        cat2Value.textAlignment = NSTextAlignmentCenter;

        
        
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

- (void)setViewFrame:(AuctionTableViewFrame *)viewFrame
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
    
    self.aucNoValue.text = [self getString:[data objectForKey:@"auc_no"]];
    self.channelValue.text = [self getString:[data objectForKey:@"channel"]];
    self.catValue.text = [self getString:[data objectForKey:@"fcname"]];
    self.cat2Value.text = [self getString:[data objectForKey:@"name"]];
    
    
}

- (NSString *) getString:(id) str{
    
    if(str == [NSNull null]){
        return @"";
    }
    else{
        return str;
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
    
    self.aucNoLabel.frame = self.viewFrame.aucNoLabelF;
    self.aucNoValue.frame = self.viewFrame.aucNoValueF;
    self.channelRowView.frame = self.viewFrame.channelRowF;
    //self.statusLabel.frame = self.viewFrame.statusLabelF;
    //self.inLabel.frame = self.viewFrame.inLabelF;
    //self.inValue.frame = self.viewFrame.inValueF;
    //self.packLabel.frame = self.viewFrame.packLabelF;
    //self.packValue.frame = self.viewFrame.packValueF;
    
    self.catRowView.frame = self.viewFrame.catRowF;
    self.cat2RowView.frame = self.viewFrame.cat2RowF;
    
}



@end
