//
//  UnderFlashTableViewCell.h
//  jingGang
//
//  Created by 荣旭 on 2019/7/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UnderFlashTableViewCell : UITableViewCell

//体验卷界面数据
- (void) willCustomCellWithData:(NSDictionary *)dict;

//体验卷详情数据
-(void)willCustomDesCellWithData:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
