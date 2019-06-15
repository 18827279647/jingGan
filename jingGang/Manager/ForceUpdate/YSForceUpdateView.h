//
//  YSForceUpdateView.h
//  jingGang
//
//  Created by Eric Wu on 2019/6/2.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSForceUpdateView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (copy, nonatomic) CRCompletionTask needUpdateOnClick;

+ (instancetype)forceUpdateView;

@end

NS_ASSUME_NONNULL_END
