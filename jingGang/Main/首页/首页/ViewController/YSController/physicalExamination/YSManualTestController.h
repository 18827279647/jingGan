//
//  YSManualTestController.h
//  jingGang
//
//  Created by dengxf on 16/8/1.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefuController.h"

/**
 *  手机手动测试 */
@interface YSManualTestController : UIViewController

- (instancetype)initWithTestType:(YSInputValueType)testType;

@end

@interface YSManualTestInputView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                  placeHolder:(NSString *)placeHolder limiteValue:(NSInteger)limiteValue;


@property (strong,nonatomic) UITextField *textFiled;



@end
