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
@property(nonatomic,copy)NSArray*adContentBO;
@property(nonatomic,copy)NSString*healthServiceRecommendBgBO;
@property(nonatomic,copy)NSString*healthServiceRecommendJdBO;
@property(nonatomic,copy)NSString*healthServiceRecommendXyBO;
@property(nonatomic,copy)NSArray*invitationList;
@property(nonatomic,copy)NSArray*keywordGoodsList;
@property(nonatomic,copy)NSArray*others;
//默认数据
@property(nonatomic,copy)NSArray*healthList;

@property(nonatomic,copy)NSString*bgImg;
@property(nonatomic,copy)NSString*jdImg;
@property(nonatomic,copy)NSString*xyImg;

@property(nonatomic,copy)NSString*memberNotice;
@property(nonatomic,copy)NSString*memberLastTime;

@property(nonatomic,assign)int isMember;

@property(nonatomic,strong)NSString*messageTitle;

@property(nonatomic,strong)NSString*isLA;

@property(nonatomic,assign)int hasHealth;

@property(nonatomic,strong)NSString*offTime;

@property(nonatomic,strong)NSString*url;

@property(nonatomic,strong)NSString*isGet;
@end

NS_ASSUME_NONNULL_END
