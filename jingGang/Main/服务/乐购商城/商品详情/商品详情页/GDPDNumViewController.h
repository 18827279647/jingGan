//
//  GDPDNumViewController.h
//  jingGang
//
//  Created by whlx on 2019/3/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDNumTableViewCell.h"
@protocol GDPDNumdelegate <NSObject>
-(void)gaibianle;
@end
@interface GDPDNumViewController : UIViewController
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (nonatomic, copy) NSNumber *goodsId;
@property (nonatomic,strong)PDNumTableViewCell *cell;
@property(nonatomic,weak)id<GDPDNumdelegate>delegate;
@property (nonatomic, copy) void(^change_controllerA_orderIdBlock)(NSString *orderId,NSString * userid);
@end
