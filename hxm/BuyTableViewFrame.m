//
//  FinanceTableViewFrame.m
//  hxm
//
//  Created by Bruce on 15-6-1.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "BuyTableViewFrame.h"

#define NJNameFont [UIFont systemFontOfSize:14]


@implementation BuyTableViewFrame

- (void)setData:(NSDictionary *) data{
    
    _data = data;
    
    
    
    if([[data objectForKey:@"title"] isEqualToString:@""])
    {
        CGSize textSize = [self sizeWithString:[data objectForKey:@"text"] font:NJNameFont maxSize:CGSizeMake(270, MAXFLOAT)];
        self.textF = CGRectMake(10, 10, 0,0);
        self.valueF = CGRectMake(26, 12, textSize.width, textSize.height);
        
        self.cellHeight = textSize.height + 26;
    }
    else{
        CGSize textSize = [self sizeWithString:[data objectForKey:@"title"] font:NJNameFont maxSize:CGSizeMake(220, MAXFLOAT)];
        self.textF = CGRectMake(10, 10, textSize.width, textSize.height);
        self.valueF = CGRectMake(textSize.width + 50, 12, 200, 20);
        
        self.cellHeight = 48;
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
@end
