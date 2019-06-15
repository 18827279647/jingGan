//
//  YSFriendCircleController.h
//  jingGang
//
//  Created by dengxf on 16/7/27.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSFriendCircleController : UITableViewController

/**
 *  第一次加载或刷新时数据 */
@property (strong,nonatomic) NSArray *datas;

@property (strong,nonatomic) NSArray *moreDatas;

@property (copy , nonatomic) voidCallback headerCallback;
@property (copy , nonatomic) voidCallback footerCallback;

@property (assign, nonatomic) NSInteger currentRequestPage;

@property (copy , nonatomic) void(^didSelectedRowCallback)(NSInteger selectedRow);

@property (strong,nonatomic) NSMutableArray *array;

@property (copy , nonatomic) voidCallback shrinkMenuCallback;

@property (assign, nonatomic) BOOL shouldShowDeleteButton;

@property (strong,nonatomic) UIView * bjview;
@property (assign,nonatomic) int ispb;

- (void)configTableViewHeaderRefresh;

- (void)configTableViewFooterFefresh;

@end
