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
#import "RXTabViewHeightObjject.h"

//智能设备
#import "RXIntelligentEquipmentViewController.h"
//健康一体机
#import "RxHealthIntegrationMachineViewController.h"

#import "Unit.h"

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
        if (self.rxArray.count>0) {
            NSInteger myindex=self.rxArray.count;
            myindex=myindex*2;
            _controllers.magicView.itemSpacing = ScreenWidth/myindex-20;
        }else{
             _controllers.magicView.itemSpacing = ScreenWidth/2-20;
        }
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
    if (self.rxArray.count>0) {
        self.menuLists=[NSArray arrayWithArray:self.rxArray];
    }else{
        self.menuLists = @[@"手机测量",@"手动输入"];
    }
    [self.controllers.magicView reloadData];
    [self.controllers.magicView switchToPage:self.rxIndex animated:NO];
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
    if (![textLab.text isEqualToString:@"暂无介绍"]){
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
    }
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
    about.navString=[RXTabViewHeightObjject getItemCodeNumber:self.rxDic];
    [self.navigationController pushViewController:about animated:YES];
}

- (NSMutableAttributedString *)attText {
    NSString *text;
    NSInteger length;
    if (self.rxArray.count>0) {
        NSString*string=[RXTabViewHeightObjject getItemCodeNumber:self.rxDic];
        if ([string isEqualToString:@"运动步数"]||[string isEqualToString:@"睡眠"]) {
            text=@"暂无介绍";
        }else if([string isEqualToString:@"血压"]){
            text = @"血压（blood pressure，BP）是指血液在血管内流动时作用于单位面积血管壁的侧压力，它是推动血液在血管内流动的动力。在不同血管内被分别称为动脉血压、毛细血管压和静脉血压，通常所说的血压是指体循环的动脉血压";
        }else if([string isEqualToString:@"血糖"]){
            text = @"血中的葡萄糖称为血糖（Glu）。葡萄糖是人体的重要组成成分，也是能量的重要来源。正常人体每天需要很多的糖来提供能量，为各种组织、脏器的正常运作提供动力。所以血糖必须保持一定的水平才能维持体内各器官和组织的需要。正常人血糖的产生和利用处于动态平衡的状态，维持在一个相对稳定的水平，这是由于血糖的来源和去路大致相同的结果。血糖的来源包括：①食物消化、吸收；②肝内储存的糖元分解；③脂肪和蛋白质的转化。血糖的去路包括：①氧化转变为能量；②转化为糖元储存于肝脏、肾脏和肌肉中；③转变为脂肪和蛋白质等其他营养成分加以储存。胰岛是体内调节血糖的血糖浓度的主要器官，肝脏储存肝糖元。此外，血糖浓度还受神经、内分泌激素的调节。";
        }else if([string isEqualToString:@"体重"]){
            text = @"体重(body weight)：裸体或穿着已知重量的工作衣称量得到的身体重量。 体重增长除与骨的增长关系密切以外，还与肌肉，脂肪等的增长有关系。体重增长趋势：在青春期，肌肉的发育比较突出。当身高迅速增长时，肌肉以增加长度为主而明显增长；身高生长缓慢下来时，肌肉以增粗肌纤维为主而明显增长，于是体重随之增加。";
        }else if([string isEqualToString:@"体脂"]){
            text = @"体脂率是指你身体内所有脂肪组织的质量与体重的比值（主要为皮下脂肪和内脏脂肪），体制率叫之BMI来说能更好的说明一个人的“胖瘦”情况。体重过大不一定胖，值提高才是真正的“胖”。体脂肪率是你是否发胖的一个重要指数。基础代谢是维持人体生命活动正常进行一天所需的最低能量，说通俗点，就是一个“植物人”生活一天所消耗的能量（不吃不动不喝躺床上一天所消耗的能量）。身体质量指数，是国际上常用的衡量人体肥胖程度和是否健康的重要标准，主要用于统计分析。BMI通过人体体重和身高两个数值获得相对客观的参数，并用这个参数所处范围衡量身体质量。体重指数BMI=体重/身高的平方（国际单位kg/m²）皮下脂肪（也就是我们平时所了解的身体上可以摸得到的“肥肉”）是贮存于皮下的脂肪组织，在真皮层以下，筋膜层以上。人体的脂肪大约有2/3贮存在皮下组织。通过测量皮下脂肪的厚度，不仅可以了解皮下脂肪的厚度，判断人体的肥瘦情况，而且还可以用所测得皮质厚度推测全身脂肪的数量，评价人身组成的比例。内脏脂肪是人体脂肪中的一种，与皮下脂肪不同，它围绕着人的脏器，主要存在于腹腔内。内脏脂肪对我们的健康意义重大。减去内脏脂肪是健康减肥的根本。内脏脂肪过多是身体代谢紊乱的表现，长期内脏脂肪会导致高血脂、心脑血管疾病、身体器官机能下降等并发症。身体水分占体重的百分比，此数据和肌肉量有着极其密切的关系，因为肌肉中含大量水分（大概70%），这项指标能够反应减重的方式是否正确，如果体水分率下降，不但有损健康，更会令体脂肪率上升。身体年龄，指的是从基础代谢的角度显示你身体的年龄。“身体年龄”是综合评价自己“身体”状况的一个标准。比如一个很健康的人，虽然或许80岁了，看起来只有50岁。骨量是用来代表骨骼的健康状况。不同年龄时间段人体骨量是不同，增肌骨量不仅要补钙，还要补充胶原蛋白。人体体重的成分可分为非脂肪物质与脂肪物质两大部分，肌肉含量是非脂肪物质中去除掉的占体重4%～6%的无机质。肌肉是好东西，肌肉量越大，自己基础代谢就越高，越不容易胖.";
        }else if([string isEqualToString:@"血脂"]){
            text = @"血脂是血浆中的中性脂肪（甘油三酯）和类脂（磷脂、糖脂、固醇、类固醇）的总称，广泛存在于人体中。它们是生命细胞的基础代谢必需物质。一般说来，血脂中的主要成分是甘油三酯和胆固醇，其中甘油三酯参与人体内能量代谢，而胆固醇则主要用于合成细胞浆膜、类固醇激素和胆汁酸。";
        }else if([string isEqualToString:@"尿酸"]){
            text = @"尿酸是嘌呤代谢的终末产物，体内总尿酸的80%由细胞核蛋白分解代谢产生，20%由摄入富含嘌呤的食物分解代谢产生。尿酸基本上以尿酸单钠盐的游离态形式存在于血液中，尿酸池贮存的尿酸盐约1200mg，其中50%～60%每日更新代谢，故每日生成并排泄的尿酸为600～700mg，其中1/3由肠道、2/3由肾脏排出。";
        }else if([string isEqualToString:@"血氧"]){
            text = @"血氧，是指血液中的氧气，人体正常含氧量为90%左右。血液中含氧量越高，人的新陈代谢就越好。当然血氧含量高并不是一个好的现象，人体内的血氧都是有一定的饱和度，过低会造成机体供氧不足，过高会导致体内细胞老化。";
        }else if([string isEqualToString:@"心率"]){
            text = @"心率是指正常人安静状态下每分钟心跳的次数，也叫安静心率，一般为60～100次/分，可因年龄、性别或其他生理因素产生个体差异。一般来说，年龄越小，心率越快，老年人心跳比年轻人慢，女性的心率比同龄男性快，这些都是正常的生理现象。安静状态下，成人正常心率为60～100次/分钟，理想心率应为55～70次/分钟（运动员的心率较普通成人偏慢，一般为50次/分钟左右）";
        }else if([string isEqualToString:@"体温"]){
            text = @"健康人的体温是相对恒定的，当体温超过正常体温的最高限度时称为发热，就是平常人们所说的发烧。传统观念认为正常体温为37℃，但因为测试部位、时间、季节及个体差异等因素的影响，所以现在认为正常体温不能简单以一个数字37℃来表示。";
        }else if([string isEqualToString:@"呼吸"]){
            text = @"呼吸率为一种形容每分钟呼吸的次数的医学术语，胸部的一次起伏就是一次呼吸，即一次吸气一次呼气。呼吸频率随年龄、性别和生理状态而异。成人平静时的呼吸频率约为每分钟12-20次；儿童约为每分钟20次；一般女性比男性快1-2次.它也是医生在临床诊断中的一项重要的诊断依据.";
        }else if([string isEqualToString:@"腰臀比"]){
            text = @"腰臀比(Waist-to-Hip Ratio,WHR)是腰围和臀围的比值，是判定中心性肥胖的重要指标，是预测女性生育力的有效线索，是评价女性吸引力的重要尺度。男性在短期择偶时会优先考虑女性的外貌，而且对低腰臀比的女性拥有更强烈的偏好。在一系列跨文化研究中，不同年龄的男性都认为腰臀比是0.7的女性最有魅力.";
        }else if([string isEqualToString:@"心电图"]){
            text = @"心电图是反映心脏兴奋的电活动过程，它对心脏基本功能及其病理研究方面，具有重要的参考价值。心电图可以分析与鉴别各种心律失常；也可以反应心肌受损的程度和发展过程和心房、心室的功能结构情况。";
        }else{
             text=@"暂无介绍";
        }
        NSMutableAttributedString *attString = [text addAttributeWithString:text attriRange:NSMakeRange(0, 0) attriColor:[UIColor redColor] attriFont:JGFont(18)];
        return attString;
    
    }else{
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

    if (self.rxArray.count>0) {
        NSString*string=self.rxArray[pageIndex];
        if ([string isEqualToString:@"健康一体机"]) {
            static NSString *gridId = @"relate.identifier.HealthIntegrationMachine";
            RxHealthIntegrationMachineViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
            if (!viewController) {
                viewController = [[RxHealthIntegrationMachineViewController alloc]init];
            }
            viewController.view.backgroundColor = JGWhiteColor;
            return viewController;
        }else if([string isEqualToString:@"智能设备"]){
            static NSString *gridId = @"relate.identifier.Intelligent";
            RXIntelligentEquipmentViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
            if (!viewController) {
                viewController = [[RXIntelligentEquipmentViewController alloc]init];
            }
            viewController.view.backgroundColor = JGWhiteColor;
            return viewController;
        }else if([string isEqualToString:@"手机检测"]){
            static NSString *gridId = @"relate.identifier.tel";
            YSTelTestController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
            if (!viewController) {
                NSString*string=[RXTabViewHeightObjject getItemCodeNumber:self.rxDic];
                
                if ([string isEqualToString:@"血压"]) {
                    self.testType=YSInputValueWithBloodPressureType;
                }
                if ([string isEqualToString:@"血氧"]) {
                    self.testType=YSInputValueWithBloodOxygenType;
                }
                if ([string isEqualToString:@"肺活量"]) {
                    self.testType=YSInputValyeWithLungcapacityType;
                }
                if ([string isEqualToString:@"心率"]) {
                    self.testType=YSInputValyeWithHeartRateType;
                }
                viewController = [[YSTelTestController alloc] initWithTestType:self.testType];
            }
            viewController.view.backgroundColor = JGWhiteColor;
            return viewController;
        }else if([string isEqualToString:@"手动输入"]){
            static NSString *gridId = @"relate.identifier.Manual";
            YSManualTestController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
            if (!viewController) {
                viewController = [[YSManualTestController alloc] initWithTestType:self.testType];
                viewController.navString=[RXTabViewHeightObjject getItemCodeNumber:self.rxDic];
                viewController.paramCode=[Unit JSONInt:self.rxDic key:@"itemCode"];
            }
            viewController.view.backgroundColor = JGWhiteColor;
            return viewController;
        }
    }else{
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
    }
    return nil;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex
{
    [self.view endEditing:YES];
}
- (NSString *)buildNavTitle {
    NSString *title;
    if (self.rxArray.count>0) {
        NSString*string=[RXTabViewHeightObjject getItemCodeNumber:self.rxDic];
        return [string stringByAppendingString:@"测试"];
    }else{
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
}

@end
