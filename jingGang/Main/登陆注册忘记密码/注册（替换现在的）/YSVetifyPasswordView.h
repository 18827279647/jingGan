//
//  YSVetifyPasswordView.h
//  jingGang
//
//  Created by dengxf on 2017/10/20.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSVetifyPasswordView : UIView

/**
 *  验证失败 */
- (void)verifyFail;

@property (copy , nonatomic) void(^verifyPasswordCallback)(NSString *pswdString);

@end
