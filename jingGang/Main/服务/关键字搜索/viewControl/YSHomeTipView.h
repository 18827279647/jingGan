//
//  YSHomeTipView.h
//  jingGang
//
//  Created by Eric Wu on 2019/6/2.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "LampListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSHomeTipView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) LampListModel *model;
+ (instancetype)homeTipView;
@end

NS_ASSUME_NONNULL_END
