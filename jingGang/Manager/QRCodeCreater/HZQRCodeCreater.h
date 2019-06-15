//
//  HZQRCodeCreater.h
//  生成二维码Demo
//
//  Created by HanZhongchou on 16/8/15.
//  Copyright © 2016年 HanZhongchou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HZQRCodeCreater : NSObject

/**
 *  @param strUrl     需要生成二维码的字符串
 *  @param lengthSide 二维码的边长
 *  @return 二维码Image
 */

+ (UIImage *)createrQRCodeWithStrUrl:(NSString *)strUrl withLengthSide:(CGFloat)lengthSide;

@end
