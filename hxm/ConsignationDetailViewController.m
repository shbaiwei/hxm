//
//  ConsignationDetailViewController.m
//  hxm
//
//  Created by Bruce He on 15/6/25.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "ConsignationDetailViewController.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"


@interface ConsignationDetailViewController ()

@property (nonatomic,weak) UIImageView *imageView;
@property (nonatomic,weak) UIImageView *imageView2;
@property (nonatomic,weak) UIView *nameView;
@property (nonatomic, weak) UIScrollView *sclView;

@end

@implementation ConsignationDetailViewController

NSUInteger detail_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self pageLayout];
}

- (void) pageLayout{
    
    self.view.backgroundColor = [BWCommon getBackgroundColor];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title = @"委托详细";
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    sclView.backgroundColor = [BWCommon getBackgroundColor];
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width,900);
    
    self.sclView = sclView;
    [self.view addSubview:sclView];
    
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width/2, 200)];
    
    self.imageView = imageView;
    [self.sclView addSubview:imageView];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(size.width/2, 0, size.width/2, 200)];
    
    self.imageView2 = imageView2;
    [self.sclView addSubview:imageView2];
    
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, size.width, 100)];
    self.nameView = nameView;
    nameView.backgroundColor = [UIColor whiteColor];
    [self.sclView addSubview:nameView];
    
    [self loadData:detail_id callback:^{}];
}

- (void) renderPage:(NSDictionary *) data{
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    NSString *image_url = [data objectForKey:@"img1"];
    
    [self.imageView setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image_url]]]];
    
    CGSize itemSize = CGSizeMake(size.width/2, 200);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, 200);
    [self.imageView.image drawInRect:imageRect];
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString *image_url2 = [data objectForKey:@"img2"];
    
    [self.imageView2 setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image_url2]]]];
    
    CGSize itemSize2 = CGSizeMake(size.width/2, 200);
    UIGraphicsBeginImageContext(itemSize2);
    CGRect imageRect2 = CGRectMake(0.0, 0.0, itemSize2.width, 200);
    [self.imageView2.image drawInRect:imageRect2];
    self.imageView2.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 30)];
    [self.nameView addSubview:nameLabel];
    nameLabel.text = [NSString stringWithFormat:@"商品序号：%ld",detail_id];
    nameLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *aucLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 38, 280, 30)];
    [self.nameView addSubview:aucLabel];
    aucLabel.text = [NSString stringWithFormat:@"拍卖批次：%@",[data objectForKey:@"auc_cd"]];
    aucLabel.font = [UIFont systemFontOfSize:16];
    
    UIView *levelView = [self coloredView:[UIColor colorWithRed:219/255.0f green:0/255.0f blue:0/255.0f alpha:1]
                                    title:@"等级" value:[data objectForKey:@"flowerLevel"] width:30];
    levelView.frame = CGRectMake(size.width - 90, 20, 60, 20);
    
    [self.nameView addSubview:levelView];
    
    UIView *statusView = [self coloredView:[UIColor colorWithRed:82/255.0f green:204/255.0f blue:115/255.0f alpha:1]
                                    title:@"状态" value:[data objectForKey:@"status"] width:50];
    statusView.frame = CGRectMake(size.width - 90, 50, 80, 20);
    
    [self.nameView addSubview:statusView];
    
    
    //price
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 80, 20)];
    [self.nameView addSubview:priceLabel];
    priceLabel.font = [UIFont systemFontOfSize:16];
    [priceLabel setTextColor:[UIColor colorWithRed:219/255.0f green:0/255.0f blue:0/255.0f alpha:1]];
    priceLabel.text = @"委托价：";
    
    UILabel *priceValue = [[UILabel alloc] initWithFrame:CGRectMake(80, 70, 120, 20)];
    [self.nameView addSubview:priceValue];
    priceValue.font = [UIFont systemFontOfSize:20];
    [priceValue setTextColor:[UIColor colorWithRed:219/255.0f green:0/255.0f blue:0/255.0f alpha:1]];
    priceValue.text = [NSString stringWithFormat:@"¥ %@",[data objectForKey:@"price"]];
    
    NSUInteger height = 40;
    NSUInteger y = 300;
    
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, y, size.width, 15)];
    borderView.backgroundColor = [BWCommon getBackgroundColor];
    [BWCommon setBottomBorder:borderView color:[BWCommon getBorderColor]];
    [self.sclView addSubview:borderView];
    
    y += 16;
    
    [self.sclView addSubview:[self itemView: CGRectMake(0, y, size.width, height) title:@"形态：" value:[data objectForKey:@"flowerMorphology"]]];
    y += height+1;
    [self.sclView addSubview:[self itemView: CGRectMake(0, y, size.width, height) title:@"品类：" value:[data objectForKey:@"flowerCategory"]]];
    
    y += height+1;
    [self.sclView addSubview:[self itemView: CGRectMake(0, y, size.width, height) title:@"品种：" value:[data objectForKey:@"flower"]]];
    
    y += height+1;
    UIView *borderView2 = [[UIView alloc] initWithFrame:CGRectMake(0, y, size.width, 15)];
    borderView2.backgroundColor = [BWCommon getBackgroundColor];
    [BWCommon setBottomBorder:borderView2 color:[BWCommon getBorderColor]];
    [self.sclView addSubview:borderView2];
    
    y += 16;
    [self.sclView addSubview:[self itemView: CGRectMake(0, y, size.width, height) title:@"花头：" value:[data objectForKey:@"flowerHead"]]];
    y += height+1;
    [self.sclView addSubview:[self itemView: CGRectMake(0, y, size.width, height) title:@"长度：" value:[data objectForKey:@"length"]]];
    y += height+1;
    [self.sclView addSubview:[self itemView: CGRectMake(0, y, size.width, height) title:@"入数：" value:[data objectForKey:@"ent_num"]]];
    y += height+1;
    [self.sclView addSubview:[self itemView: CGRectMake(0, y, size.width, height) title:@"重量：" value:[data objectForKey:@"weight"]]];
    y += height+1;
    [self.sclView addSubview:[self itemView: CGRectMake(0, y, size.width, height) title:@"委托数量：" value:[data objectForKey:@"etr_qty"]]];
    y += height+1;
    [self.sclView addSubview:[self itemView: CGRectMake(0, y, size.width, height) title:@"委托时间：" value:[data objectForKey:@"create_time"]]];
    
 
    
    
    
    
}


