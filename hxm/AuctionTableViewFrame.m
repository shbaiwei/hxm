//
//  ConsignationTableViewFrame.m
//  hxm
//
//  Created by Bruce on 15-6-2.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//


#import "AuctionTableViewFrame.h"

#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]

@implementation AuctionTableViewFrame



- (void)setData:(NSDictionary *) data{
    _data = data;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    CGFloat padding = 5;
    
    NSUInteger aucNoLabelY = padding + 15;
    NSUInteger aucNoLabelH = 20;
    NSUInteger aucNoLabelW = 80;
    self.aucNoLabelF = CGRectMake(padding*2 + 100, aucNoLabelY, aucNoLabelW, aucNoLabelH);
    
    NSUInteger aucNoValueH = 20;
    NSUInteger aucNovalueW = 80;
    self.aucNoValueF = CGRectMake(padding*2 + aucNoLabelW + 100,aucNoLabelY, aucNovalueW, aucNoValueH);
    
    //self.statusLabelF = CGRectMake(size.width - 70, priceLabelY, 60, 20);
    
    
    NSUInteger channelRowY = aucNoLabelY + aucNoLabelH + padding;
    NSUInteger channelRowH = 22;
    
    self.channelRowF = CGRectMake(padding * 2 + 100, channelRowY, 130, channelRowH);
    
    
    NSUInteger catRowY = channelRowY + padding + channelRowH;
    
    self.catRowF = CGRectMake(padding * 2 + 100, catRowY, 130, channelRowH);
    
    NSUInteger cat2RowY = channelRowY + padding + channelRowH*2 + padding;
    
    self.cat2RowF = CGRectMake(padding * 2 + 100, cat2RowY, 130, channelRowH);
    
    
    self.borderViewF = CGRectMake(0, 1, size.width, 15);
    
    self.cellHeight = 130;
    
}


@end