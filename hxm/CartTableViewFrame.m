//
//  CartTableViewFrame.m
//  hxm
//
//  Created by Bruce He on 15/6/7.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//


#import "CartTableViewFrame.h"

#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]

@implementation CartTableViewFrame


- (void)setData:(NSDictionary *) data{
    _data = data;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    CGFloat padding = 10;
    
    //CGFloat imageX = padding;
    //CGFloat imageY = padding;
    //self.imageF = CGRectMake(imageX, imageY, 100, 60);
    
    
    CGFloat headerX = padding;
    CGFloat headerY = padding + 12;
    CGFloat headerH = 26;
    self.headerF = CGRectMake(headerX,headerY,size.width-padding*2,headerH);
    
    CGFloat nameX = padding + 100;
    CGFloat nameY = padding + headerH + headerY;
    CGFloat nameH = 20;
    self.nameF = CGRectMake(nameX, nameY, 200, nameH);
    
    CGSize priceSize = [self sizeWithString:[NSString stringWithFormat:@"¥%@",[data objectForKey:@"sale_prc"]] font:NJNameFont maxSize:CGSizeMake(100, MAXFLOAT)];
    CGFloat priceX = size.width - padding - priceSize.width;
    CGFloat priceY = nameY;
    CGFloat priceH = 20;
    self.priceF = CGRectMake(priceX, priceY, priceSize.width, priceH);
    
    CGFloat quantityX = nameX;
    CGFloat quantityY = nameY + nameH + padding;
    
    self.quantityF = CGRectMake(quantityX, quantityY, 80, 20);
    
    CGSize quantity2Size = [self sizeWithString:[NSString stringWithFormat:@"X%@",[data objectForKey:@"quantity"]] font:NJNameFont maxSize:CGSizeMake(100, MAXFLOAT)];
    CGFloat quantity2X = size.width - padding - quantity2Size.width;
    CGFloat quantity2Y = quantityY;
    self.quantity2F = CGRectMake(quantity2X, quantity2Y, quantity2Size.width, 20);
    
    float subtotal = [[data objectForKey:@"quantity"] integerValue] * [[data objectForKey:@"sale_prc"] floatValue];
    
    CGSize subtotalSize =[self sizeWithString:[NSString stringWithFormat:@"小计：%0.2f",subtotal] font:NJNameFont maxSize:CGSizeMake(160, MAXFLOAT)];
    CGFloat subtotalX = size.width-padding - subtotalSize.width;
    CGFloat subtotalY = quantity2Y + 20 + padding;
    self.subtotalF = CGRectMake(subtotalX, subtotalY, subtotalSize.width, 20);
    
    self.cellHeight =  144+16;
    
    self.borderViewF = CGRectMake(0, 1, size.width, 15);
    
    
    
    //self.cellHeight =CGRectGetMaxY(self.contentF) +padding;
    
    
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

@end
