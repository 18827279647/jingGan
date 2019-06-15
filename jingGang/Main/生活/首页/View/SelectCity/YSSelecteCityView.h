//
//  YSSelecteCityView.h
//  jingGang
//
//  Created by dengxf on 16/11/23.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSSelecteCityView;
@protocol YSSelecteCityViewDelegate <NSObject>

@optional

- (void)didClickSearckWithSelecteCityView:(YSSelecteCityView *)selecteCityView;

@end

@interface YSSelecteCityView : UIView

@property (assign, nonatomic) id<YSSelecteCityViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame citys:(NSArray *)array selected:(id_block_t)selectedCallback showHeaderView:(BOOL)show;

@end
