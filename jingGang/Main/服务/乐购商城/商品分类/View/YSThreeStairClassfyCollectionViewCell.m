//
//  YSThreeStairClassfyCollectionViewCell.m
//  jingGang
//
//  Created by HanZhongchou on 2017/6/5.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSThreeStairClassfyCollectionViewCell.h"
#import "YSGoodsStairClassfyModel.h"
#import "YSImageConfig.h"
#import "GlobeObject.h"
@interface YSThreeStairClassfyCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewClassfy;
@property (weak, nonatomic) IBOutlet UILabel *labelClassfyName;

@end


@implementation YSThreeStairClassfyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization cod
    
}


- (void)setModel:(YSGoodsStairClassfyModel *)model{
    _model = model;
    self.labelClassfyName.text = model.className;
//    82x82
    [YSImageConfig yy_view:self.imageViewClassfy setImageWithURL:[NSURL URLWithString:model.mobileIcon] placeholderImage:DEFAULTIMG];
}

@end
