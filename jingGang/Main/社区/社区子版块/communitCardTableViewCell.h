//
//  communitCardTableViewCell.h
//  jingGang
//
//  Created by thinker on 15/11/18.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleInvitation.h"
#define communitCellRowHeight 146

@interface communitCardTableViewCell : UITableViewCell

@property (nonatomic, retain)IBOutlet UIImageView  *head_img;
@property (nonatomic, retain)IBOutlet UILabel      *main_lab;
@property (nonatomic, retain)IBOutlet UILabel      *time_lab;

@property (retain, nonatomic) IBOutlet UIButton *fallowBT;//跟帖
@property (retain, nonatomic) IBOutlet UIButton *shareBT;//分享
@property (retain, nonatomic) IBOutlet UIButton *numBT;//点赞
@property (retain, nonatomic) IBOutlet UIButton *likeBT;//收藏

@property (nonatomic, copy) void (^shareBlock)();
@property (nonatomic, copy) void (^fallowBlock)();

@property (nonatomic, copy) void (^numWithBlock)(NSDictionary *dict);
@property (nonatomic, copy) void (^likeWithBlock)(NSDictionary *dict);
/**
 *  cell设置数据
 *
 *  @param dict   数据源
 *  @param cricle 是否是圆形头像
 *  @param comStr 时间跟名称中间的一个字
 */
- (void)customCellWithDict:(NSDictionary *)dict withCircle:(BOOL)cricle withTimePast:(NSString *)comStr;


//判断是否收藏过
@property (nonatomic, assign) BOOL isLike;
//判断是否点赞过
@property (nonatomic, assign) BOOL isNum;
//点击分享，改变样式
@property (nonatomic, assign) BOOL isShare;

-(void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font withStr:(NSString *)comStr AndColor:(UIColor *)vaColor;

@end
