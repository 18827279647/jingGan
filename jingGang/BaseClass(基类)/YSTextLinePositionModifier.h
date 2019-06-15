//
//  YSTextLinePositionModifier.h
//  jingGang
//
//  Created by dengxf on 16/7/21.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYKit.h"

@interface YSTextLinePositionModifier : NSObject<YYTextLinePositionModifier>


@property (nonatomic, strong) UIFont *font; // 基准字体 (例如 Heiti SC/PingFang SC)
@property (nonatomic, assign) CGFloat paddingTop; //文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom; //文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数
- (CGFloat)heightForLineCount:(NSUInteger)lineCount;

@end
