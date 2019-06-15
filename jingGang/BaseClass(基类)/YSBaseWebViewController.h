//
//  YSBaseWebViewController.h
//  jingGang
//
//  Created by dengxf on 17/4/21.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSBaseWebViewController : UIViewController

- (instancetype)initConfigUrl:(voidCallback)configUrl;

- (void)loadReqeustWithUrl:(NSString *)url;

@end
