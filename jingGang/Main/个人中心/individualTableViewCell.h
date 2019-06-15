//
//  individualTableViewCell.h
//  jingGang
//
//  Created by yi jiehuang on 15/5/14.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface individualTableViewCell : UITableViewCell

@property (nonatomic, retain)IBOutlet UIImageView *leftImg;
@property (nonatomic, retain)IBOutlet UILabel     *midelLab;

@property (assign, nonatomic) BOOL hiddenRightImageView;


@end
