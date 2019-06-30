//
//  RXZhangKaiTableViewCell.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/19.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RXZhangKaiTableViewCell : UITableViewCell

//默认有4个

@property (weak, nonatomic) IBOutlet UIButton *oneOneButton;
@property (weak, nonatomic) IBOutlet UIButton *oneTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *oneFreeButton;
@property (weak, nonatomic) IBOutlet UIButton *oneFiveButton;

//默认3个
@property (weak, nonatomic) IBOutlet UIButton *twoOneButon;

@property (weak, nonatomic) IBOutlet UIButton *twoTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *twoFreeButton;


//默认2个
@property (weak, nonatomic) IBOutlet UIButton *freeOneButton;
@property (weak, nonatomic) IBOutlet UIButton *freeTwoButton;

//默认1个
@property (weak, nonatomic) IBOutlet UIButton *fiveOneButton;

@end

NS_ASSUME_NONNULL_END
