//
//  HongbaoViewController.h
//  jingGang
//
//  Created by whlx on 2019/3/13.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HongbaoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *hongbaobeijingImage;
@property (nonatomic,assign) NSString * string;
@property (weak, nonatomic) IBOutlet UILabel *yqLabel;

@property (nonatomic,assign) NSString * yqm;

@end

NS_ASSUME_NONNULL_END
