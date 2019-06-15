//
//  YQNumberModes.h
//  jingGang
//
//  Created by whlx on 2019/4/8.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mantle.h"
NS_ASSUME_NONNULL_BEGIN

@interface YQNumberModes : MTLModel <MTLJSONSerializing>
@property (nonatomic , assign) NSInteger              appid;
@property (nonatomic , copy) NSString              * nickName;
@property (nonatomic , assign) int              status;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , assign) int              redNum;
@property (nonatomic , copy) NSString              * headImgPath;
@property (nonatomic , assign) int              payLogNum;
@property (nonatomic , copy) NSString              * uid;

@property (nonatomic , copy) NSString              * type;

@property (nonatomic , copy) NSString              * content1;

@property (nonatomic , copy) NSString              * content2;

@end

NS_ASSUME_NONNULL_END
