//
//  RXUserDetailResponse.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "AbstractResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface RXUserDetailResponse : AbstractResponse

@property (nonatomic, copy) NSDictionary * healthUserBO;
@property (nonatomic, copy) NSString * recommends;
@property(nonatomic,copy)NSString*adContentBO;
@property(nonatomic,copy)NSString*healthServiceRecommendBgBO;
@property(nonatomic,copy)NSString*healthServiceRecommendJdBO;
@property(nonatomic,copy)NSString*healthServiceRecommendXyBO;
@property(nonatomic,copy)NSArray*invitationList;
@property(nonatomic,copy)NSArray*keywordGoodsList;

//默认数据
@property(nonatomic,copy)NSArray*healthList;

@end

NS_ASSUME_NONNULL_END