-(UIView *) itemView: (CGRect) frame   title :(NSString *) title value:(NSString *) value{
    
    UIView * view =  [[ UIView alloc] initWithFrame:frame];
    
    view.backgroundColor = [UIColor whiteColor];
    
    
    UIFont * NJFont = [UIFont systemFontOfSize:14 weight:10];
    
    CGSize titleSize = [self sizeWithString:title font:NJFont maxSize:CGSizeMake(80, MAXFLOAT)];
    CGFloat titleW = titleSize.width;
    CGFloat titleH = titleSize.height;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, titleW, titleH)];
    [view addSubview:titleLabel];
    titleLabel.font = NJFont;
    titleLabel.text = title;
    
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+titleW, 10, 160, titleH)];
    [view addSubview:valueLabel];
    valueLabel.font = [UIFont systemFontOfSize:14];
    valueLabel.text = value;
    
    [BWCommon setBottomBorder:view color:[BWCommon getBorderColor]];
    
    return view;
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


- (UIView *) coloredView:(UIColor *)bgColor title:(NSString *)title value:(NSString *) value width:(NSUInteger) width{
    
    UIView *view = [[UIView alloc] init];
    
    view.layer.cornerRadius = 3.0f;
    [view.layer setBorderColor:bgColor.CGColor];
    [view.layer setBorderWidth:1.0f];
    
    UILabel *levelTitle = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, 30, 20)];
    levelTitle.text = title;
    levelTitle.font = [UIFont systemFontOfSize:14];
    levelTitle.backgroundColor = bgColor;
    [levelTitle setTextColor:[UIColor whiteColor]];
    [levelTitle setTextAlignment:NSTextAlignmentCenter];
    [view addSubview:levelTitle];
    
    UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, width, 20)];
    levelLabel.font = [UIFont systemFontOfSize:14];
    levelLabel.text = value;
    [view addSubview:levelLabel];
    [levelLabel setTextColor:bgColor];
    [levelLabel setTextAlignment:NSTextAlignmentCenter];
    
    return view;
}


- (void) loadData:(NSUInteger) detail_id callback:(void(^)()) callback{
    
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"delegation/getDelegationById"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"delegation/getDelegationById"];
    
    [postData setValue:[NSString stringWithFormat:@"%ld",detail_id] forKey:@"id"];
    
    NSLog(@"%ld",detail_id);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        [hud removeFromSuperview];
        if(errNo == 0)
        {
            
            NSLog(@"%@",[responseObject objectForKey:@"data"]);
            
            [self renderPage:[responseObject objectForKey:@"data"]];
            
            if(callback){
                callback();
            }
            
            //NSLog(@"%@",json);
        }
        else
        {
            NSLog(@"%@",[responseObject objectForKey:@"error"]);
        }
        
    } fail:^{
        [hud removeFromSuperview];
        NSLog(@"请求失败");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setValue:(NSUInteger)detailValue{
    
    detail_id =detailValue;
}

@end
