//
//  UnderLineOrderManagerTableViewCell.h
//  jingGang
//
//  Created by thinker on 15/9/9.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionBlock)(NSIndexPath *selectIndexPath);

@interface UnderLineOrderManagerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *serverImage;

@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (copy,nonatomic) ActionBlock commentBlock;
@property (copy,nonatomic) ActionBlock payBlock;
@property (copy,nonatomic) ActionBlock goUseBlock;
@property (nonatomic,strong) NSIndexPath *indexPath;
- (void)configWithObject:(id)object;
@end
