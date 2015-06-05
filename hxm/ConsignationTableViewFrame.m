//
//  ConsignationTableViewFrame.m
//  hxm
//
//  Created by Bruce on 15-6-2.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//


#import "ConsignationTableViewFrame.h"

#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]

@implementation ConsignationTableViewFrame



- (void)setData:(NSDictionary *) data{
    _data = data;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    CGFloat padding = 10;
    
    NSUInteger priceLabelY = padding + 15;
    NSUInteger priceLabelH = 20;
    NSUInteger priceLabelW = 90;
    self.priceLabelF = CGRectMake(padding*2 + 90, priceLabelY, priceLabelW, priceLabelH);
    
    NSUInteger priceValueH = 20;
    NSUInteger pricevalueW = 80;
    self.priceValueF = CGRectMake(padding*2 + priceLabelW + 90, priceLabelY, pricevalueW, priceValueH);
    
    self.statusLabelF = CGRectMake(padding *3 + 90 + priceLabelW + pricevalueW, priceLabelY, 60, 20);
    
    
    NSUInteger inLabelY = priceLabelY + priceLabelH + padding;
    NSUInteger inlabelH = 20;
    
    self.inLabelF = CGRectMake(padding * 2 + 90, inLabelY, 90, 20);
    self.inValueF = CGRectMake(padding * 2 + 90 + 90, inLabelY, 90, 20);
    
    NSUInteger inRowY = priceLabelY + priceLabelH + padding;
    NSUInteger inRowH = 20;
    
    self.inRowF = CGRectMake(padding * 2 + 90, inRowY, 160, inRowH);
    
    
    NSUInteger packLabelY = inLabelY + padding +inlabelH;
    
    self.packLabelF = CGRectMake(padding * 2 + 90, packLabelY, 90, 20);
    self.packValueF = CGRectMake(padding * 2 + 90 + 90, packLabelY, 90, 20);
    
    NSUInteger packRowY = inRowY + padding + inRowH;
    self.packRowF = CGRectMake(padding * 2 + 90, packRowY, 160, inRowH);
    
    
    self.borderViewF = CGRectMake(0, 1, size.width, 15);
    
    self.cellHeight = 120;

}


@end