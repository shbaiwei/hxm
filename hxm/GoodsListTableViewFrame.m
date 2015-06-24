//
//  GoodsListTableViewFrame.m
//  hxm
//
//  Created by Bruce He on 15-5-30.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "GoodsListTableViewFrame.h"

#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]

@implementation GoodsListTableViewFrame


- (void)setData:(NSDictionary *) data{
    _data = data;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    CGFloat padding = 10;
    
    //CGFloat imageX = padding;
    //CGFloat imageY = padding;
    //self.imageF = CGRectMake(imageX, imageY, 100, 60);
    
    CGFloat nameX = padding + 100;
    CGFloat nameY = padding + 16;
    CGFloat nameH = 20;
    self.nameF = CGRectMake(nameX, nameY, 200, nameH);
    
    
    CGFloat levelY = nameY + nameH + padding;
    self.levelF = CGRectMake(nameX, levelY, 60, 20);
    
    
    CGFloat limitX = nameX+60+padding/2;
    self.limitF = CGRectMake(limitX, levelY, 70, 20);
    
    
    
    CGFloat priceY = levelY + 20 + padding;
    if(size.width>320){
        self.merchantF = CGRectMake(limitX+70+padding/2, levelY, 70, 20);
    }
    else{
        priceY += 20;
        self.merchantF = CGRectMake(nameX, levelY + 20 + padding/2, 70, 20);
    }

    self.priceF = CGRectMake(nameX, priceY, 60, 20);
    
    self.buyButtonF = CGRectMake(size.width-50, 16, 50, 70);
    self.auctionButtonF = CGRectMake(size.width-50, 86, 50, 70);
    
    self.cartButtonF = CGRectMake(size.width-98, 114, 32, 32);
    
    self.cellHeight =  140+16;
    
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
