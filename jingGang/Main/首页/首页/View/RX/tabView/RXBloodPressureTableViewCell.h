//
//  RXBloodPressureTableViewCell.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/18.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RXBloodPressureTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UIButton *zhouButton;
@property (weak, nonatomic) IBOutlet UIButton *yueButton;
@property (weak, nonatomic) IBOutlet UIButton *lishiButton;

@property (weak, nonatomic) IBOutlet UILabel *shouStartlabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shouEndlabel;
@property (weak, nonatomic) IBOutlet UIImageView *shouBackImage;
@property (weak, nonatomic) IBOutlet UIImageView *shouWaiImage;
@property (weak, nonatomic) IBOutlet UILabel *shoushuilabel;
@property (weak, nonatomic) IBOutlet UILabel *shoushuiNumberlabel;

@property (weak, nonatomic) IBOutlet UILabel *shuzhangStartLabel;

@property (weak, nonatomic) IBOutlet UILabel *shuzhangEndLabel;

@property (weak, nonatomic) IBOutlet UIImageView *shuzhangbackImage;
@property (weak, nonatomic) IBOutlet UIImageView *shuzhangWaiImage;
@property (weak, nonatomic) IBOutlet UILabel *shuzhanglabel;
@property (weak, nonatomic) IBOutlet UILabel *shuzhangNumberlabel;
@property (weak, nonatomic) IBOutlet UILabel *jiankanglabel;

@property (weak, nonatomic) IBOutlet UILabel *jiankangTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showWaiImageWight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showShuzhangWaiWight;


//体重和血糖使用一个cell
@property (weak, nonatomic) IBOutlet UILabel *twoNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *twoTitlelabel;
@property (weak, nonatomic) IBOutlet UIButton *twolishiButton;
@property (weak, nonatomic) IBOutlet UIButton *twoyueButton;
@property (weak, nonatomic) IBOutlet UIButton *twozhouButton;
@property (weak, nonatomic) IBOutlet UILabel *twoxuelabel;
@property (weak, nonatomic) IBOutlet UILabel *twoxueNumberlabel;
@property (weak, nonatomic) IBOutlet UILabel *twoxueStartlabel;
@property (weak, nonatomic) IBOutlet UILabel *twoxueEndlabel;
@property (weak, nonatomic) IBOutlet UIImageView *twoxuebackImage;
@property (weak, nonatomic) IBOutlet UIImageView *twoxueWaiImage;
@property (weak, nonatomic) IBOutlet UILabel *twojianglabel;

@property (weak, nonatomic) IBOutlet UILabel *twojiangTitle;

    
@end

NS_ASSUME_NONNULL_END
