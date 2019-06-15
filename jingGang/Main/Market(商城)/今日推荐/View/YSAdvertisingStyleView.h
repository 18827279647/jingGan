//
//  YSAdvertisingStyleView.h
//  jingGang
//
//  Created by Eric Wu on 2019/6/1.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "AdVertisingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSAdvertisingStyleView : UIView
@property (strong, nonatomic) AdVertisingModel *adStyle;
@property (strong, nonatomic) NSMutableArray<UIButton *> *adButtonList;
@end

NS_ASSUME_NONNULL_END
