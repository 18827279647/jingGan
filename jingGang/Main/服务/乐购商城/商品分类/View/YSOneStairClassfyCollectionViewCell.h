//
//  YSOneStairClassfyCollectionViewCell.h
//  jingGang
//
//  Created by HanZhongchou on 2017/6/5.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSOneStairClassfyCollectionViewCell : UICollectionViewCell
//分类imageView
@property (weak, nonatomic) IBOutlet UIImageView *imageViewClassfy;
//分类名称label
@property (weak, nonatomic) IBOutlet UILabel *labelClassfyName;
//选中的底部view
@property (weak, nonatomic) IBOutlet UIView *viewBotton;

@end
