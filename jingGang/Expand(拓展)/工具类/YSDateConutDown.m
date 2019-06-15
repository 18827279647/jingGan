//
//  YSDateConutDown.m
//  jingGang
//
//  Created by HanZhongchou on 2017/5/26.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSDateConutDown.h"

@interface YSDateConutDown ()
@property (nonatomic,strong) dispatch_source_t _timer;



@end


@implementation YSDateConutDown



- (void)beginCountdownWithTotle:(NSTimeInterval)totle
                          being:(msg_block_t)beging
                            end:(voidCallback)end
{
    __block NSInteger timeout = totle; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self._timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self._timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(self._timer, ^{
        if( timeout <= 0 ){ //倒计时结束，关闭
            dispatch_source_cancel(self._timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                BLOCK_EXEC(end);
            });
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSInteger seconds = timeout % 60;
                NSInteger minutes = (timeout / 60) % 60;
                NSInteger hours   = timeout / 3600;
                NSString *strConutDownDate = [NSString stringWithFormat:@"%02ld小时%02ld分%02ld秒 后自动取消",(long)hours, (long)minutes, (long)seconds];
                BLOCK_EXEC(beging,strConutDownDate);
            });
            timeout--;
        }
    });
    dispatch_resume(self._timer);
    
    
}


- (void)beginCountdownWithTotle2:(NSTimeInterval)totle
                          being2:(msg_block_t)beging
                            end2:(voidCallback)end
{
    __block NSInteger timeout = totle; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self._timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self._timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(self._timer, ^{
        if( timeout <= 0 ){ //倒计时结束，关闭
            dispatch_source_cancel(self._timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                BLOCK_EXEC(end);
            });
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSInteger seconds = timeout % 60;
                NSInteger minutes = (timeout / 60) % 60;
                NSInteger hours   = timeout / 3600;
                NSString *strConutDownDate = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
                BLOCK_EXEC(beging,strConutDownDate);
            });
            timeout--;
        }
    });
    dispatch_resume(self._timer);
    
    
}

- (void)cancelConutDown{
    //手动取消倒计时
    
    dispatch_source_cancel(self._timer);
}

@end
