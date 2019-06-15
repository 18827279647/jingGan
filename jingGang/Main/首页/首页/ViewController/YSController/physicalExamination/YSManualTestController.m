//
//  YSManualTestController.m
//  jingGang
//
//  Created by dengxf on 16/8/1.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSManualTestController.h"
#import "WSJBloodPressureViewController.h"
#import "WSJHeartRateResultViewController.h"
#import "WSJLungResultViewController.h"
#import "UIAlertView+Extension.h"

@interface YSManualTestInputView ()<UITextFieldDelegate>

@property (copy , nonatomic) NSString *title;
@property (copy , nonatomic) NSString *placeHolder;
@property (assign, nonatomic) NSInteger limiteValue;


@end


@implementation YSManualTestInputView

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                  placeHolder:(NSString *)placeHolder
                  limiteValue:(NSInteger)limiteValue
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        _title = title;
        _placeHolder = placeHolder;
        _limiteValue = limiteValue;
        [self setup];
    }
    return self;
}

- (void)setup {
    UILabel *lab = [[UILabel alloc] init];
    lab.x = 0;
    lab.y = 4;
    lab.width = 90;
    lab.height = self.height - lab.y * 2;
    [self addSubview:lab];
    lab.font = JGFont(16);
    lab.textAlignment = NSTextAlignmentRight;
    lab.text = _title;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.x = MaxX(lab) + 10;
    textField.y = 0;
    textField.width = self.width - textField.x - 20;
    textField.height = self.height - textField.y - 2;
    textField.placeholder = _placeHolder;
    textField.font = JGFont(16);
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.delegate = self;
    [self addSubview:textField];
    self.textFiled = textField;
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.x = MaxX(lab);
    bottomLineView.y = MaxY(textField);
    bottomLineView.width = self.width - bottomLineView.x - 20;
    bottomLineView.height = 1;
    bottomLineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.26];
    [self addSubview:bottomLineView];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeString integerValue] > _limiteValue + 1) {
        return NO;
    }
    return YES;
}



@end

@interface YSManualTestController ()

@property (assign, nonatomic) YSInputValueType testType;

@property (strong,nonatomic) YSManualTestInputView *firstInputView;
@property (strong,nonatomic) YSManualTestInputView *secondInputView;
@end

@implementation YSManualTestController

-(instancetype)initWithTestType:(YSInputValueType)testType {
    if (self = [super init]) {
        self.testType = testType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupWithType:self.testType];
}

