//
//  NearbyTableViewFrame.m
//  easyshanghai
//
//  Created by Bruce He on 15-5-21.
//  Copyright (c) 2015年 shanghai baiwei network technology. All rights reserved.
//


#import "OrderTableViewFrame.h"

#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]


@implementation OrderTableViewFrame


- (void)setData:(NSDictionary *) data{
    _data = data;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    CGFloat paddingY = 10;
    CGFloat paddingX = 10;
    
    //CGFloat imageX = padding;
    //CGFloat imageY = padding;
    //self.imageF = CGRectMake(imageX, imageY, 100, 60);
    
    CGFloat orderNoX = 90+paddingX*2;
    CGFloat orderNoY = paddingY + 16;
    CGSize orderNoSize = [self sizeWithString:[NSString stringWithFormat:@"订单编号：%@",[data objectForKey:@"order_no"]] font:NJNameFont maxSize:CGSizeMake(220, MAXFLOAT)];
    CGFloat orderNoW = orderNoSize.width;
    CGFloat orderNoH = orderNoSize.height;
    self.orderNoF = CGRectMake(orderNoX, orderNoY, orderNoW, orderNoH);
    
    CGFloat orderFeeX = 90+paddingX*2;
    CGFloat orderFeeY = orderNoY + orderNoH + paddingY;
    self.orderFeeTitleF = CGRectMake(orderFeeX, orderFeeY, 70, 16);
    self.orderFeeF = CGRectMake(orderFeeX+70, orderFeeY, 70, 16);
    
    self.buttonViewF = CGRectMake(0, 90+paddingY*2 + 20, size.width , 50);
    
    self.timeF = CGRectMake(paddingX*2, 90+paddingY*2 + 35, 100, 20);
    
    self.commentF = CGRectMake(size.width-80*2-paddingX*3, 90+paddingY*2 + 30, 80, 30);
    self.noteF = CGRectMake(size.width-80-paddingX*2, 90+paddingY*2 + 30, 80, 30);
    
    
    self.cellHeight =  90+paddingY*2 + 70;
    
    
    
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
