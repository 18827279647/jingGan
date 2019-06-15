//
//  MyErWeiMaView.h
//  jingGang
//
//  Created by 张康健 on 15/11/14.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ErweimaSnapUrlGetBlock)(UIImage *shareImage,NSString *shareImageUrl);
typedef void(^ShareErweimaBlock)(void);
//分享二维码
typedef void(^myErWeiMaViewImmediatelyInviteButtonClick)(void);
//分享邀请码
typedef void(^shareErweimaButtonClick)(void);

@interface ErweiMoModel : NSObject

@property (nonatomic, copy)NSString *userHeaderUrlStr;
@property (nonatomic, copy)NSString *userNickName;
@property (nonatomic, copy)NSString *userInvitationCode;
@property (nonatomic, copy)NSString *userShareContent;
@property (nonatomic, copy)NSString *userInvitationCount;
@property (nonatomic,strong) NSNumber *sex;

@end

@interface MyErWeiMaView : UIView

@property (nonatomic, strong)ErweiMoModel *erweimoModel;

@property (nonatomic, copy)ShareErweimaBlock shareErweimaBlock;

@property (nonatomic, copy)ErweimaSnapUrlGetBlock erweimaSnapUrlGetBlock;

@property (nonatomic, copy)myErWeiMaViewImmediatelyInviteButtonClick myErWeiMaViewImmediatelyInviteButtonClickBlock;

@property (nonatomic, copy)shareErweimaButtonClick shareErweimaButtonClickBlock;

@end

