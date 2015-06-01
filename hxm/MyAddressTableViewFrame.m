//
//  MyAddressTableViewFrame.m
//  hxm
//
//  Created by spring on 15/5/30.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "MyAddressTableViewCell.h"

#define NJNameFont [UIFont systemFontOfSize:14]
#define NJTextFont [UIFont systemFontOfSize:12]


@implementation MyAddressTableViewFrame


- (void)setData:(NSDictionary *) data{
    _data = data;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    CGFloat paddingY = 10;
    CGFloat paddingX = 10;
    
    self.borderViewF = CGRectMake(0, 1, size.width, 15);
    
    self.statusViewF = CGRectMake(0, 16, size.width, 40);
    self.timeIconF = CGRectMake(paddingX, paddingY+2, 15, 15);
    self.timeLabelF = CGRectMake(paddingX+20, paddingY, 100, 20);
    self.delButtonF = CGRectMake(size.width-70, paddingY, 20, 20);
    self.editButtonF = CGRectMake(size.width-40, paddingY, 20, 20);
    
    //CGFloat orderNoX = paddingX*3;
    //CGFloat orderNoY = paddingY + 50;
    //CGSize orderNoSize = [self sizeWithString:[NSString stringWithFormat:@"订单编号：%@",[data objectForKey:@"order_no"]] font:NJNameFont maxSize:CGSizeMake(240, MAXFLOAT)];
   // CGFloat orderNoW = orderNoSize.width;
   // CGFloat orderNoH = 40;
    //self.orderNoF = CGRectMake(orderNoX, orderNoY, 300, orderNoH);
    self.addressButtonF = CGRectMake(30, 60, size.width-90, 120);
    self.nameLabelF = CGRectMake(0, 0, 200, 30);
    self.detailLabelF = CGRectMake(0, 20, size.width-60, 80);
    self.rigthImageIconF = CGRectMake(size.width-60, 50, 10, 13);
    
    self.cellHeight =  90+paddingY*2 + 70;
    
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

