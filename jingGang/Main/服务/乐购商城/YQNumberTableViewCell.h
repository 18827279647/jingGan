//
//  YQNumberTableViewCell.h
//  jingGang
//
//  Created by whlx on 2019/3/14.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQNumberModes.h"
NS_ASSUME_NONNULL_BEGIN

@class YQNumberTableViewCell;

@protocol YQNumberTableViewDelegate <NSObject>

- (void)YQNumberTableViewCell:(YQNumberTableViewCell *)Cell AndNSSrtring:(NSString *)UserId;

@end

@interface YQNumberTableViewCell : UITableViewCell
@property (strong,nonatomic)YQNumberModes *UsersModels;

@property (nonatomic, weak) id<YQNumberTableViewDelegate>deletage;
@end

NS_ASSUME_NONNULL_END
