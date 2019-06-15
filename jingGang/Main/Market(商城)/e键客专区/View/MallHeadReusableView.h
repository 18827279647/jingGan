//
//  MallHeadReusableView.h
//  jingGang
//
//  Created by whlx on 2019/5/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RecommenModel;
@class MallHeadReusableView;

@protocol MallHeadReusableViewDelegate <NSObject>

- (void)MallHeadReusableView:(MallHeadReusableView *)MallHeadReusableView AndRecommenModel:(RecommenModel *)model;


@end
NS_ASSUME_NONNULL_BEGIN

@interface MallHeadReusableView : UICollectionReusableView

@property (nonatomic, strong) NSMutableArray * commenModelArray;

@property (nonatomic, strong) NSMutableArray * ListModelArray;

@property (nonatomic, weak) id<MallHeadReusableViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
