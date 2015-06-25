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
    
    CGFloat padding = 10;
    
    NSUInteger priceLabelY = padding + 15;
    NSUInteger priceLabelH = 20;
    NSUInteger priceLabelW = 50;
    self.priceLabelF = CGRectMake(padding*2 + 90, priceLabelY, priceLabelW, priceLabelH);
    
    NSUInteger priceValueH = 20;
    NSUInteger pricevalueW = 80;
    self.priceValueF = CGRectMake(padding*2 + priceLabelW + 90, priceLabelY, pricevalueW, priceValueH);
    
    self.statusLabelF = CGRectMake(size.width - 70, priceLabelY, 60, 20);
    
    
    NSUInteger inRowY = priceLabelY + priceLabelH + padding;
    NSUInteger inRowH = 22;
    
    self.inRowF = CGRectMake(padding * 2 + 90, inRowY, 130, inRowH);
    
    
    NSUInteger packRowY = inRowY + padding + inRowH;
    
    self.packRowF = CGRectMake(padding * 2 + 90, packRowY, 130, inRowH);
    
    
    self.borderViewF = CGRectMake(0, 1, size.width, 15);
    
    self.cellHeight = 120;
    
}


@end