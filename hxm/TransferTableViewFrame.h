//
//  TransferTableViewFrame.h
//  hxm
//
//  Created by Bruce He on 15/7/1.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TransferTableViewFrame : NSObject

@property (nonatomic, assign) CGRect valueF;

@property (nonatomic, assign) CGRect textF;


@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSDictionary *data;

@end