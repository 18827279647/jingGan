//
//  CircleLoader.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/18.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircleLoader : UIView


//进度颜色
@property(nonatomic, retain) UIColor* progressTintColor ;


//轨道颜色
@property(nonatomic, retain) UIColor* trackTintColor ;

//轨道宽度
@property (nonatomic,assign) float lineWidth;

//中间图片
@property (nonatomic,strong) UIImage *centerImage;

//进度
@property (nonatomic,assign) float progressValue;

//提示标题
@property (nonatomic,strong) NSString *promptTitle;

//开启动画
@property (nonatomic,assign) BOOL animationing;

//隐藏消失
- (void)hide;

@end

NS_ASSUME_NONNULL_END
