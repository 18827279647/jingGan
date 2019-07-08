//
//  YSHomeTipManager.m
//  jingGang
//
//  Created by Eric Wu on 2019/6/2.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "YSHomeTipManager.h"
#import "LampListModel.h"
#import "YSAFNetworking.h"
#import "GlobeObject.h"
#import "YSLoginPopManager.h"
#import "GoodsDetailsController.h"
#import "HongbaoViewController.h"
#import "HongbaoViewController.h"
#import "XRViewController.h"

@interface YSHomeTipManager()
@property (strong, nonatomic) NSMutableArray<LampListModel *> *dataSource;
//记录当前显示的条数
@property (assign, nonatomic) NSInteger currentIdx;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) YYTimer *timer;
@end
@implementation YSHomeTipManager
CRManager(YSHomeTipManager);
- (void)checkNeedShow
{
    [self.timer invalidate];
    if (self.tipView) {
        [self.tipView removeFromSuperview];
        _tipView = nil;
    }
    NSString *url = [ShanrdURL joinUrl:@"v1/channelTop/lampList"];
    [YSAFNetworking POSTUrlString:url parametersDictionary:@{} successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *data = JSONFromObject(responseObject);
        self.dataSource = [[NSArray modelArrayWithClass:CRClass(LampListModel) json:data[@"lampList"]] mutableCopy];
        if (self.dataSource.count) {
            [self showHomeTips];
        }
        
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
- (void)showHomeTips
{
    self.currentIdx = 0;
    self.index = 0;
    self.timer = [YYTimer timerWithTimeInterval:5 target:self selector:@selector(handleTimerOnTip) repeats:YES];
    [self.timer fire];
}
- (void)handleTimerOnTip
{
    if (self.currentIdx == self.dataSource.count - 1)
    {
        self.currentIdx = 0;
    }
    if (self.index % 2 == 0) {//显示
        if (self.tipView.superview) {
            [self.tipView removeFromSuperview];
        }
        LampListModel *model = [self.dataSource safeObjectAtIndex:self.currentIdx];
        YSHomeTipView *tipView = [YSHomeTipView homeTipView];
        tipView.layer.masksToBounds=YES;
        tipView.model = model;
        [tipView addTapRecognizer:self action:@selector(handleTapOnTipView:)];
        [self.supperView addSubview:tipView];
        self.tipView = tipView;
        self.tipView.iconView.layer.masksToBounds=YES;
        self.tipView.iconView.layer.cornerRadius=15;
        self.tipView.layer.masksToBounds=YES;
        self.tipView.layer.cornerRadius=15;
        tipView.origin = self.origin;
        self.currentIdx++;
    }
    else//隐藏
    {
        [self.tipView removeFromSuperview];
    }
    self.index++;
}

- (void)handleTapOnTipView:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        YSHomeTipView *tipView = (YSHomeTipView *)tapGesture.view;
        if (CRIsNullOrEmpty(GetToken)) {
            YSLoginPopManager *loginPopManager = [[YSLoginPopManager alloc] init];
            [loginPopManager showLogin:^{
                
            } cancelCallback:^{
            }];
            return;
        }
        LampListModel *model = tipView.model;
        if ([model.link isEqualToString:@"newRedHuoDong"]) {
            NSInteger userType = [CRUserObj(kUserStatuskey) integerValue];
            if (userType == 2) {
                HongbaoViewController * hongbao = [[HongbaoViewController alloc] init];
                hongbao.string = @"hongbaobeijing1";
                hongbao.hidesBottomBarWhenPushed = YES;
                [CRTopViewController().navigationController pushViewController:hongbao animated:YES];
                
            }else if (userType == 1){
                HongbaoViewController * hongbao = [[HongbaoViewController alloc] init];
                hongbao.string = @"bongbaobeijing";
                hongbao.hidesBottomBarWhenPushed = YES;
                [CRTopViewController().navigationController pushViewController:hongbao animated:YES];
                
            } else if (userType == 0){
                XRViewController * xt = [[XRViewController alloc] init];
                xt.hidesBottomBarWhenPushed = YES;
                [CRTopViewController().navigationController pushViewController:xt animated:YES];
            }
        }
        else
        {
            GoodsDetailsController * Controller = [[GoodsDetailsController alloc]init];
            Controller.areaId = @"3";
            Controller.goodsId = model.linkParam;
            [CRTopViewController().navigationController pushViewController:Controller animated:YES];
        }
    }
}
@end
