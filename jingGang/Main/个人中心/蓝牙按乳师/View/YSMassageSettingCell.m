//
//  YSMassageSettingCell.m
//  jingGang
//
//  Created by dengxf on 17/7/3.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSMassageSettingCell.h"
#import "YSMassageBraMacro.h"

@interface YSSettingMyDeviceCell ()

@property (copy , nonatomic) voidCallback unbindCallback;


@end

@implementation YSSettingMyDeviceCell

+ (instancetype)setupWithTableView:(UITableView *)tableView unbindCallback:(voidCallback)unbind{
    static NSString *cellId = @"YSSettingMyDeviceCellId";
    YSSettingMyDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[YSSettingMyDeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = JGBaseColor;
    }
    cell.unbindCallback = unbind;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    UIView *bgView = [UIView new];
    bgView.x = 0;
    bgView.width = ScreenWidth;
    bgView.height = 78.;
    bgView.backgroundColor = JGWhiteColor;
    bgView.y = 0;
    [self.contentView addSubview:bgView];
    
    UILabel *titleLab = [UILabel new];
    titleLab.x = 12.;
    titleLab.y = 18.;
    titleLab.width = 120;
    titleLab.height = 22.;
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = JGRegularFont(15.);
    titleLab.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
    titleLab.text = @"我的设备";
    [bgView addSubview:titleLab];
   
    UILabel *connectDeviceTitleLab = [UILabel new];
    connectDeviceTitleLab.x = titleLab.x;
    connectDeviceTitleLab.y = MaxY(titleLab);
    connectDeviceTitleLab.width = 220;
    connectDeviceTitleLab.height = 18.;
    connectDeviceTitleLab.textAlignment = NSTextAlignmentLeft;
    connectDeviceTitleLab.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
    connectDeviceTitleLab.font = JGRegularFont(12);
    NSArray *localPeripherals = [self achieve:kSaveConnectedPeripheralsKey];
    NSDictionary *bindedPeripheralDict = [localPeripherals lastObject];
    NSString *name = bindedPeripheralDict[YSSavePeripheralNameKey];
    NSString *identifier = bindedPeripheralDict[YSSavePeripheralIdentifierKey];
    NSString *text;
    if (identifier.length) {
        if (identifier.length > 8) {
            NSString *prefix  = [identifier substringToIndex:7];
            text = [NSString stringWithFormat:@"已连接设备:%@-%@",name,prefix];
        }else {
            NSString *preifx = [identifier substringToIndex:identifier.length - 1];
            text = [NSString stringWithFormat:@"已连接设备:%@-%@",name,preifx];
        }
    }else {
         text = [NSString stringWithFormat:@"已连接设备:%@",name];
    }
    connectDeviceTitleLab.text = text;
    [bgView addSubview:connectDeviceTitleLab];
    
    UIButton *unbindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    unbindButton.width = bgView.height;
    unbindButton.height = unbindButton.width;
    unbindButton.x = ScreenWidth - unbindButton.width - 8;
    unbindButton.y = 0;
    [unbindButton setTitle:@"我要解绑" forState:UIControlStateNormal];
    [unbindButton setTitleColor:[YSThemeManager themeColor] forState:UIControlStateNormal];
    unbindButton.titleLabel.font = JGRegularFont(15);
    [unbindButton addTarget:self action:@selector(unbindAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:unbindButton];
    
    UIImageView *warnImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_personal_device_settingwarn"]];
    warnImageView.width = 13;
    warnImageView.height = 13;
    warnImageView.x = 12;
    warnImageView.y = MaxY(bgView) + 12;
    [self.contentView addSubview:warnImageView];
    
    UILabel *warnTextLab = [UILabel new];
    warnTextLab.x = MaxX(warnImageView) + 4;
    warnTextLab.height = 15;
    warnTextLab.y = warnImageView.y - (warnTextLab.height - warnImageView.height) / 2;
    warnTextLab.width = ScreenWidth - warnTextLab.x - 20;
    warnTextLab.text = @"请注意！更换设备后需要解绑才能绑定其他设备！";
    warnTextLab.font = JGRegularFont(12);
    warnTextLab.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
    warnTextLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:warnTextLab];
}

