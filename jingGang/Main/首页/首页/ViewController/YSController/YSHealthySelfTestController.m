//
//  YSHealthySelfTestController.m
//  jingGang
//
//  Created by dengxf on 16/7/28.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSHealthySelfTestController.h"
#import "VTMagic.h"
#import "ZongHeZhengVC.h"

@interface YSHealthySelfTestController ()<VTMagicViewDataSource, VTMagicViewDelegate>

@property (nonatomic, strong) VTMagicController *controllers;
@property (nonatomic, strong)  NSArray *menuLists;

@end

@implementation YSHealthySelfTestController

- (VTMagicController *)controllers {
    if (!_controllers) {
        _controllers = [[VTMagicController alloc] init];
        _controllers.view.translatesAutoresizingMaskIntoConstraints = NO;
        _controllers.magicView.navigationColor = [UIColor whiteColor];
        _controllers.magicView.sliderColor = COMMONTOPICCOLOR;
        _controllers.magicView.switchStyle = VTSwitchStyleDefault;
        _controllers.magicView.layoutStyle = VTLayoutStyleDivide;
        _controllers.magicView.navigationHeight = 44.f;
        _controllers.magicView.sliderExtension = 10.f;
        _controllers.magicView.dataSource = self;
        _controllers.magicView.delegate = self;
    }
    return _controllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.view.backgroundColor = JGBaseColor;
    [YSThemeManager setNavigationTitle:@"健康测试" andViewController:self];
    [self setupNavBarPopButton];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self addChildViewController:self.controllers];
    [self.view addSubview:self.controllers.view];
    [self.view setNeedsUpdateConstraints];
    self.menuLists = @[@"症状", @"综合征",@"心理",@"皮肤"];
    [self.controllers.magicView reloadData];
}

- (void)updateViewConstraints {
    
    UIView *magicView = self.controllers.view;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[magicView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[magicView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
    
    [super updateViewConstraints];
}

#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return self.menuLists;
}


- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:YSHexColorString(@"#9b9b9b") forState:UIControlStateNormal];
        [menuItem setTitleColor:YSHexColorString(@"#4a4a4a") forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    }
    return menuItem;
}
- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    switch (pageIndex) {
        case 0:
        {
            static NSString *gridId = @"jb.identifier";
            ZongHeZhengVC *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
            if (!viewController) {
                viewController =  [[ZongHeZhengVC alloc] init];
                viewController.selfTestTiID = @52;
                viewController.comminType = Commin_From_JiBing;
            }
            return viewController;
        }
            break;
        case 1:
        {
            static NSString *gridId = @"zhz.identifier";
            ZongHeZhengVC *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
            if (!viewController) {
                viewController = [[ZongHeZhengVC alloc] init];
                viewController.selfTestTiID = @51;
                viewController.comminType = commin_From_Zong_He_Zheng;
            }
            return viewController;
        }
            break;
        case 2:
        {
            static NSString *gridId = @"xl.identifier";
            ZongHeZhengVC *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
            if (!viewController) {
                viewController = [[ZongHeZhengVC alloc] init];
                viewController.selfTestTiID = @59;
                viewController.comminType = Commin_From_Heart;
            }
            return viewController;
        }
            break;
        case 3:
        {
            static NSString *gridId = @"skin.identifier";
            ZongHeZhengVC *viewController =  [magicView dequeueReusablePageWithIdentifier:gridId];
            //皮肤
            if (!viewController) {
                viewController = [[ZongHeZhengVC alloc] init];
                viewController.selfTestTiID = @4000;
                viewController.comminType = Commin_From_Skin;
            }
            return viewController;
        }
            break;
        default:
            break;
    }
    /**
     *  ////            疾病跳转
     //            ZongHeZhengVC *zongheZhenVC =  [[ZongHeZhengVC alloc] init];
     //            zongheZhenVC.selfTestTiID = @52;
     //            zongheZhenVC.comminType = Commin_From_JiBing;
     //             [self.navigationController pushViewController:zongheZhenVC animated:YES];
     //        }
     //
     //            break;
     //        case 12307:{
     ////        综合症跳转
     //            ZongHeZhengVC *zongheZhenVC =  [[ZongHeZhengVC alloc] init];
     //            zongheZhenVC.selfTestTiID = @51;
     //            zongheZhenVC.comminType = commin_From_Zong_He_Zheng;
     //            [self.navigationController pushViewController:zongheZhenVC animated:YES];
     //        }
     //            break;
     //        case 12308:{
     ////        心理跳转
     //            ZongHeZhengVC *zongHeZhengVC = [[ZongHeZhengVC alloc] init];
     //            zongHeZhengVC.comminType = Commin_From_Heart;
     //            zongHeZhengVC.selfTestTiID = @59;
     //            [self.navigationController pushViewController:zongHeZhengVC animated:YES];
     //        } */
    
//    static NSString *gridId = @"relate.identifier";
//    UIViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
//    if (!viewController) {
//        viewController = [[UIViewController alloc] init];
//    }
//    viewController.view.backgroundColor = JGRandomColor;
    return nil;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex
{
    
}

@end
