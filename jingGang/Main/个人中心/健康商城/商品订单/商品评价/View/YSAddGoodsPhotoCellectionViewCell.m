//
//  YSAddGoodsPhotoCellectionViewCell.m
//  jingGang
//
//  Created by HanZhongchou on 2017/3/14.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSAddGoodsPhotoCellectionViewCell.h"

#import "GlobeObject.h"

@interface YSAddGoodsPhotoCellectionViewCell ()


@end

@implementation YSAddGoodsPhotoCellectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageViewPhoto.layer.cornerRadius = 6.0;
    self.imageViewPhoto.clipsToBounds = YES;
    // Initialization code
}


- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}
- (IBAction)deleteButton:(id)sender {
    if (self.deleteButtonClickBlock) {
        self.deleteButtonClickBlock(self.indexPath.row);
    }
}

@end
