//
//  WSJAddressTableViewCell.h
//  jingGang
//
//  Created by thinker on 15/8/10.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSJAddressTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//设置默认的cell
@property (nonatomic, copy) void (^defaultAddress)(NSIndexPath *indexPath);
//设置cell的数据
- (void) cellWithDictionary:(NSDictionary *)dict;

@end