- (void)unbindAction {
    BLOCK_EXEC(self.unbindCallback);
}

@end

@implementation YSMassageSettingData

+ (NSArray *)datas {
    return @[
             @{
                 },
             @{
                 @"title":@"来电提醒",
                 @"desc":@"请注意！开启来电提醒后，如果来电，按摩内衣会连续震动10秒进行提醒并暂停按摩哦！"
                 },
             @{
                 @"title":@"电话防丢",
                 @"desc":@"请注意！开启电话防盗后，如果您的手机离设备超过10-15m，在未按摩状态，智能内衣会连续震动10秒进行提醒；在按摩状态，智能内衣会立即停止按摩哦！"
                 }
             ];
}


@end

@interface YSMassageSettingCell ()

@property (strong,nonatomic) UILabel *titleLab;
@property (strong,nonatomic) UILabel *descLab;
@property (strong,nonatomic) UISwitch *switchControl;
@property (strong,nonatomic) NSDictionary *dict;
@property (strong,nonatomic) NSIndexPath *indexPath;
@end

@implementation YSMassageSettingCell

+(instancetype)setupWithTableView:(UITableView *)tableView dict:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"YSMassageSettingCellId";
    YSMassageSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[YSMassageSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = JGBaseColor;
    }
    cell.dict = dict;
    cell.indexPath = indexPath;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    NSString *titleText = dict[@"title"];
    self.titleLab.text = titleText;
    
    NSString *descText = dict[@"desc"];
    self.descLab.text = descText;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    if (indexPath.row == 1) {
        self.descLab.height -= 12;
    }
}

- (void)setIsOn:(BOOL)isOn {
    _isOn = isOn;
    [self.switchControl setOn:isOn];
}

- (void)setup {
    self.contentView.backgroundColor = JGBaseColor;
    UIView *bgView = [UIView new];
    bgView.x = 0;
    bgView.y = 0;
    bgView.width = ScreenWidth;
    bgView.height = [YSAdaptiveFrameConfig height:54];
    bgView.backgroundColor = JGWhiteColor;
    [self.contentView addSubview:bgView];
    
    UILabel *label = [UILabel new];
    label.x = 12;
    label.height = 27;
    label.y = (bgView.height - label.height) / 2;
    label.width = 100;
    label.font = JGRegularFont(15);
    label.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
    label.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:label];
    self.titleLab = label;
    
    CGFloat switchW = 51;
    CGFloat switchH = 31;
    CGFloat switchX = bgView.width - switchW - 12;
    CGFloat switchY = (bgView.height - switchH) / 2;
    UISwitch *switchControl = [[UISwitch alloc] initWithFrame:CGRectMake(switchX, switchY, switchW, switchH)];
    switchControl.onTintColor = [YSThemeManager buttonBgColor];
    switchControl.on = YES;
    [bgView addSubview:switchControl];
    [switchControl addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    self.switchControl = switchControl;
    
    UILabel *descriLab = [UILabel new];
    descriLab.x = 12.;
    descriLab.y = MaxY(bgView) + 4.;
    descriLab.width = ScreenWidth - descriLab.x * 2;
    descriLab.height = 56;
    descriLab.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
    descriLab.font = JGRegularFont(12);
    descriLab.textAlignment = NSTextAlignmentLeft;
    descriLab.numberOfLines = 0.;
    [self.contentView addSubview:descriLab];
    self.descLab = descriLab;
}

- (void)switchAction:(UISwitch *)switchControl {
    BLOCK_EXEC(self.swtichValueChangeCallback,switchControl.isOn);
}

@end
