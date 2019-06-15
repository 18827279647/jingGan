//
//  YSOneSectionClassfyCollectionReusableView.h
//  jingGang
//
//  Created by HanZhongchou on 2017/6/6.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSOneSectionClassfyCollectionReusableView : UICollectionReusableView

@property (nonatomic,strong) UILabel *labelTitle;
@property (nonatomic,copy) NSString *strTitle;

//一级分类名称
@property(nonatomic,copy) NSString *strStairClassfyTitle;

@property (nonatomic,copy) void (^selectComeInButtonClickBlock)(void);
@end
