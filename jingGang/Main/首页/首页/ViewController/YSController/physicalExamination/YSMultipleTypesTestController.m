//
//  YSMultipleTypesTestController.m
//  jingGang
//
//  Created by dengxf on 16/8/1.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSMultipleTypesTestController.h"
#import "VTMagic.h"
#import "YSTelTestController.h"
#import "AboutYunEs.h"
#import "RXIntelligentEquipmentViewController.h"

@interface YSMultipleTypesTestController ()<VTMagicViewDataSource, VTMagicViewDelegate>

@property (nonatomic, strong) VTMagicController *controllers;
@property (nonatomic, strong)  NSArray *menuLists;
@property (strong,nonatomic) UIView *textBackgroundView;
/**
 *  健康测试类型 */
@property (assign, nonatomic) YSInputValueType testType;

@end

@implementation YSMultipleTypesTestController

#pragma mark - accessor methods
- (VTMagicController *)controllers {
    if (!_controllers) {
        _controllers = [[VTMagicController alloc] init];
        _controllers.view.translatesAutoresizingMaskIntoConstraints = NO;
        _controllers.magicView.navigationColor = [UIColor whiteColor];
        _controllers.magicView.sliderColor = COMMONTOPICCOLOR;
        _controllers.magicView.switchStyle = VTSwitchStyleDefault;
        _controllers.magicView.layoutStyle = VTLayoutStyleCenter;
        _controllers.magicView.navigationHeight = 44.f;
        _controllers.magicView.sliderExtension = 10.f;
        _controllers.magicView.itemSpacing = ScreenWidth/8-20;
        _controllers.magicView.dataSource = self;
        _controllers.magicView.delegate = self;
    }
    return _controllers;
}

- (instancetype)initWithTestType:(YSInputValueType)testType
{
    self = [super init];
    if (self) {
        self.testType = testType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super basicBuild];
    [self setup];
}

- (void)setup {
    [YSThemeManager setNavigationTitle:[self buildNavTitle] andViewController:self];
    [self addChildViewController:self.controllers];
    [self.view addSubview:self.controllers.view];
    self.controllers.view.x = 0;
    self.controllers.view.y =100;
    self.controllers.view.width = ScreenWidth;
    self.controllers.view.height = ScreenHeight - 100;
    [self buildTextView];
    self.menuLists = @[@"手机测量",@"智能设备",@"健康一体机",@"手动输入"];
    [self.controllers.magicView reloadData];
}

- (void)backToLastController {
    if (self.testType == YSInputValyeWithLungcapacityType) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kCloseLungTestNotificationKey" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)buildTextView {
    UIView *textBackgroundView = [[UIView alloc] init];
    textBackgroundView.backgroundColor = JGBaseColor;
    textBackgroundView.x = 0;
    textBackgroundView.y = 10;
    textBackgroundView.width = ScreenWidth;
    textBackgroundView.height = 0;
    [self.view addSubview:textBackgroundView];
    
    CGFloat magrinX = 15.0;
    UILabel *textLab = [[UILabel alloc] init];
    textLab.x = magrinX;
    textLab.y = 0;
    textLab.width = textBackgroundView.width - textLab.x * 2;
    textLab.height = 62.0;
    textLab.backgroundColor = JGClearColor;
    textLab.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
    textLab.font = JGFont(14);
    textLab.numberOfLines = 0;
    [textBackgroundView addSubview:textLab];
    textLab.attributedText = [self attText];
    
    JGTouchEdgeInsetsButton *detailButton = [JGTouchEdgeInsetsButton buttonWithType:UIButtonTypeCustom];
    detailButton.width = 56;
    detailButton.x = textBackgroundView.width - detailButton.width - magrinX;
    detailButton.titleLabel.font = JGFont(14);
    [detailButton setTitle:@"详情" forState:UIControlStateNormal];
    [detailButton setTitleColor:COMMONTOPICCOLOR forState:UIControlStateNormal];
    [textBackgroundView addSubview:detailButton];
    detailButton.y = MaxY(textLab);
    detailButton.height = 16;
    detailButton.touchEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    [detailButton addTarget:self action:@selector(viewsDetailAction) forControlEvents:UIControlEventTouchUpInside];
    textBackgroundView.height = MaxY(detailButton) + 10;
    self.textBackgroundView = textBackgroundView;
    /**
     *  height: 88 */
}

