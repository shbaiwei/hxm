//
//  PayWebViewController.h
//  hxm
//
//  Created by Bruce on 15-7-1.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayWebViewController : UIViewController
<UIWebViewDelegate>
{
    UIWebView *protWebView;
}

@property (nonatomic,retain) NSString *surl;

@end
