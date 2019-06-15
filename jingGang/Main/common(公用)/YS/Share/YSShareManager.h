//
//  YSShareManager.h
//  jingGang
//
//  Created by dengxf on 16/8/16.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobeObject.h"
#import "GoodsDetailsModel.h"
/**
 *  健康圈分享链接 */
#define kFriendCircleDetailLink(uid,postId) [NSString stringWithFormat:@"%@/v1/%@tag=true&uid=%@&Id=%@",Base_URL,@"post/page_post_detail?",uid,postId]

#define KFriendCircleShareLink(postId,invitationCode)  [NSString stringWithFormat:@"%@/v1/%@tag=false&Id=%@&invitationCode=%@",Base_URL,@"post/page_post_detail?",postId,invitationCode]

//分享带邀请码的微商城首页链接
#define KShareGoToWeChatStoreUrl(invitationCode)  [NSString stringWithFormat:@"%@/index.htm?invitationCode=%@",MobileWeb_Url,invitationCode];
//邀请好友分享链接
#define kShareInvitationFriendUrl(invitationCode,title)  [NSString stringWithFormat:@"%@/carnation-static/static/app/share_invite.html?invitationCode=%@&tit=%@",StaticBase_Url,invitationCode,title];
//自测题分享链接
#define kShareSelfTestSubjectUrl(invitationCode,title)   [NSString stringWithFormat:@"%@/carnation-static/static/app/share_test.html?invitationCode=%@&tit=%@",StaticBase_Url,invitationCode,title];
//体检测试分享链接
#define kShareHealthCheakUpUrl(invitationCode,title)   [NSString stringWithFormat:@"%@/carnation-static/static/app/share_examination.html?invitationCode=%@&tit=%@",StaticBase_Url,invitationCode,title];
//分享商品
#define kGoodsShareUrlWithID(ID,invitationCode)  [NSString stringWithFormat:@"%@/v1/share/shareProduct?mobilePath=%@&url=%@/goods_%@.htm?invitationCode=%@",Base_URL,MobileWeb_Url,MobileWeb_Url,ID,invitationCode]
//分享邀请码默认内容
#define kShareInvitationFriendDefaultContent   @"专业健康管理创富平台，赶紧下载注册分享，一起创造财富。"

#define kShareFriendCirclePost(usersCount)   [NSString stringWithFormat:@"和%ld位e生康缘会员一起分享健康生活,免费使用,分享赚钱,赶紧来看看",usersCount];
@class YSShareConfig;
@interface YSShareManager : NSObject

- (void)shareWithObj:(YSShareConfig *)shareConfig showController:(UIViewController *)controller;

@end

@interface YSShareConfig : NSObject
@property (strong, nonatomic) GoodsDetailsModel *orderModel;
/**
 *  分享标题 */
@property (copy , nonatomic) NSString *title;

/**
 *  分享内容 */
@property (copy , nonatomic) NSString *content;

/**
 *  分享本地图片 */
@property (copy , nonatomic) NSString *prjImage;

/**
 *  分享远程图片 */
@property (copy , nonatomic) NSString *urlImage;

/**
 *  分享链接 */
@property (copy , nonatomic) NSString *url;

/**
 *  配置本地分享模型 */
+ (instancetype)configShareWithTitle:(NSString *)title content:(NSString *)content projectImage:(NSString *)image shareUrl:(NSString *)url;

/**
 *  配置远程分享模型 */
+ (instancetype)configShareWithTitle:(NSString *)title content:(NSString *)content UrlImage:(NSString *)image shareUrl:(NSString *)url;
@end

/**
 *  带分享的接口配置 */
@interface YSShareRequestConfig : NSObject
/**
 *  查询用户是否绑定过手机 */
+ (void)checkUserBindingWXSuccess:(void(^)(BOOL isBinding))success fail:(msg_block_t)failCallback error:(msg_block_t)errorCallback;

/**
 *  将用户与微信union进行绑定 */
+ (void)bindingWXUnionid:(NSString *)unionId success:(voidCallback)success fail:(msg_block_t)failCallback;


/**
 *  查询绑定cn账号的手机号是否绑定微信号*/
+ (void)checkUserPhoneIsBindWXWithPhoneNum:(NSString *)PhoneNum success:(void(^)(NSNumber *isBinding,NSString *unionID))success fail:(msg_block_t)failCallback;


@end
