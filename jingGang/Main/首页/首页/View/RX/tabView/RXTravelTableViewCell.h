//
//  RXTravelTableViewCell.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RXTravelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UIButton *travelButton;
@property (weak, nonatomic) IBOutlet UIImageView *travelImage;
@property (weak, nonatomic) IBOutlet UILabel *conterlabel;
@property (weak, nonatomic) IBOutlet UIImageView *conterMaskImage;

@property (weak, nonatomic) IBOutlet UILabel *contertwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *conterGengDuolabel;

@property (weak, nonatomic) IBOutlet UIImageView *twoBackImage;
@property (weak, nonatomic) IBOutlet UILabel *twoTitlelabel;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;

@property (weak, nonatomic) IBOutlet UIImageView *twoConterlabel;

@property (weak, nonatomic) IBOutlet UILabel *twoWenTilabel;
@property (weak, nonatomic) IBOutlet UILabel *twoGengDuolabel;

@end

NS_ASSUME_NONNULL_END
