//
//  YSLinkElongHotelWebController.h
//  jingGang
//
//  Created by dengxf on 17/4/21.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSBaseWebViewController.h"

@interface YSLinkElongHotelWebController : UIViewController
@property (copy , nonatomic) NSString *navTitle;

- (instancetype)initWithWebUrl:(NSString *)url;

- (void)buildRightItemWithTilte:(NSString *)title params:(NSString *)params navTitle:(NSString *)navTitle;

@end
