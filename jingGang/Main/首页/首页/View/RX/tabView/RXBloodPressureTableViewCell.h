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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shuzhangTrailling;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shouTrailling;



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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xueTangTrailling;

//血脂
@property (weak, nonatomic) IBOutlet UILabel *freeNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *freeTitlelabel;

@property (weak, nonatomic) IBOutlet UIButton *freelishiButton;
@property (weak, nonatomic) IBOutlet UILabel *freeTclabel;
@property (weak, nonatomic) IBOutlet UILabel *freeTcNumberlabel;
@property (weak, nonatomic) IBOutlet UILabel *freeTcStartlabel;
@property (weak, nonatomic) IBOutlet UILabel *freeTcEndlabel;
@property (weak, nonatomic) IBOutlet UIImageView *freeTcBackImage;
@property (weak, nonatomic) IBOutlet UIImageView *freeTcWaiImage;
@property (weak, nonatomic) IBOutlet UILabel *freeTGStartlabel;
@property (weak, nonatomic) IBOutlet UILabel *freeTGendlabel;
@property (weak, nonatomic) IBOutlet UIImageView *freeTGbackImage;
@property (weak, nonatomic) IBOutlet UIImageView *freeTGwaiImage;
@property (weak, nonatomic) IBOutlet UILabel *freeTGlabel;
@property (weak, nonatomic) IBOutlet UILabel *freeTGNumberlabel;

@property (weak, nonatomic) IBOutlet UILabel *freeHDLCStartlabel;
@property (weak, nonatomic) IBOutlet UILabel *freeHDLCEndlabel;

@property (weak, nonatomic) IBOutlet UIImageView *freeHDLCBackimage;

@property (weak, nonatomic) IBOutlet UIImageView *freeHDLCWaiimage;

@property (weak, nonatomic) IBOutlet UILabel *freeHDLCNumberlabel;
@property (weak, nonatomic) IBOutlet UILabel *freeHDLClabel;

@property (weak, nonatomic) IBOutlet UILabel *freeLDLClStartlabel;


@property (weak, nonatomic) IBOutlet UILabel *freeLDLCEndlabel;

@property (weak, nonatomic) IBOutlet UIImageView *freeLDLCBackImage;

@property (weak, nonatomic) IBOutlet UIImageView *freeLDLCWaiImage;
@property (weak, nonatomic) IBOutlet UILabel *freeLDLClabel;

@property (weak, nonatomic) IBOutlet UILabel *freeLDLCNumberlabel;

@property (weak, nonatomic) IBOutlet UILabel *freeJikangTitellabel;
@property (weak, nonatomic) IBOutlet UILabel *freeJikanglabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tcTrailling;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tgTrailling;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hdlcTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ldlcTrailing;


@end

NS_ASSUME_NONNULL_END
