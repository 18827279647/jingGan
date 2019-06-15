//
//  YSThreeStairClassfyCollectionViewCell.h
//  jingGang
//
//  Created by HanZhongchou on 2017/6/5.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSGoodsStairClassfyModel;
@interface YSThreeStairClassfyCollectionViewCell : UICollectionViewCell
//普通显示的页面
@property (weak, nonatomic) IBOutlet UIView *viewNormalDisplay;
//最后一个现实的cell显示这个
@property (weak, nonatomic) IBOutlet UIView *viewMoreDisplay;


@property (nonatomic,strong) YSGoodsStairClassfyModel *model;
@end