- (void)viewsDetailAction {
    YSHtmlControllerType controllerType;
    switch (self.testType) {
        case YSInputValueWithBloodPressureType:
        {
            controllerType =  YSHtmlControllerWithBloodPressure;
        }
            break;
        case YSInputValyeWithHeartRateType:
        {
            controllerType =  YSHtmlControllerWithHeartRate;
        }
            break;
        case YSInputValueWithBloodOxygenType:
        {
            controllerType =  YSHtmlControllerWithBloodOxyen;
        }
            break;
        case YSInputValyeWithLungcapacityType:
        {
            controllerType =  YSHtmlControllerWithLung;
        }
            break;
        default:
            break;
    }
    
    AboutYunEs *about = [[AboutYunEs alloc]initWithType:controllerType];
    [self.navigationController pushViewController:about animated:YES];

}

- (NSMutableAttributedString *)attText {
    NSString *text;
    NSInteger length;

    switch (self.testType) {
        case YSInputValueWithBloodPressureType:
        {
            text = @"血压是指血管内的血液对于单位面积血管壁的侧压力，也即压强。高血压是一种以动脉压升高为特征，可伴有心脏、血管、脑和肾脏等器官功能性或器质性改变的全身性疾病，它有原发性高血压和继发性高血压之分";
//            length = 2;
        }
            break;
        case YSInputValyeWithHeartRateType:
        {
            text = @"心率是指正常人安静状态下每分钟心跳的次数，也叫安静心率，一般为60～100次/分，可因年龄、性别或其他生理因素产生个体差异。一般来说，年龄越小，心率越快，老年人心跳比年轻人慢，女性的心率比同龄男性快，这些都是正常的生理现象。";
//            length = 2;
        }
            break;
        case YSInputValueWithBloodOxygenType:
        {
            text = @"血氧饱和度(SpO2)是血液中被氧结合的氧合血红蛋白(HbO2)的容量占全部可结合的血红蛋白(Hb，hemoglobin)容量的百分比，即血液中血氧的浓度，它是呼吸循环的重要生理参数，正常人体动脉血的血氧饱和度为94%-100%。";
//            length = 2;
        }
            break;
        case YSInputValyeWithLungcapacityType:
        {
            text = @"肺活量是指在不限时间的情况下，一次最大吸气后再尽最大能力所呼出的气体量，这代表肺一次最大的机能活动量，是反映人体生长发育水平的重要机能指标之一。肺活量能够显示一个人的心肺功能，肺活量大的人，身体供氧能力更强。";
//            length = 3;
        }
            break;
        default:
            break;
    }
    
    text = [text stringByAppendingString:@"是指血管内血液对于单位面积血管壁的侧压力，即压强。由于血管分动脉、毛细血管和静脉，所以，也就有动脉血压、毛细血管压和静脉血压。通常所说的血压是指动脉血压 。当心室收缩时，主动脉压急剧升高，在收缩中期达到峰值，这时动脉血压值称为收缩压；心室舒张时，主动脉压下降，在心舒末期动脉血压的最低值称为舒张压。收缩压与舒张压的差值称为脉搏压，简称脉压"];
    
    NSMutableAttributedString *attString = [text addAttributeWithString:text attriRange:NSMakeRange(0, 0) attriColor:[UIColor redColor] attriFont:JGFont(18)];
    return attString;
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
            static NSString *gridId = @"relate.identifier.tel";
            YSTelTestController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
            if (!viewController) {
                viewController = [[YSTelTestController alloc] initWithTestType:self.testType];
            }
            viewController.view.backgroundColor = JGWhiteColor;
            
            return viewController;
        }
            break;
       
        case 1:
        {
            static NSString *gridId = @"relate.identifier.Intelligent";
            RXIntelligentEquipmentViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
            if (!viewController) {
                viewController = [[RXIntelligentEquipmentViewController alloc]init];
            }
            viewController.view.backgroundColor = JGWhiteColor;
            return viewController;
        }
            break;
        case 2:
        {
            static NSString *gridId = @"relate.identifier.Manual";
            YSManualTestController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
            if (!viewController) {
                viewController = [[YSManualTestController alloc] initWithTestType:self.testType];
            }
            viewController.view.backgroundColor = JGWhiteColor;
            return viewController;
        }
            break;
        case 3:
        {
            static NSString *gridId = @"relate.identifier.Manual";
            YSManualTestController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
            if (!viewController) {
                viewController = [[YSManualTestController alloc] initWithTestType:self.testType];
            }
            viewController.view.backgroundColor = JGWhiteColor;
            return viewController;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex
{
    [self.view endEditing:YES];
}

- (NSString *)buildNavTitle {
    NSString *title;
    switch (self.testType) {
        case YSInputValueWithBloodPressureType:
            title = @"血压测试";
            break;
        case YSInputValyeWithHeartRateType:
            title = @"心率测试";
            break;
        case YSInputValueWithBloodOxygenType:
            title = @"血氧测试";
            break;
        case YSInputValyeWithLungcapacityType:
            title = @"肺活量";
            break;
        default:
            break;
    }
    return title;
}

@end
