//
//  YSMyCenterLoginView.h
//  jingGang
//
//  Created by 李海 on 2018/8/18.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSMyCenterLoginView : UIView
- (instancetype)initWithFrame:(CGRect)frame
                loginCallback:(voidCallback)loginCallback
        quickRegisterCallback:(voidCallback)quickRegisterCallback
       forgetPasswordCallback:(voidCallback)forgetPasswordCallback;

@end
