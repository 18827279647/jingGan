//
//  RXMoreTableViewCell.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/28.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RXMoreTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *bushulabel;
@property (weak, nonatomic) IBOutlet UILabel *mubiaolabel;
@property (weak, nonatomic) IBOutlet UIButton *sheButton;
@property (weak, nonatomic) IBOutlet UILabel *relianglabel;
@property (weak, nonatomic) IBOutlet UILabel *gonglilabel;

@end

NS_ASSUME_NONNULL_END
