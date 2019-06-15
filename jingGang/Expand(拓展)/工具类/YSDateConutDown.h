//
//  YSDateConutDown.h
//  jingGang
//
//  Created by HanZhongchou on 2017/5/26.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSDateConutDown : NSObject
- (void)beginCountdownWithTotle:(NSTimeInterval)totle being:(msg_block_t)beging end:(voidCallback)end;

- (void)beginCountdownWithTotle2:(NSTimeInterval)totle
                          being2:(msg_block_t)beging
                            end2:(voidCallback)end;
- (void)cancelConutDown;
@end
