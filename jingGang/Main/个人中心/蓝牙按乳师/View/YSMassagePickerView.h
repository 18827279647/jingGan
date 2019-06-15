//
//  YSMassagePickerView.h
//  jingGang
//
//  Created by dengxf on 17/6/28.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSMassagePickerView;
@protocol YSMassagePickerViewDelegate <NSObject>

- (void)pickerView:(YSMassagePickerView *)pickerView selectedItem:(NSInteger)item;

@end

@interface YSMassagePickerView : UIView

@property (copy , nonatomic) NSString *titleText;
@property (copy , nonatomic) NSString *selectedTitleText;
@property (copy , nonatomic) NSString *unit;
@property (assign, nonatomic) NSInteger dialCount;
@property (assign, nonatomic,readonly)  NSInteger   currenItemIndex;
@property (assign, nonatomic) BOOL shouldAutoScrollAnimate;
@property (assign, nonatomic) NSInteger defaultItem;
@property (assign, nonatomic) id<YSMassagePickerViewDelegate> delegate;

@end
