//
//  YSOneStairClassfyCollectionViewCell.m
//  jingGang
//
//  Created by HanZhongchou on 2017/6/5.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSOneStairClassfyCollectionViewCell.h"
#import "GlobeObject.h"
#import "YSAdaptiveFrameConfig.h"

@interface YSOneStairClassfyCollectionViewCell ()
//分类图片与分类名称的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *classImageViewWithClassNameLabelSpace;
//分类名称与底部横线的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *classNameLabelWithBottomViewSpace;

@end

@implementation YSOneStairClassfyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.viewBotton.backgroundColor = [YSThemeManager buttonBgColor];
    
    self.classImageViewWithClassNameLabelSpace.constant = [YSAdaptiveFrameConfig width:3.0];
    self.classNameLabelWithBottomViewSpace.constant = [YSAdaptiveFrameConfig width:4.0];
    self.labelClassfyName.font = [UIFont systemFontOfSize:[YSAdaptiveFrameConfig width:14]];
}

@end
