//
//  YSForceUpdateManager.m
//  jingGang
//
//  Created by Eric Wu on 2019/6/2.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "YSForceUpdateManager.h"
#import "YSAFNetworking.h"

@implementation YSForceUpdateManager
CRManager(YSForceUpdateManager);
- (void)checkNeedUpdate
{
    NSString *url = [ShanrdURL joinUrl:@"v1/versionControl/getForcedUpdate"];
    NSDictionary *params = @{@"type": @(22),
                             @"appType": @(1),
                             @"vcNumber": CRAppVersionShort
                             };
    [YSAFNetworking GetUrlString:url parametersDictionary:params successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *data = JSONFromObject(responseObject);
        BOOL needUpdate = [data[@"forcedUpdate"] boolValue];
        if (needUpdate) {
            [self showForceUpdateView:data[@"SysVersionControlBO"]];            
        }
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
       
    }];
}
- (void)showForceUpdateView:(NSDictionary *)data
{
    if (self.updateView) {
        return;
    }
    self.updateView = [YSForceUpdateView forceUpdateView];
    CRWeekRef(self);
    self.updateView.needUpdateOnClick = ^{
        [__self goUpdateForUrl:data[@"downloadUrl"]];
    };
    [CRMainWindow() addSubview:self.updateView];
    self.updateView.frame = CRScreenRect();
    self.updateView.lblTitle.text = CRString(@"全新版本：V%@", data[@"vcNumber"]);
    self.updateView.lblContent.text = data[@"vcDescribe"];
}

- (void)goUpdateForUrl:(NSString *)url
{
    [Utility goStringUrl:url];
}
@end
