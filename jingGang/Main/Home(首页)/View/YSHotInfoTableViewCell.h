//
//  YSHotInfoTableViewCell.h
//  jingGang
//
//  Created by 左衡 on 2018/7/31.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YSHotInfoTableViewCell : UITableViewCell
@property (nonatomic, strong)NSDictionary  *models;
@property(nonatomic,strong) NSDictionary *dic;
@property (nonatomic,assign) BOOL isChecked;
@property (assign, nonatomic) BOOL isShare;
@property(nonatomic,strong)NSString *strUrl;
@property(nonatomic,strong)UINavigationController *nav1;
-(void)panduandianzan;
@end

@interface UILabelTopLeft : UILabel
@end
