//
//  YSMassageSettingCell.h
//  jingGang
//
//  Created by dengxf on 17/7/3.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSSettingMyDeviceCell : UITableViewCell

+ (instancetype)setupWithTableView:(UITableView *)tableView unbindCallback:(voidCallback)unbind;


@end

@interface YSMassageSettingData : NSObject

+ (NSArray *)datas;
@end

@interface YSMassageSettingCell : UITableViewCell

+ (instancetype)setupWithTableView:(UITableView *)tableView dict:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath;

@property (copy , nonatomic) bool_block_t swtichValueChangeCallback;

@property (assign, nonatomic) BOOL isOn;

@end
