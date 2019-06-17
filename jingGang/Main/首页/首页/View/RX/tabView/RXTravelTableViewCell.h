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

@end

NS_ASSUME_NONNULL_END
