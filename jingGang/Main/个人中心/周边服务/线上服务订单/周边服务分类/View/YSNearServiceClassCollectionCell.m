//
//  YSNearServiceClassCollectionCell.m
//  jingGang
//
//  Created by HanZhongchou on 2017/11/7.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSNearServiceClassCollectionCell.h"
#import "YSNearServiceClassModel.h"
#import "YSImageConfig.h"
#import "GlobeObject.h"
@interface YSNearServiceClassCollectionCell ()
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewClass;
@property (weak, nonatomic) IBOutlet UILabel *labelClassName;
@property (nonatomic,strong) YSNearServiceClassModel *model;
@end

@implementation YSNearServiceClassCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataFromModel:(YSNearServiceClassModel *)model indexPath:(NSIndexPath *)indexPath{
    self.labelClassName.text  = model.adTitle;
    if (![model.adImgPath hasPrefix:@"http"]) {//indexPath.section == 0
        //本地数据部分
        self.imageViewClass.image = [UIImage imageNamed:model.adImgPath];
    }else{
        [YSImageConfig yy_view:self.imageViewClass setImageWithURL:[NSURL URLWithString:model.adImgPath] placeholderImage:DEFAULTIMG];
    }
}



@end
