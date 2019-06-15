//
//  YSVersionConfig.m
//  jingGang
//
//  Created by dengxf on 16/11/1.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSVersionConfig.h"
#import "VApiManager.h"
#import "GlobeObject.h"
#import "NSBundle+Extension.h"
#import "NSObject+YYModel.h"
#import "YSLoginManager.h"
#import "YSTargetTriggerLimitConfig.h"

#define kSettingLowerVersionKey @"kSettingLowerVersionLocalKey"

@implementation YSVersionInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"apiId" : @"id"};
}

@end

@implementation YSVersionConfig

+ (void)appVersionCheck:(void (^)(BOOL, NSString *versionMsg, NSString *downUrl))resultCallback {
    VApiManager *manager = [[VApiManager alloc] init];
    VersionControlGetNewRequest *request = [[VersionControlGetNewRequest alloc] init:nil];
    request.api_type = appChannels;
    [manager versionControlGetNew:request success:^(AFHTTPRequestOperation *operation, VersionControlGetNewResponse *response) {
        if (response.errorCode) {
            BLOCK_EXEC(resultCallback,NO,nil,nil);
        }else {
            NSDictionary *dict = (NSDictionary *)response.sysVersionControlBO;
            
            switch ([[dict objectForKey:@"ifOpen"] integerValue]) {
                case 0:
                {
                    if ([appChannels integerValue] == 12) {
                        // 蒲公英
                        BLOCK_EXEC(resultCallback,YES,[NSString stringWithFormat:@"%@",[dict objectForKey:@"vcNumber"]],[NSString stringWithFormat:@"%@",[dict objectForKey:@"downloadUrl"]]);
                    }else {
                        BLOCK_EXEC(resultCallback,NO,nil,nil);
                    }
                }
                    break;
                case 1:
                {
                    BLOCK_EXEC(resultCallback,YES,[NSString stringWithFormat:@"%@",[dict objectForKey:@"vcNumber"]],[NSString stringWithFormat:@"%@",[dict objectForKey:@"downloadUrl"]]);
                }
                    break;
                default:
                    break;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        BLOCK_EXEC(resultCallback,NO,nil,nil);
    }];
}

+ (void)settingShowUpdateAlert:(BOOL)show {
    if (show) {
        [self save:@1 key:@"kUpdateAlertShowKey"];
    }else {
        [self save:@0 key:@"kUpdateAlertShowKey"];
    }
}

+ (BOOL)queryShowUpdateAlert {
    return [[self achieve:@"kUpdateAlertShowKey"] boolValue];
}

+ (void)queryVersionInformation {
    [self settingShowUpdateAlert:NO];
    [self setAuditStatus:YSAuditStatusWithProcessing];
    NSString *version = [NSBundle version];
    VApiManager *manager = [[VApiManager alloc] init];
    VersionControlGetNewRequest *request = [[VersionControlGetNewRequest alloc] init:nil];
    request.api_type = appChannels;
    [manager versionControlGetNew:request success:^(AFHTTPRequestOperation *operation, VersionControlGetNewResponse *response) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)response.sysVersionControlBO];
        YSVersionInfoModel *versionModel = [YSVersionInfoModel modelWithDictionary:dict];
        if (versionModel == nil) {
            return ;
        }
        if ([versionModel.ifOpen boolValue]) {
            // 版本检测打开,判断用户版本与后台系统配置版本是否相同
            NSString *backgroundControlVersion = [NSString stringWithFormat:@"%@",versionModel.vcNumber];
            [self setAuditStatus:YSAuditStatysWithProcessed];
            if ([version isEqualToString:backgroundControlVersion]) {
                return;
            }else {
                // 版本不同，需要提示,判断是否需要强制升级版本
                NSString *updateUrl = versionModel.downloadUrl;
                NSString *updateMessage = versionModel.vcDescribe;
                if ( !updateUrl || [updateUrl isEmpty]) {
                    return;
                }
                if (![self queryShowUpdateAlert]) {
                    if ([versionModel.ifMandatory boolValue]) {
                        // 强制版本升级
                        [self settingShowUpdateAlert:YES];
                        if (!updateMessage.length) {
                            return;
                        }
                        [UIAlertView xf_showWithTitle:@"提示" message:updateMessage onDismiss:^{
                            [YSLoginManager loginout];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self settingShowUpdateAlert:NO];
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
                            });
                        }];
                    }else {
                        // 可选择性升级 目前是一天一次
                        [YSTargetTriggerLimitConfig addTargetArrayTriggerWithIdentifier:@"com.members.optionalupdate" configCount:1 result:^(BOOL result) {
                            if (result) {
                                [self settingShowUpdateAlert:YES];
                                if (!updateMessage.length) {
                                    return ;
                                }
                                NSArray *msgs = [updateMessage componentsSeparatedByString:@"*"];
                                NSString *msg = [msgs componentsJoinedByString:@"\n"];
                                [UIAlertView xf_shoeWithTitle:@"提示" message:msg buttonsAndOnDismiss:@"取消",@"确定", ^(UIAlertView *alertView, NSInteger index){
                                    if (index == 1) {
                                        [self settingShowUpdateAlert:NO];
                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
                                    }
                                }];
                            }
                        }];
                    }
                }
            }
        }else {
            // 后台版本更新关闭
            NSString *backgroundControlVersion = [NSString stringWithFormat:@"%@",versionModel.vcNumber];
            if ([version isEqualToString:backgroundControlVersion]) {
                // 工程配置与后台配置一样 不设置低版本通行模式
                [self setLowerVersionFreeMode:NO];
            }else {
                // 设置低版本通行模式
                [self setLowerVersionFreeMode:YES];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self setAuditStatus:YSAuditStatusWithProcessing];
    }];
}

/**
 * 
    在审核期间 置低版本通行模式
    低版本用户可以使用审核期间屏蔽的功能
    相反相同版本的部分功能被屏蔽
 */
+ (void)setLowerVersionFreeMode:(BOOL)isLowerVersionMode {
    [self save:[NSNumber numberWithBool:isLowerVersionMode] key:kSettingLowerVersionKey];
}

+ (BOOL)isLowerVersionFreeMode {
    return [[self achieve:kSettingLowerVersionKey] boolValue];
}

+ (void)setAuditStatus:(YSAuditStatusType)status {
    if ([YSVersionConfig queryAuditStatus] == YSAuditStatysWithProcessed) {
        return;
    }
    [self save:[NSNumber numberWithInteger:status] key:[self auditSatatusKey]];
}

+ (YSAuditStatusType)queryAuditStatus {
    return [[self achieve:[self auditSatatusKey]] integerValue];
}

+ (NSString *)auditSatatusKey {
    return [NSString stringWithFormat:@"v%@_kAuditStatusKey",[NSBundle version]];
}

@end
