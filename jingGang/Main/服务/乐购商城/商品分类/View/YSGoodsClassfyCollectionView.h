//
//  YSGoodsClassfyCollectionView.h
//  jingGang
//
//  Created by HanZhongchou on 2017/6/5.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSGoodsClassfyCollectionView : UICollectionView

@property (nonatomic,copy) void(^isNeedShowBackTopButton)(BOOL);
- (void)setTwoClassfyWithDataArray:(NSMutableArray *)arrayTwoClassfyData stairClassfyName:(NSString *)strStairClassfyName;

@property (nonatomic,copy) void(^didSelectCollectionItemBlock)(NSIndexPath *selectIndexPath);

@property (nonatomic,copy) void(^collectionHeaderViewAllClassfyButtonClick)(void);
@end
