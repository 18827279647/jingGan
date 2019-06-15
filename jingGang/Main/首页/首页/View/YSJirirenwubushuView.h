//
//  YSJirirenwubushuView.h
//  jingGang
//
//  Created by 李海 on 2018/8/15.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STLoopProgressView.h"
@interface YSJirirenwubushuView : UIView
@property(strong,nonatomic)UILabel *count;
@property(strong,nonatomic)UILabel *reliangLabel;
@property(strong,nonatomic)UILabel *ljlc;
@property(strong,nonatomic)UILabel *mubiao;
@property(strong,nonatomic)STLoopProgressView *processView;
- (instancetype)initWithFrame:(CGRect)frame clickCallback:(void(^)(NSInteger clickIndex))click cxjcCallback:(id_block_t)cxjcCallback ;
@property (nonatomic, copy)void(^MoreSearchblock)();
@property(strong,nonatomic)UIView *xueya;
@property(strong,nonatomic)UIView *xinlv;
@property(strong,nonatomic)UIView *xueyang;
@property(strong,nonatomic)UIView *part2;
-(UIView *)genItem:(NSString *)imageName titles:(NSArray *)titles;
@end
