//
//  RXShoppingTableViewCell.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol shopinageDelegate <NSObject>

-(void)getKeyGoodId:(NSNumber*)goodId;

@end

@interface RXShoppingTableViewCell : UITableViewCell

@property (nonatomic, strong)id <shopinageDelegate>delegate;

@property(nonatomic,strong)NSMutableArray*keywordGoodsList;

@property(nonatomic,strong)NSMutableDictionary*dic;

@property(nonatomic,assign)bool type;

@end

NS_ASSUME_NONNULL_END
