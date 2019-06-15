//
//  ImgTitView.h
//  jingGang
//
//  Created by HanZhongchou on 16/8/25.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgTitView : UIView

@property (strong, nonatomic) NSDictionary *dictClassInfo;




- (instancetype)initImageAndTitleViewWith:(CGRect)frame AndClassInfo:(NSDictionary *)dictClassInfo;

@end