- (void)setupWithType:(YSInputValueType)testType {
    /**
     *  血压测试 */
    UIImage *warnningImage = [UIImage imageNamed:@"ys_combined shape"];
    UIImageView *warnningImageView = [[UIImageView alloc] initWithImage:warnningImage];
    warnningImageView.y = 26;
    warnningImageView.width = warnningImage.imageWidth;
    warnningImageView.height = warnningImage.imageHeight;
    [self.view addSubview:warnningImageView];
    
    UILabel *warningLab = [[UILabel alloc] init];
    warningLab.y = warnningImageView.y - 13;
    warningLab.height = 40;
    warningLab.numberOfLines = 0;
    warningLab.font = JGFont(12);
    warningLab.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    [self.view addSubview:warningLab];
    
    NSString *warningText;
    
    CGFloat currentY;
    
    switch (testType) {
        case YSInputValueWithBloodPressureType:
        {
            warningText = @"请输入您的血压值 (单位mmhg)";
            CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
            warningLab.width = textSize.width;
            warningLab.x = (ScreenWidth - warningLab.width) / 2;
            warnningImageView.x = warningLab.x - 10 - warnningImageView.width;
            /**
             *  高压 */
            YSManualTestInputView *highPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(warningLab) + 10, ScreenWidth, 32) title:@"高压:" placeHolder:@"50-250以内的数字" limiteValue:1000];
            [self.view addSubview:highPressureView];
            self.firstInputView = highPressureView;
            
            /**
             *  低压 */
            YSManualTestInputView *lowPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(highPressureView) + 26, ScreenWidth, 32) title:@"低压:" placeHolder:@"30-220以内的数字" limiteValue:1000];
            [self.view addSubview:lowPressureView];
            self.secondInputView = lowPressureView;
            currentY = MaxY(lowPressureView);
        }
            break;
        case YSInputValueWithBloodOxygenType:
        {
            /**
             *  血氧值 */
            warningText = @"请输入您的血氧值 (单位%)";
            CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
            warningLab.width = textSize.width;
            warningLab.x = (ScreenWidth - warningLab.width) / 2;
            warnningImageView.x = warningLab.x - 10 - warnningImageView.width;
            YSManualTestInputView *bloodOxygenView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(warningLab) + 10, ScreenWidth, 32) title:@"血氧值:" placeHolder:@"60 - 100" limiteValue:1000];
            [self.view addSubview:bloodOxygenView];
            self.firstInputView = bloodOxygenView;
            
            currentY = MaxY(bloodOxygenView);
        }
            break;
        case YSInputValyeWithLungcapacityType:
        {
            /**
             *  肺活量值 */
            warningText = @"请输入您的肺活量值";
            CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
            warningLab.width = textSize.width;
            warningLab.x = (ScreenWidth - warningLab.width) / 2;
            warnningImageView.x = warningLab.x - 10 - warnningImageView.width;
            YSManualTestInputView *lungcapacityView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(warningLab) + 10, ScreenWidth, 32) title:@"肺活量值:" placeHolder:@"100-10000" limiteValue:10001];
            [self.view addSubview:lungcapacityView];
            self.firstInputView = lungcapacityView;
            
            currentY = MaxY(lungcapacityView);
        }
            break;
        case YSInputValyeWithHeartRateType:
        {
            warningText = @"请输入您的心率值";
            CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
            warningLab.width = textSize.width;
            warningLab.x = (ScreenWidth - warningLab.width) / 2;
            warnningImageView.x = warningLab.x - 10 - warnningImageView.width;
            YSManualTestInputView *bloodRateView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(warningLab) + 10, ScreenWidth, 32) title:@"心率值:" placeHolder:@"30-220以内的数值" limiteValue:1000];
            [self.view addSubview:bloodRateView];
            self.firstInputView = bloodRateView;
            currentY = MaxY(bloodRateView);

        }
            break;
        default:
            break;
    }
    
    warningLab.text = warningText;
    
    
    UIButton *sureInputButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureInputButton.x = 57. / 2;
    sureInputButton.y = currentY + 20;
    sureInputButton.width = ScreenWidth - sureInputButton.x * 2;
    sureInputButton.height = 44.;
    [self.view addSubview:sureInputButton];
    sureInputButton.titleLabel.font = YSPingFangRegular(16);
    [sureInputButton setTitle:@"确认输入" forState:UIControlStateNormal];
    [sureInputButton setTitleColor:JGWhiteColor forState:UIControlStateNormal];
    sureInputButton.layer.cornerRadius = 6.0;
    [sureInputButton setBackgroundImage:[UIImage imageNamed:@"button222"] forState:UIControlStateNormal];

    sureInputButton.clipsToBounds = YES;
    
    [sureInputButton addTarget:self action:@selector(sureInputAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)textLengthWithTextFiled:(UITextField *)textField {
    if (textField.text.length) {
        return YES;
    }
    return NO;
}

- (void)sureInputAction:(UIButton *)button {
    [self.view endEditing:YES];
    switch (self.testType) {
        case YSInputValueWithBloodPressureType:
        {
            BOOL highRet = [self textLengthWithTextFiled:self.firstInputView.textFiled];
            if (highRet && [self.firstInputView.textFiled.text integerValue] >= 50 && [self.firstInputView.textFiled.text integerValue] <= 250) {
            }else {
                highRet = NO;
            }
            BOOL lowRet = [self textLengthWithTextFiled:self.secondInputView.textFiled];
            if (lowRet && [self.secondInputView.textFiled.text integerValue] >= 30 && [self.secondInputView.textFiled.text integerValue] <= 220) {
                
            }else {
                lowRet = NO;
            }
            
            if (highRet && lowRet) {
                WSJBloodPressureViewController *bloodPrssureVc = [[WSJBloodPressureViewController alloc] initWithPop:^{
                }];
                bloodPrssureVc.lowPressure = [self.secondInputView.textFiled.text integerValue];
                bloodPrssureVc.highPressure = [self.firstInputView.textFiled.text integerValue];
                [self.navigationController pushViewController:bloodPrssureVc animated:YES];
            }else {
                [UIAlertView xf_showWithTitle:@"请输入完整信息" message:nil delay:1.2 onDismiss:NULL];
            }
        }
            break;
        case YSInputValyeWithHeartRateType:
        {
            BOOL heartRateRet = [self textLengthWithTextFiled:self.firstInputView.textFiled];
            if (heartRateRet && [self.firstInputView.textFiled.text integerValue] >= 30 && [self.firstInputView.textFiled.text integerValue] <= 220) {
                
            }else {
                heartRateRet = NO;
            }
            if (heartRateRet) {
                WSJHeartRateResultViewController *heartResult =[[WSJHeartRateResultViewController alloc] initWithNibName:@"WSJHeartRateResultViewController" bundle:nil];
                heartResult.heartRateValue = [self.firstInputView.textFiled.text integerValue];
                [self.navigationController pushViewController:heartResult animated:YES];
            }else {
                [UIAlertView xf_showWithTitle:@"请输入完整信息" message:nil delay:1.2 onDismiss:NULL];
            }
        }
            break;
        case YSInputValueWithBloodOxygenType:
        {
            BOOL bloodOxgenRet = [self textLengthWithTextFiled:self.firstInputView.textFiled];
            if (bloodOxgenRet && [self.firstInputView.textFiled.text integerValue] >= 60 && [self.firstInputView.textFiled.text integerValue] <= 100) {
                
            }else {
                bloodOxgenRet = NO;
            }
            if (bloodOxgenRet) {
                WSJLungResultViewController *lungResultVC = [[WSJLungResultViewController alloc] initWithNibName:@"WSJLungResultViewController" bundle:nil];
                lungResultVC.type = bloodOxygenType;
                lungResultVC.heartRateValue = [self.firstInputView.textFiled.text integerValue];
                [self.navigationController pushViewController:lungResultVC animated:YES];
            }else {
                [UIAlertView xf_showWithTitle:@"请输入完整信息" message:nil delay:1.2 onDismiss:NULL];
            }

        }
            break;
        case YSInputValyeWithLungcapacityType:
        {
            BOOL lungRet = [self textLengthWithTextFiled:self.firstInputView.textFiled];
            if (lungRet && [self.firstInputView.textFiled.text integerValue] >= 100 && [self.firstInputView.textFiled.text integerValue] <= 10000) {
                
            }else {
                lungRet = NO;
            }

            if (lungRet) {
                WSJLungResultViewController *lungResultVC = [[WSJLungResultViewController alloc] initWithNibName:@"WSJLungResultViewController" bundle:nil];
//                lungResultVC.type = lungCapacityType;
                lungResultVC.lungValue = [self.firstInputView.textFiled.text integerValue];
                [self.navigationController pushViewController:lungResultVC animated:YES];
            }else {
                [UIAlertView xf_showWithTitle:@"请输入完整信息" message:nil delay:1.2 onDismiss:NULL];
            }
        }
            break;
            
        default:
            break;
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
