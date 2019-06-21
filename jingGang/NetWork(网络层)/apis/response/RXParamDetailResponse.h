//
//  RXParamDetailResponse.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/20.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "AbstractResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface RXParamDetailResponse : AbstractResponse

@property (nonatomic, copy)NSArray * paramDetail;
@property (nonatomic, copy)NSArray * levelList;
@property(nonatomic,copy)NSArray*keywordGoodsList;
@property(nonatomic,copy)NSArray*invitationList;

@end

NS_ASSUME_NONNULL_END
