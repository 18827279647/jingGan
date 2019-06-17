//
//  RXUserDetaillResponse.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "AbstractResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface RXUserDetaillResponse : AbstractResponse

@property(strong,nonatomic)NSString*healthUserBO;
@property(strong,nonatomic)NSString*recommends;
@property(strong,nonatomic)NSString*adContentBO;
@property(strong,nonatomic)NSString*healthServiceRecommendBgBO;
@property(strong,nonatomic)NSString*healthServiceRecommendJdBO;
@property(strong,nonatomic)NSString*healthServiceRecommendXyBO;
@property(strong,nonatomic)NSString*invitationList;
@property(strong,nonatomic)NSString*keywordGoodsList;

@end

NS_ASSUME_NONNULL_END
