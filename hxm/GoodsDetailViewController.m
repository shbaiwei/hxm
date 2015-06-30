//
//  GoodsDetailViewController.m
//  hxm
//
//  Created by Bruce He on 15-5-31.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "BWCommon.h"
#import "AFNetworkTool.h"
#import "CartTableViewController.h"
#import "ConsignationFormViewController.h"
#import "BuyTableViewController.h"


@interface GoodsDetailViewController ()

@property (nonatomic,weak) UIImageView *imageView;
@property (nonatomic,weak) UIImageView *imageView2;
@property (nonatomic,weak) UIView *nameView;
@property (nonatomic, weak) UIScrollView *sclView;

@end

@implementation GoodsDetailViewController

NSUInteger detail_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self pageLayout];
}

- (void) pageLayout{
    
    self.view.backgroundColor = [BWCommon getBackgroundColor];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title = @"商品详细";
    
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
    
    NSString *image_url = [data objectForKey:@"photo_cd1"];
    
    [self.imageView setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image_url]]]];
    
    CGSize itemSize = CGSizeMake(size.width/2, 200);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, 200);
    [self.imageView.image drawInRect:imageRect];
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString *image_url2 = [data objectForKey:@"photo_cd2"];
    
    [self.imageView2 setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image_url2]]]];
    
    CGSize itemSize2 = CGSizeMake(size.width/2, 200);
    UIGraphicsBeginImageContext(itemSize2);
    CGRect imageRect2 = CGRectMake(0.0, 0.0, itemSize2.width, 200);
    [self.imageView2.image drawInRect:imageRect2];
    self.imageView2.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 30)];
    
    [self.nameView addSubview:nameLabel];
    nameLabel.text = [data objectForKey:@"flw"];
    nameLabel.font = [UIFont systemFontOfSize:16];
    
    UIView *limitView = [self coloredView:[UIColor colorWithRed:82/255.0f green:204/255.0f blue:115/255.0f alpha:1]
                                    title:@"剩余" value:[data objectForKey:@"ent_num"] width:30];
    limitView.frame = CGRectMake(10, 40, 60, 20);

    [self.nameView addSubview:limitView];
    
    UIView *merchantView = [self coloredView:[UIColor colorWithRed:82/255.0f green:204/255.0f blue:115/255.0f alpha:1]
                                    title:@"商家" value:[data objectForKey:@"seller_name"] width:50];
    merchantView.frame = CGRectMake(75, 40, 80, 20);
    
    [self.nameView addSubview:merchantView];
    
    UIView *levelView = [self coloredView:[UIColor colorWithRed:219/255.0f green:0/255.0f blue:0/255.0f alpha:1]
                                    title:@"等级" value:[data objectForKey:@"flwlevel"] width:30];
    levelView.frame = CGRectMake(160, 40, 60, 20);
    
    [self.nameView addSubview:levelView];
    
    //price
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 80, 20)];
    [self.nameView addSubview:priceLabel];
    priceLabel.font = [UIFont systemFontOfSize:18];
    [priceLabel setTextColor:[UIColor colorWithRed:219/255.0f green:0/255.0f blue:0/255.0f alpha:1]];
    priceLabel.text = [NSString stringWithFormat:@"¥ %@",[data objectForKey:@"sale_prc"]];
    
    NSUInteger height = 40;
    NSUInteger y = 300;
    
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, y, size.width, 15)];
    borderView.backgroundColor = [BWCommon getBackgroundColor];
    [BWCommon setBottomBorder:borderView color:[BWCommon getBorderColor]];
    [self.sclView addSubview:borderView];
    
    y += 16;
    
    NSString *auc_no = [[NSString alloc] init];
    

    if([data objectForKey:@"auc_no"] == [NSNull null]){
        auc_no = @"";
    }
    else{
        auc_no = [data objectForKey:@"auc_no"];
    }
    
    [self.sclView addSubview:[self itemView: CGRectMake(0, y, size.width, height) title:@"拍卖顺序：" value:auc_no]];
    y += height+1;
    [self.sclView addSubview:[self itemView: CGRectMake(0, y, size.width, height) title:@"拍卖频道：" value:[data objectForKey:@"channel"]]];
    
    y += height+1;
    [self.sclView addSubview:[self itemView: CGRectMake(0, y, size.width, height) title:@"商品编号：" value:[data objectForKey:@"goods_cd"]]];
    
    y += height+1;
    UIView *borderView2 = [[UIView alloc] initWithFrame:CGRectMake(0, y, size.width, 15)];
    borderView2.backgroundColor = [BWCommon getBackgroundColor];
    [BWCommon setBottomBorder:borderView2 color:[BWCommon getBorderColor]];
    [self.sclView addSubview:borderView2];
    
    y += 16;
    [self.sclView addSubview:[self itemView: CGRectMake(0, y, size.width, height) title:@"花头：" value:[data objectForKey:@"flwhead"]]];
    y += height+1;
    [self.sclView addSubview:[self itemView: CGRectMake(0, y, size.width, height) title:@"长度：" value:[data objectForKey:@"length"]]];
    y += height+1;
    [self.sclView addSubview:[self itemView: CGRectMake(0, y, size.width, height) title:@"入数：" value:[data objectForKey:@"ent_num"]]];
    y += height+1;
    [self.sclView addSubview:[self itemView: CGRectMake(0, y, size.width, height) title:@"重量：" value:[data objectForKey:@"weight"]]];
    
    
    y += height+1;
    UIView *borderView3 = [[UIView alloc] initWithFrame:CGRectMake(0, y, size.width, 15)];
    borderView3.backgroundColor = [BWCommon getBackgroundColor];
    [BWCommon setBottomBorder:borderView3 color:[BWCommon getBorderColor]];
    [self.sclView addSubview:borderView3];
    
    y += 16;
    [self.sclView addSubview:[self itemView: CGRectMake(0, y, size.width, height) title:@"入库数量：" value:[data objectForKey:@"ent_qty"]]];
    y += height+1;
    [self.sclView addSubview:[self itemView: CGRectMake(0, y, size.width, height) title:@"拍卖数量：" value:[data objectForKey:@"lock_qty"]]];
    y += height+1;
    
    NSInteger sale_qty = [[data objectForKey:@"ent_qty"] integerValue] - [[data objectForKey:@"lock_qty"] integerValue];
    [self.sclView addSubview:[self itemView: CGRectMake(0, y, size.width, height) title:@"可售数量：" value:[NSString stringWithFormat:@"%ld",sale_qty]]];
    y += height+1;
    [self.sclView addSubview:[self itemView: CGRectMake(0, y, size.width, height) title:@"卖点说明：" value:[data objectForKey:@"flwmor"]]];
    
    
    
    y += height + 16;
    UIButton *cartButton = [self footerButton:@"加入购物车" bgColor:[UIColor colorWithRed:255/255.0f green:126/255.0f blue:0 alpha:1]];
    
    cartButton.frame = CGRectMake(10, y, 98, 40);
    [self.sclView addSubview:cartButton];
    
    UIButton *buyButton = [self footerButton:@"立即购买" bgColor:[UIColor colorWithRed:219/255.0f green:0/255.0f blue:0 alpha:1]];
    
    buyButton.frame = CGRectMake(113, y, 98, 40);
    [self.sclView addSubview:buyButton];
    
    UIButton *auctionButton = [self footerButton:@"委托拍卖" bgColor:[UIColor colorWithRed:116/255.0f green:197/255.0f blue:67/255.0f alpha:1]];
    
    auctionButton.frame = CGRectMake(216, y, 98, 40);
    [self.sclView addSubview:auctionButton];

    
    [buyButton addTarget:self action:@selector(buyButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [auctionButton addTarget:self action:@selector(auctionButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [cartButton addTarget:self action:@selector(cartButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(UIButton *) footerButton: (NSString *) title bgColor : (UIColor *) bgColor {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];

    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:5.0];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = bgColor;
    button.tintColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
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
    
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"goods/getGoodsInfoById"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"goods/getGoodsInfoById"];
    
    [postData setValue:[NSString stringWithFormat:@"%ld",detail_id] forKey:@"ent_id"];
    
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



-(void) buyButtonTouched:(UIButton *)sender{
    // NSLog(@"%ld",sender.tag);
    
    BuyTableViewController * buyTableViewController = [[BuyTableViewController alloc] init];
    self.delegate = buyTableViewController;
    [self.navigationController pushViewController:buyTableViewController animated:YES];
    [self.delegate setValue:detail_id];
    
    
}

-(void) auctionButtonTouched:(UIButton *)sender{
    //NSLog(@"%ld",sender.tag);
    
    ConsignationFormViewController * consignationFormViewController = [[ConsignationFormViewController alloc] init];
    self.delegate = consignationFormViewController;
    [self.navigationController pushViewController:consignationFormViewController animated:YES];
    [self.delegate setValue:detail_id];
}

-(void) cartTouched:(id)sender{
    //NSLog(@"%ld",sender.tag);
    CartTableViewController * cartViewController = [[CartTableViewController alloc] init];
    self.delegate = cartViewController;
    [self.navigationController pushViewController:cartViewController animated:YES];
}

-(void) cartButtonTouched:(UIButton *)sender{
    //NSLog(@"%ld",sender.tag);
    
    //加入购物车
    
    __weak GoodsDetailViewController *weakSelf = self;
    
    [self addToCart:detail_id callback:^{
        
        CartTableViewController * cartViewController = [[CartTableViewController alloc] init];
        weakSelf.delegate = cartViewController;
        [weakSelf.navigationController pushViewController:cartViewController animated:YES];
        [weakSelf.delegate setValue:detail_id];
    }];
}

-(void) addToCart: (NSUInteger) ent_id callback:(void(^)()) callback{
    
    NSString *url =  [[BWCommon getBaseInfo:@"api_url"] stringByAppendingString:@"cart/AddToCart"];
    
    NSMutableDictionary *postData = [BWCommon getTokenData:@"cart/AddToCart"];
    
    [postData setValue:[NSString stringWithFormat:@"%ld",ent_id] forKey:@"id"];
    [postData setValue:@"1" forKey:@"quantity"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    NSLog(@"%@",url);
    //load data
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        NSLog(@"%@",responseObject);
        
        if(errNo == 0)
        {
            if(callback){
                callback();
            }
        }
        else
        {
            NSLog(@"%@",[responseObject objectForKey:@"error"]);
            [alert setMessage:[responseObject objectForKey:@"error"]];
            [alert show];
        }
        
    } fail:^{
        NSLog(@"请求失败");
        [alert setMessage:@"请求超时"];
        [alert show];
    }];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
