//
//  YSForceUpdateView.m
//  jingGang
//
//  Created by Eric Wu on 2019/6/2.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "YSForceUpdateView.h"

@implementation YSForceUpdateView
{
    __weak IBOutlet UIButton *btnUpdate;
    
}
+ (instancetype)forceUpdateView
{
    NSArray *nib = [CRBundle loadNibNamed:@"YSForceUpdateView" owner:self options:nil];
    UIView *tmpCustomView = [nib objectAtIndex:0];
    return (YSForceUpdateView *)tmpCustomView;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    btnUpdate.cornerRadius = 36 * 0.5;
    [btnUpdate addTarget:self action:@selector(btnUpdateOnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)btnUpdateOnClick:(UIButton *)btn
{
    if (self.needUpdateOnClick) {
        self.needUpdateOnClick();
    }
}
@end
