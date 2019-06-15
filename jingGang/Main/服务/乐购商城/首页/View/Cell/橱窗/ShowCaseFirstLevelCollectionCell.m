//
//  ShowCaseFirstLevelCollectionCell.m
//  橱窗collectionView测试
//
//  Created by 张康健 on 15/8/13.
//  Copyright (c) 2015年 com.organazation. All rights reserved.
//

#import "ShowCaseFirstLevelCollectionCell.h"
#import "GlobeObject.h"
@implementation ShowCaseFirstLevelCollectionCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self.showCaseTitleButton setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateSelected];
    [self.showCaseTitleButton setTitleColor:UIColorFromRGB(0x9b9b9b) forState:UIControlStateNormal];
}

@end
