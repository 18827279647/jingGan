//
//  RXWebViewController.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/26.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "JGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RXWebViewController : JGBaseViewController

@property (copy) NSString *urlstring;
@property (copy) NSString *htmlstring;
@property (copy) NSString *titlestring;

@property(copy)NSString*type;

@property(copy)NSString*historyId;

@end

NS_ASSUME_NONNULL_END
