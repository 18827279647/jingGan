//
//  HappyShoppingSecondSectionHeaderView.m
//  jingGang
//
//  Created by 张康健 on 15/11/21.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "HappyShoppingSecondSectionHeaderView.h"
#import "GlobeObject.h"
@interface HappyShoppingSecondSectionHeaderView ()


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@end

@implementation HappyShoppingSecondSectionHeaderView

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    if (indexPath.section == 1) {
        self.topViewHeight.constant = 0.0;
    }else if (indexPath.section == 2){
        self.topViewHeight.constant = 6;
    }

}

@end
