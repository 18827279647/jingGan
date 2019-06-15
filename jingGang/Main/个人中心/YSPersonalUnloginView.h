//
//  YSPersonalUnloginView.h
//  jingGang
//
//  Created by dengxf on 17/2/13.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSPersonalUnloginView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                loginCallback:(voidCallback)loginCallback
        quickRegisterCallback:(voidCallback)quickRegisterCallback
       forgetPasswordCallback:(voidCallback)forgetPasswordCallback;

@end
