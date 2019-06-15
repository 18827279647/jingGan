//
//  XRHeandeView.h
//  jingGang
//
//  Created by whlx on 2019/3/15.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XRHeandeView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *YpeiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *JPeiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tianTime;
@property (weak, nonatomic) IBOutlet UILabel *shiTime;
@property (weak, nonatomic) IBOutlet UILabel *fenTime;
@property (weak, nonatomic) IBOutlet UILabel *miaoTime;
@property (weak, nonatomic) IBOutlet UIView *jinduView;

@end

NS_ASSUME_NONNULL_END
