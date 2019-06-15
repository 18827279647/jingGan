//
//  HongBaoTCViewController.h
//  jingGang
//
//  Created by whlx on 2019/4/23.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HongBaoTCViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (nonatomic,assign)  BOOL isJK;
@property (nonatomic,strong) UINavigationController * nav;
@end

NS_ASSUME_NONNULL_END
